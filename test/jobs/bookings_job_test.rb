require 'test_helper'

class BookingsJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  def setup
    @brevo_mock = Minitest::Mock.new
  end

  test 'complete should send completed emails and update status' do
    booking = FactoryBot.create(:booking, :confirmed, end_date: Date.yesterday)

    perform_enqueued_jobs do
      BookingsJob.perform_now
    end

    assert_emails 2 do
      BookingsJob.new.send(:send_completed_emails, [booking])
    end

    assert_equal 'completed', booking.reload.status
  end

  test 'remind should send reminder emails and update status' do
    future_booking = FactoryBot.create(:booking, :pending_future_fixed)
    past_booking = FactoryBot.create(:booking, :pending_past_fixed)
    smtp_email_response = SibApiV3Sdk::CreateSmtpEmail.new
    smtp_email_response.message_id = '<202410041402.67015425952@smtp-relay.mailin.fr>'

    @brevo_mock.expect(:send_transac_email, smtp_email_response) do |send_smtp_email|
      send_smtp_email.is_a?(SibApiV3Sdk::SendSmtpEmail) &&
        send_smtp_email.to.first[:email] == future_booking.couch.user.email &&
        send_smtp_email.params[:guest_first_name] == future_booking.user.first_name &&
        send_smtp_email.params[:host_first_name] == future_booking.couch.user.first_name &&
        send_smtp_email.params[:message] == future_booking.message &&
        send_smtp_email.params[:booking_url] == Rails.application.routes.url_helpers.booking_url(future_booking)
    end

    SibApiV3Sdk::TransactionalEmailsApi.stub(:new, @brevo_mock) do
      perform_enqueued_jobs do
        BookingsJob.perform_now
      end
    end

    @brevo_mock.verify

    assert_equal('expired', past_booking.reload.status)
  end
end

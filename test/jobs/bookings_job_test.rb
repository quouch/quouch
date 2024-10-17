require 'test_helper'

class BookingsJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper
  fixtures :users

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

  test 'should not send reminder emails when day is not monday' do
    Date.stub :today, Date.new(2024, 10, 15) do # 15th October 2024 is a Tuesday
    end
  end

  test 'should send reminder emails when day is monday' do
    Date.stub :today, Date.new(2024, 10, 14) do # 14th October 2024 is a Monday
    end
  end

  test 'should find pending future bookings' do
    FactoryBot.create(:booking, :pending_future_fixed)
    flexible_booking = FactoryBot.build(:booking, :pending_future_flexible)
    flexible_booking.save(validate: false)

    assert_equal 2, BookingsJob.pending_future_bookings.count
  end

  test 'should only send 1 email to each host' do
    user = FactoryBot.create(:user, :offers_couch)
    bookings = FactoryBot.create_list(:booking, 2, :pending_future_fixed, couch: user.couch)

    smtp_email_response = SibApiV3Sdk::CreateSmtpEmail.new
    smtp_email_response.message_id = '<202410041402.67015425952@smtp-relay.mailin.fr>'

    @brevo_mock.expect(:send_transac_email, smtp_email_response) do |send_smtp_email|
      send_smtp_email.is_a?(SibApiV3Sdk::SendSmtpEmail) &&
        send_smtp_email.to.first[:email] == user.email &&
        send_smtp_email.params[:host_first_name] == user.first_name
    end

    SibApiV3Sdk::TransactionalEmailsApi.stub(:new, @brevo_mock) do
      BookingsJob.new.send(:send_reminder_emails, bookings)
    end

    @brevo_mock.verify
  end

  test 'should expire past bookings' do
    past_booking = FactoryBot.create(:booking, :pending_past_fixed)

    perform_enqueued_jobs do
      BookingsJob.perform_now
    end

    assert_equal('expired', past_booking.reload.status)
  end
end

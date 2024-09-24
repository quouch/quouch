require 'test_helper'

class BookingsJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper
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

    perform_enqueued_jobs do
      BookingsJob.perform_now
    end

    assert_emails 1 do
      BookingsJob.new.send(:send_reminder_emails, [future_booking])
    end

    assert_equal('expired', past_booking.reload.status)
  end
end

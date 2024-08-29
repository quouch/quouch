require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper
  test 'complete should send completed emails and update status' do
    booking = FactoryBot.create(:booking, :to_be_completed)

    assert_emails 2 do
      Booking.complete
    end

    assert_equal 'completed', booking.reload.status
  end

  test 'remind should update status of past pending bookings to expired and send reminder emails for future bookings' do
    past_pending_booking = FactoryBot.create(:booking, :past_pending)
    future_pending_booking = FactoryBot.create(:booking, :future_pending)
    future_pending_flexible_booking = FactoryBot.create(:booking, :future_pending_flexible)
    Booking.remind

    assert_equal 'expired', past_pending_booking.reload.status
    assert_equal 'pending', future_pending_booking.reload.status
    assert_equal 'pending', future_pending_flexible_booking.reload.status
    assert_emails 2
  end

  test 'update_status should update status of given bookings' do
    FactoryBot.create_list(:booking, 2, :pending)
    bookings_relation = Booking.where(status: 'pending')
    Booking.update_status(bookings_relation, 'confirmed')

    bookings_relation.each do |booking|
      assert_equal 'confirmed', booking.reload.status
    end
  end

  test 'send_completed_emails should send emails to guest and host' do
    booking = FactoryBot.create(:booking, :to_be_completed)
    assert_emails 2 do
      Booking.send_completed_emails([booking])
    end
  end

  test 'send_reminder_emails should send reminder emails to hosts' do
    booking = FactoryBot.create(:booking, :future_pending)

    assert_emails 1 do
      Booking.send_reminder_emails([booking])
    end
  end
end

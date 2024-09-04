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

  test 'should update status of past pending bookings to expired and send reminder emails for future bookings' do
    pending_past_fixed_booking = FactoryBot.create(:booking, :pending_past_fixed)
    pending_future_fixed_booking = FactoryBot.create(:booking, :pending_future_fixed)
    pending_future_flexible_booking = FactoryBot.create(:booking, :pending_future_flexible)
    pending_past_flexible_booking = FactoryBot.create(:booking, :pending_past_flexible)

    assert_emails 2 do
      Booking.remind

      assert_equal 'expired', pending_past_fixed_booking.reload.status
      assert_equal 'expired', pending_past_flexible_booking.reload.status
      assert_equal 'pending', pending_future_fixed_booking.reload.status
      assert_equal 'pending', pending_future_flexible_booking.reload.status
    end
  end

  test 'update_status should update status of given bookings' do
    FactoryBot.create_list(:booking, 2, :pending_future_fixed)
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
    booking = FactoryBot.create(:booking, :pending_future_fixed)

    assert_emails 1 do
      Booking.send_reminder_emails([booking])
    end
  end
end

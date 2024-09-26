require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  setup do
    @booking = FactoryBot.create(:booking)
    @host = @booking.couch.user
    @user = @booking.user
  end

  test 'should have a valid factory' do
    assert @booking.valid?
  end

  test 'should allow change if status does not change' do
    assert @booking.status_change_allowed?(:pending, @user)
    assert @booking.status_change_allowed?(:pending, @host)
  end

  test 'should not allow user to confirm booking' do
    assert_not @booking.status_change_allowed?(:confirmed, @user)
    assert_not @booking.status_change_allowed?('confirmed', @user)
  end

  test 'should not allow user to decline booking' do
    assert_not @booking.status_change_allowed?(:declined, @user)
  end

  test 'should allow user to cancel booking' do
    assert @booking.status_change_allowed?(:cancelled, @user)
  end

  test 'should allow host to confirm booking' do
    assert @booking.status_change_allowed?(:confirmed, @host)
    assert @booking.status_change_allowed?('confirmed', @host)
  end

  test 'should allow host to decline booking' do
    assert @booking.status_change_allowed?(:declined, @host)
  end

  test 'should not allow host to cancel booking' do
    assert_not @booking.status_change_allowed?(:cancelled, @host)
  end

  test 'should not be able to expire booking' do
    assert_not @booking.status_change_allowed?(:expired, @host)
    assert_not @booking.status_change_allowed?(:expired, @user)
  end

  test 'should not be able to change status to pending_reconfirmation' do
    assert_not @booking.status_change_allowed?(:pending_reconfirmation, @host)
    assert_not @booking.status_change_allowed?(:pending_reconfirmation, @user)
  end
end

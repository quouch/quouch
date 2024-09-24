# frozen_string_literal: true

require 'test_helper'

# I'm separating the tracking checks cause it adds too much noise to the test file
class BookingsTrackingConcernTest < ActiveSupport::TestCase
  include BookingsConcern

  def setup
    create_seed_user
    # Create the current user
    @user = FactoryBot.create(:user, :for_test, :with_couch)
    @host = FactoryBot.create(:user, :for_test, :with_couch, :offers_couch)

    @booking = FactoryBot.build(:booking)
    @booking.couch_id = @host.couch_id
    @booking.user_id = @user.id

    @amplitude_mock = Minitest::Mock.new
    @amplitude_mock.expect(:call, true, [Booking, String])
  end

  test 'should track amplitude event on post create' do
    AmplitudeEventTracker.stub(:track_booking_event, @amplitude_mock) do
      post_create(@booking)
    end

    assert_mock @amplitude_mock
  end

  test 'should track amplitude event on post update' do
    setup_update_params
    @booking.status = :pending
    @booking.save!

    AmplitudeEventTracker.stub(:track_booking_event, @amplitude_mock) do
      post_update(@booking)
    end

    assert_mock @amplitude_mock
  end

  test 'should track amplitude event on decline' do
    @booking = FactoryBot.build(:booking, user: @host, couch: @user.couch)

    AmplitudeEventTracker.stub(:track_booking_event, @amplitude_mock) do
      decline_booking(@booking)
    end

    assert_mock @amplitude_mock
  end

  test 'should track amplitude event on accept' do
    AmplitudeEventTracker.stub(:track_booking_event, @amplitude_mock) do
      accept_booking(@booking)
    end

    assert_mock @amplitude_mock
  end

  test 'should track amplitude event on cancel' do
    AmplitudeEventTracker.stub(:track_booking_event, @amplitude_mock) do
      cancel_booking(@booking)
    end

    assert_mock @amplitude_mock
  end

  private

  def setup_update_params
    params[:booking] = @booking.attributes
    params[:couch_id] = @host.couch_id
  end

  def booking_params
    booking_params = params.require(:booking).permit(:request, :start_date, :end_date, :number_travellers, :message,
                                                     :flexible)
    booking_params.merge(user_id: current_user.id, couch_id: params[:couch_id])
  end
end

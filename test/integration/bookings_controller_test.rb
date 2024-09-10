require 'test_helper'

class BookingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user, :for_test, :with_couch)
    @couch = @other_user.couch
    @booking = FactoryBot.create(:booking, couch: @couch, user: @other_user)
    sign_in @user
  end

  test 'should create booking and track amplitude event' do
    AmplitudeEventTracker.stub(:track_booking_event, true) do
      assert_difference('Booking.count', 1, 'Booking was not created') do
        post couch_bookings_path(@couch), params: {
          booking: {
            user_id: @user.id,
            couch_id: @couch.id,
            request: 'host',
            start_date: Date.today,
            end_date: Date.today + 1,
            number_travellers: 1,
            message: 'Looking forward to staying!'
          }
        }
      end
    end

    booking = Booking.last
    chat = Chat.last
    message = chat.messages.last

    assert_equal @user, booking.user
    assert_equal 'Looking forward to staying!', message.content
    assert_equal @couch, booking.couch
    assert_equal @other_user, booking.couch.user
    assert_equal Date.today, booking.booking_date
    assert_equal 'pending', booking.status

    assert_enqueued_emails 1
    assert_redirected_to sent_booking_path(booking)
  end

  test 'should update booking and track amplitude event' do
    AmplitudeEventTracker.stub(:track_booking_event, true) do
      patch booking_path(@booking), params: { booking: { message: 'Updated message' } }
    end

    @booking.reload
    assert_equal 'Updated message', @booking.message
    assert_enqueued_emails 1
    assert_redirected_to booking_path(@booking)
  end

  test 'should cancel booking and track amplitude event' do
    AmplitudeEventTracker.stub(:track_booking_event, true) do
      delete cancel_booking_path(@booking)
    end

    @booking.reload
    assert_equal 'cancelled', @booking.status
    assert_enqueued_emails 1
    assert_redirected_to requests_couch_bookings_path(@booking.couch)
  end

  test 'should accept booking and track amplitude event' do
    AmplitudeEventTracker.stub(:track_booking_event, true) do
      patch accept_booking_path(@booking)
    end

    @booking.reload
    assert_equal 'confirmed', @booking.status
    assert_enqueued_emails 1
  end

  test 'should decline booking, send message, and track amplitude event' do
    # Case 1: Message is provided
    AmplitudeEventTracker.stub(:track_booking_event, true) do
      patch decline_and_send_message_booking_path(@booking), params: { message: 'Sorry, cannot host' }
    end

    chat = Chat.last
    @booking.reload
    assert_equal 'declined', @booking.status
    assert_equal 'Sorry, cannot host', chat.messages.last.content
    assert_enqueued_emails 1
    assert_redirected_to chat_path(chat)

    # Case 2: Message is blank
    AmplitudeEventTracker.stub(:track_booking_event, true) do
      patch decline_and_send_message_booking_path(@booking), params: { message: '' }
    end

    @booking.reload
    assert_equal 'declined', @booking.status
    assert_enqueued_emails 1
    assert_redirected_to requests_couch_bookings_path(@booking.couch)
  end
end

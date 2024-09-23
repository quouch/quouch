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
    amplitude_mock = Minitest::Mock.new
    amplitude_mock.expect(:call, true, [Booking, String])
    AmplitudeEventTracker.stub(:track_booking_event, amplitude_mock) do
      assert_difference('Booking.count', 1, 'Booking was not created') do
        assert_difference('Chat.count', 1, 'Chat was not created') do
          assert_difference('Message.count', 1, 'Message was not created') do
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
      end
    end

    booking = Booking.last
    chat = Chat.last
    message = chat.messages.last

    assert_equal @couch, booking.couch
    assert_equal @user, booking.user
    assert_equal Date.today, booking.start_date
    assert_equal 'pending', booking.status

    assert_equal @user, message.user
    assert_equal 'Looking forward to staying!', message.content

    assert_enqueued_emails 1

    assert_redirected_to sent_booking_path(booking)
    assert_mock amplitude_mock
  end

  test 'should update booking and track amplitude event' do
    amplitude_mock = Minitest::Mock.new
    amplitude_mock.expect(:call, true, [Booking, String])
    AmplitudeEventTracker.stub(:track_booking_event, amplitude_mock) do
      patch booking_path(@booking), params: { booking: { message: 'Updated message' } }
    end
    @booking.reload
    assert_equal 'Updated message', @booking.message
    assert_enqueued_emails 1
    assert_redirected_to booking_path(@booking)
    assert_mock amplitude_mock
  end

  test 'should cancel booking and track amplitude event' do
    amplitude_mock = Minitest::Mock.new
    amplitude_mock.expect(:call, true, [Booking, String])
    AmplitudeEventTracker.stub(:track_booking_event, amplitude_mock) do
      delete cancel_booking_path(@booking)
    end

    @booking.reload
    assert_equal 'cancelled', @booking.status
    assert_enqueued_emails 1
    assert_redirected_to requests_couch_bookings_path(@booking.couch)
    assert_mock amplitude_mock
  end

  test 'should accept booking and track amplitude event' do
    amplitude_mock = Minitest::Mock.new
    amplitude_mock.expect(:call, true, [Booking, String])
    AmplitudeEventTracker.stub(:track_booking_event, amplitude_mock) do
      patch accept_booking_path(@booking)
    end

    @booking.reload
    assert_equal 'confirmed', @booking.status
    assert_enqueued_emails 1
    assert_mock amplitude_mock
  end

  test 'should decline booking, send message, and track amplitude event' do
    amplitude_mock = Minitest::Mock.new
    amplitude_mock.expect(:call, true, [Booking, String])

    # Case 1: Message is provided
    AmplitudeEventTracker.stub(:track_booking_event, amplitude_mock) do
      patch decline_and_send_message_booking_path(@booking), params: { message: 'Sorry, cannot host' }
    end
    chat = Chat.last
    assert_redirected_to chat_path(chat)
    @booking.reload
    assert_equal 'declined', @booking.status
    assert_equal 'Sorry, cannot host', chat.messages.last.content
    assert_enqueued_emails 1

    # Case 2: Message is blank
    amplitude_mock.expect(:call, true, [Booking, String])
    AmplitudeEventTracker.stub(:track_booking_event, amplitude_mock) do
      patch decline_and_send_message_booking_path(@booking), params: { message: '' }
    end
    assert_redirected_to requests_couch_bookings_path(@booking.couch)
    @booking.reload
    assert_equal 'declined', @booking.status
    assert_equal 'Sorry, cannot host', chat.messages.last.content
    assert_enqueued_emails 1

    assert_mock amplitude_mock
  end
end

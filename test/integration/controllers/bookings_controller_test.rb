require 'test_helper'

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user, :for_test, :with_couch)
    @host = FactoryBot.create(:user, :for_test, :offers_couch)
    @couch = @host.couch
    @booking = FactoryBot.create(:booking, user: @user, couch: @couch)
    sign_in_as @user
  end

  test 'should get index' do
    get bookings_url(@user.couch)
    assert_response :success

    assert_select 'h1', 'Trips'
    assert_select 'h2', 'Upcoming Trips'

    assert_select '.upcoming-booking', 1
  end

  test 'should not show any requests' do
    get requests_couch_bookings_url(@user.couch)
    assert_response :success

    assert_select 'h1', 'Guests'
    assert_select '.requests__empty', 'No one has requested to stay on your couch yet. Enjoy the silence!'
  end

  test 'should show requests' do
    # Create a request for this user
    FactoryBot.create(:booking, user: @host, couch: @user.couch)
    get requests_couch_bookings_url(@user.couch)
    assert_response :success

    assert_select 'h1', 'Guests'
    assert_select 'h2', 'Upcoming Guests'

    assert_select '.upcoming-request', 1
  end

  test 'should show booking form' do
    get new_couch_booking_url(@couch)
    assert_response :success

    assert_select '.booking-form', 1
    assert_select '.booking-form__button', 1
  end

  test 'should show booking' do
    get booking_url(@booking)
    assert_response :success

    assert_select 'h1', 'Booking Overview'
    assert_select 'h2', 'Your Host'

    assert_select '.booking__details-list > .status', 'Pending'
  end

  test 'should show request to host' do
    # Create a request for this user
    request = FactoryBot.create(:booking, user: @host, couch: @user.couch)

    get request_booking_url(request)

    assert_response :success

    assert_select 'h1', 'Guest Overview'

    assert_select '.booking__details-list > .status', 'Pending'
  end

  test 'should create booking' do
    message_content = 'Test message'
    params = generate_booking_params(message_content)

    assert_difference 'Booking.count', 1, 'A booking should be created' do
      assert_difference 'Chat.count', 1, 'A new chat should be created' do
        assert_difference 'Message.count', 1, 'A new message should be sent' do
          post couch_bookings_url(@couch), params:
        end
      end
    end
    assert_enqueued_emails 1

    assert_redirected_to sent_booking_url(Booking.last)
    follow_redirect!

    assert_select 'h1', 'Your request has been sent!'
    @user.reload
    assert_equal 2, @user.bookings.count
    last_booking = @user.bookings.last!
    assert_equal message_content, last_booking.message
    assert_equal 'pending', last_booking.status
    assert_equal 'host', last_booking.request
    assert_equal Date.today, last_booking.booking_date
    assert_equal message_content, Message.last!.content
  end

  test 'should create a second booking' do
    # Create a chat
    chat = Chat.create!(user_sender: @user, user_receiver: @host)
    chat.messages.create!(content: 'Test message 1', user: @user)

    message_content = 'Test message 2'
    params = generate_booking_params(message_content, :hangout, start_date: Date.today + 10, end_date: Date.today + 12)

    assert_difference 'Booking.count', 1, 'A booking should be created' do
      assert_difference 'Chat.count', 0, 'A new chat should not be created' do
        assert_difference 'Message.count', 1, 'A new message should be sent' do
          post couch_bookings_url(@couch), params:
        end
      end
    end

    assert_redirected_to sent_booking_url(Booking.last)

    @user.reload
    chat.reload
    assert_equal 2, @user.bookings.count
    assert_equal message_content, chat.messages.last!.content
    assert_equal 2, chat.messages.count
  end

  test 'should show edit page' do
    get edit_booking_url(@booking)
    assert_response :success

    assert_select '.booking-form', 1
    assert_select '.booking-form__button', 1
    # check that the form is pre-filled, e.g. message value exists
    assert_select 'textarea[name=?]', 'booking[message]', @booking.message
  end

  test 'should update pending booking' do
    message_content = 'Test message edited'
    params = generate_booking_params(message_content)

    assert_not_equal message_content, @booking.message

    patch(booking_url(@booking), params:)
    assert_enqueued_emails 1
    assert_redirected_to booking_url(@booking)
    assert_includes flash[:notice], 'Request successfully updated!'

    follow_redirect!

    assert_select 'h1', 'Booking Overview'

    @booking.reload
    assert_equal message_content, @booking.message
    assert_equal 'pending', @booking.status
  end

  test 'should update confirmed booking' do
    @booking.confirmed!

    message_content = 'Test message edited'
    params = generate_booking_params(message_content)

    assert_not_equal message_content, @booking.message

    patch(booking_url(@booking), params:)
    assert_enqueued_emails 1
    assert_redirected_to booking_url(@booking)
    assert_includes flash[:notice], 'Booking successfully updated!'

    follow_redirect!

    assert_select 'h1', 'Booking Overview'

    @booking.reload
    assert_equal message_content, @booking.message
    assert_equal 'pending', @booking.status
  end

  test 'should cancel pending booking' do
    assert_equal 'pending', @booking.status

    delete cancel_booking_url(@booking)

    assert_enqueued_emails 1
    assert_redirected_to bookings_path
    assert_includes flash[:notice], 'Booking successfully cancelled'

    @booking.reload
    assert_equal 'cancelled', @booking.status
    assert_equal Date.today, @booking.cancellation_date
  end

  test 'should cancel confirmed booking' do
    @booking.confirmed!
    assert_equal 'confirmed', @booking.status

    delete cancel_booking_url(@booking)

    assert_enqueued_emails 1
    assert_redirected_to bookings_path
    assert_includes flash[:notice], 'Booking successfully cancelled'

    @booking.reload
    assert_equal 'cancelled', @booking.status
    assert_equal Date.today, @booking.cancellation_date
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

  private

  def generate_booking_params(message, request = :host, flexible: false, start_date: Date.today + 2, end_date: Date.today + 4)
    { booking: { request:, start_date:, end_date:, number_travellers: 1,
                 message:, flexible:, user_id: @user.id, couch_id: @couch.id } }
  end
end

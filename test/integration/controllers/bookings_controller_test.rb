require 'test_helper'

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user, :for_test, :with_couch)
    @host = FactoryBot.create(:user, :for_test, :offers_couch)
    @couch = @host.couch

    # Delete all bookings for user and host
    @user.bookings.destroy_all
    @host.bookings.destroy_all

    # create one booking
    @booking = FactoryBot.create(:booking, user: @user, couch: @couch)
    sign_in_as @user
  end

  test 'should get index' do
    # Create a completed and a cancelled booking
    FactoryBot.create(:booking, :past, user: @user, couch: @couch)
    FactoryBot.create(:booking, :cancelled, user: @user, couch: @couch)

    get bookings_url(@user.couch)
    assert_response :success

    assert_select 'h1', 'Trips'
    assert_select 'h2', 'Upcoming Trips'
    assert_select 'h2', 'Past Trips'
    assert_select 'h2', 'Cancelled, Declined & Expired Trips'

    assert_select '.upcoming-booking', 1
    assert_select '.past-booking', 2
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

  test 'should not see unaffiliated booking' do
    request = FactoryBot.create(:booking, user: @host, couch: @user.couch)

    get booking_path(request)
    assert_redirected_to bookings_path
  end

  test 'should not see unaffiliated request' do
    get request_booking_path(@booking)
    assert_redirected_to requests_couch_bookings_path(@user.couch)
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

  test 'should not create booking if start and end date are nil' do
    message_content = 'Test message'
    params = generate_booking_params(message_content, start_date: nil, end_date: nil)

    assert_no_difference 'Booking.count', 'No booking should be created' do
      post couch_bookings_url(@couch), params:
    end

    assert_response :unprocessable_entity
    assert_select '.form-error-booking', 'can\'t be blank', 2
    @user.reload
    assert_equal 1, @user.bookings.count
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

  test 'should update pending booking with dates' do
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

  test 'should not update pending flexible booking without dates' do
    message_content = 'Test message edited'
    params = generate_booking_params(message_content, start_date: nil, end_date: nil, flexible: true)

    assert_not_equal message_content, @booking.message

    patch(booking_url(@booking), params:)

    assert_response :unprocessable_entity
    assert_select '.form-error-booking', 'can\'t be blank', 2
    @booking.reload
    assert_not_equal message_content, @booking.message
    assert_equal 'pending', @booking.status
  end

  test 'should update pending flexible booking to fixed' do
    request = FactoryBot.build(:booking, :pending_future_flexible, user: @user, couch: @couch)
    request.save(validate: false)
    message_content = 'Test message edited'
    params = generate_booking_params(message_content, start_date: Date.today + 2, end_date: Date.today + 4)

    patch(booking_url(request), params:)

    assert_enqueued_emails 1
    assert_redirected_to booking_url(request)
    assert_includes flash[:notice], 'Request successfully updated!'
    follow_redirect!

    assert_select 'h1', 'Booking Overview'

    request.reload
    assert_equal Date.today + 2, request.start_date
    assert_equal Date.today + 4, request.end_date
    assert_equal 'pending', request.status
  end

  test 'should not update booking status' do
    message_content = 'Test message edited'
    params = generate_booking_params(message_content)

    params[:booking][:status] = 'confirmed'

    assert_not_equal message_content, @booking.message

    patch(booking_url(@booking), params:)

    @booking.reload
    assert_equal message_content, @booking.message
    assert_equal 'pending', @booking.status
  end

  test 'should not update booking couch' do
    message_content = 'Test message edited'
    params = generate_booking_params(message_content)

    params[:booking][:couch_id] = FactoryBot.create(:user, :with_couch).couch_id

    assert_not_equal message_content, @booking.message

    patch(booking_url(@booking), params:)

    @booking.reload
    assert_equal message_content, @booking.message
    assert_not_equal params[:booking][:couch_id], @booking.couch_id
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
    assert_includes flash[:notice], 'Request successfully cancelled'

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
    assert_includes flash[:notice], 'Request successfully cancelled'

    @booking.reload
    assert_equal 'cancelled', @booking.status
    assert_equal Date.today, @booking.cancellation_date
  end

  test 'should cancel booking as host' do
    request = FactoryBot.create(:booking, :confirmed, user: @host, couch: @user.couch)
    assert_equal 'confirmed', request.status

    delete cancel_booking_url(request)

    assert_enqueued_emails 1
    assert_redirected_to requests_couch_bookings_path(@user.couch)
    assert_includes flash[:notice], 'Booking successfully cancelled'

    request.reload
    assert_equal 'cancelled', request.status
    assert_equal Date.today, request.cancellation_date
  end

  test 'should accept request' do
    request = FactoryBot.create(:booking, user: @host, couch: @user.couch)

    assert_equal 'pending', request.status

    patch accept_booking_url(request)

    assert_enqueued_emails 1

    request.reload
    assert_equal 'confirmed', request.status
  end

  test 'should not be able to accept already confirmed request' do
    request = FactoryBot.create(:booking, :confirmed, user: @host, couch: @user.couch)

    assert_equal 'confirmed', request.status

    patch accept_booking_url(request)

    assert_response :no_content
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

  test 'should not be able to decline booking as guest' do
    patch decline_and_send_message_booking_path(@booking), params: { message: 'Sorry, I can\'t host you.' }

    assert_includes flash[:error], 'Only the host can decline a booking'
  end

  test 'should decline request and send message' do
    request = FactoryBot.create(:booking, :pending, user: @host, couch: @user.couch)

    message = 'Sorry, I can\'t host you.'
    patch decline_and_send_message_booking_path(request), params: { message: }
    request.reload
    assert_equal 'declined', request.status
    assert_enqueued_emails 1
    assert_redirected_to chat_path(Chat.last)
  end

  test 'should decline request without message' do
    request = FactoryBot.create(:booking, :pending, user: @host, couch: @user.couch)

    patch decline_and_send_message_booking_path(request)
    request.reload
    assert_equal 'declined', request.status
    assert_enqueued_emails 1
    assert_redirected_to requests_couch_bookings_path(@user.couch)
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
    assert_redirected_to bookings_path
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

  private

  def generate_booking_params(message, request = :host, flexible: false, start_date: Date.today + 2,
                              end_date: Date.today + 4)
    { booking: { request:, start_date:, end_date:, number_travellers: 1,
                 message:, flexible:, user_id: @user.id, couch_id: @couch.id },
      couch_id: @couch.id }
  end
end

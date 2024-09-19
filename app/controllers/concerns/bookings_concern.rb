module BookingsConcern
  extend ActiveSupport::Concern

  private

  def prepare_booking_for_save
    booking_data = booking_params
    couch = Couch.find(booking_data['couch_id'])
    booking = Booking.new(booking_data)
    booking.couch = couch
    booking.user = current_user
    booking.booking_date = DateTime.now
    booking
  end

  def post_create(booking)
    booking.pending!
    BookingMailer.with(booking:).new_request_email.deliver_later
    AmplitudeEventTracker.track_booking_event(booking, 'New Booking')
    create_chat_and_message(booking)
  end

  def post_update(booking)
    message = 'Request successfully updated!'
    if booking.pending?
      BookingMailer.with(booking:).request_updated_email.deliver_later
    elsif booking.confirmed?
      message = 'Booking successfully updated!'
      booking.pending!
      BookingMailer.with(booking:).booking_updated_email.deliver_later
    end
    AmplitudeEventTracker.track_booking_event(booking, 'Booking Updated')
    message
  end

  def accept_booking(booking)
    booking.confirmed!
    BookingMailer.with(booking:).request_confirmed_email.deliver_later
    AmplitudeEventTracker.track_booking_event(booking, 'Booking Confirmed')
  end

  def decline_booking(booking, message = nil)
    raise Exceptions::ForbiddenError, 'Only the host can decline a booking' unless requested_by_host?(booking)

    return unless booking.declined!

    AmplitudeEventTracker.track_booking_event(@booking, 'Booking Declined')

    # send message only if there is a message
    if message.present? && !message.blank?
      chat = find_chat(booking.user,
                       current_user) || Chat.create(user_sender_id: current_user.id, user_receiver_id: booking.user.id)
      chat.messages.create(user_id: current_user.id, content: message)
    end

    BookingMailer.with(booking:).request_declined_email.deliver_later
  end

  def requested_by_host?(booking)
    booking.couch.user == current_user
  end

  def requested_by_guest?(booking)
    booking.user == current_user
  end

  def cancel_booking(booking)
    status_before_cancellation = booking.status
    booking.cancelled!
    booking.cancellation_date = DateTime.now

    booking.save!

    AmplitudeEventTracker.track_booking_event(booking, 'Booking Cancelled')

    if requested_by_guest?(booking)
      case status_before_cancellation
      when 'pending'
        BookingMailer.with(booking:).request_cancelled_email.deliver_later
      when 'confirmed'
        BookingMailer.with(booking:).booking_cancelled_by_guest_email.deliver_later
      end

      'Request successfully cancelled!'
    else
      BookingMailer.with(booking:).booking_cancelled_by_host_email.deliver_later
      'Booking successfully cancelled!'
    end
  end

  def create_chat_and_message(booking)
    host = booking.couch.user
    guest = booking.user
    chat = find_chat(guest, host) || Chat.create!(user_sender_id: guest.id, user_receiver_id: host.id)
    chat.messages.create(content: booking.message, user: guest)
  end

  def find_chat(user1, user2)
    Chat.find_by(user_sender_id: user1.id, user_receiver_id: user2.id) ||
      Chat.find_by(user_sender_id: user2.id, user_receiver_id: user1.id)
  end
end

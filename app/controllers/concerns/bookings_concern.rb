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

  def after_create_process(booking)
    booking.pending!
    BookingMailer.with(booking:).new_request_email.deliver_later
    AmplitudeEventTracker.track_booking_event(@booking, 'New Booking')
    create_chat_and_message(booking)
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

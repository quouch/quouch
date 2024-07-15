class BookingsController < ApplicationController
  before_action :set_booking, except: %i[index requests new create]
  before_action :set_couch, only: %i[new create requests]

  def index
    @bookings = Booking.includes(couch: [user: [{photo_attachment: :blob}]]).where(user: current_user).order(start_date: :asc)
    categorized_bookings = @bookings.group_by { |booking| categorize_booking(booking) }
    @upcoming = categorized_bookings[:upcoming] || []
    @cancelled = categorized_bookings[:cancelled] || []
    @completed = categorized_bookings[:completed] || []
  end

  def requests
    @requests = @couch.bookings.includes(:user).order(start_date: :asc)
    categorized_bookings = @requests.group_by { |request| categorize_booking(request) }
    @upcoming = categorized_bookings[:upcoming] || []
    @cancelled = categorized_bookings[:cancelled] || []
    @completed = categorized_bookings[:completed] || []
  end

  def show
    @couch = @booking.couch
    @host = @couch.user
    @guest = @booking.user
    @hosts_array = User.where(id: @host.id)
    @review = Review.new
    @marker = @hosts_array.geocoded.map do |host|
      {
        lat: host.latitude,
        lng: host.longitude,
        marker_html: render_to_string(partial: "marker")
      }
    end
    @chat = Chat.find_by(user_sender_id: @host.id, user_receiver_id: @guest.id) ||
      Chat.find_by(user_sender_id: @guest.id, user_receiver_id: @host.id)
    @host_review = @booking.reviews.find_by(user: @host)
    @guest_review = @booking.reviews.find_by(user: @booking.user)
  end

  def new
    @booking = Booking.new
    @host = @couch.user
    offers(@host)
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.couch = @couch
    @guest = @booking.user
    @host = @couch.user
    @booking.user = current_user
    @booking.booking_date = DateTime.now
    if @booking.save
      @booking.pending!
      track_booking_event_amplitude("New Booking")
      redirect_to sent_booking_path(@booking)
    else
      offers(@host)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @host = @booking.couch.user
    offers(@host)
  end

  def update
    @booking.update(booking_params)
    if @booking.pending?
      flash[:notice] = "Request successfully updated!"
      BookingMailer.with(booking: @booking).request_updated_email.deliver_later
    elsif @booking.confirmed?
      flash[:notice] = "Booking successfully updated!"
      @booking.pending!
      BookingMailer.with(booking: @booking).booking_updated_email.deliver_later
    end
    redirect_to booking_path(@booking)
    track_booking_event_amplitude("Booking Updated")
  end

  def cancel
    status_before_cancellation = @booking.status
    @booking.cancelled!
    @booking.cancellation_date = DateTime.now
    @canceller = current_user
    return unless @booking.save

    if @canceller == @booking.user
      redirect_to bookings_path
      case status_before_cancellation
      when "pending"
        BookingMailer.with(booking: @booking).request_cancelled_email.deliver_later
      when "confirmed"
        BookingMailer.with(booking: @booking).booking_cancelled_by_guest_email.deliver_later
      end
    else
      redirect_to requests_couch_bookings_path(@booking.couch)
      BookingMailer.with(booking: @booking).booking_cancelled_by_host_email.deliver_later
    end
    track_booking_event_amplitude("Booking Cancelled")
  end

  def show_request
    @review = Review.new
    @couch = @booking.couch
    @host = @couch.user
    @guest = @booking.user
    @chat = Chat.find_by(user_sender_id: @guest.id,
      user_receiver_id: @host.id) || Chat.find_by(user_sender_id: @host.id,
        user_receiver_id: @guest.id)
    @host_review = @booking.reviews.find_by(user: @host)
    @guest_review = @booking.reviews.find_by(user: @booking.user)
  end

  def sent
    @host = @booking.couch.user
    @couch = @booking.couch
    @booking = Booking.find(params[:id])
  end

  def confirmed
    @guest = @booking.user
  end

  def accept
    return unless @booking.confirmed!

    BookingMailer.with(booking: @booking).request_confirmed_email.deliver_later
    track_booking_event_amplitude("Booking Confirmed")
  end

  def decline(chat)
    return unless @booking.declined!

    if chat.nil?
      redirect_to requests_couch_bookings_path(@booking.couch)
    else
      redirect_to chat_path(chat)
      BookingMailer.with(booking: @booking).request_declined_email.deliver_later
    end
  end

  def complete
    @booking = Booking.find(params[:id])
    @booking.completed!
    BookingMailer.with(booking: @booking).booking_completed_guest_email.deliver_later
    BookingMailer.with(booking: @booking).booking_completed_host_email.deliver_later
    redirect_to booking_path(@booking)
    track_booking_event_amplitude("Booking Completed")
  end

  def decline_and_send_message
    content = params[:message]

    if content.blank?
      decline(nil)
    else
      chat = Chat.find_by(user_sender_id: @booking.user.id, user_receiver_id: current_user.id) ||
        Chat.find_by(user_sender_id: current_user.id, user_receiver_id: @booking.user.id)

      chat = Chat.create(user_sender_id: current_user.id, user_receiver_id: @booking.user.id) if chat.nil?
      Message.create(user_id: current_user.id, chat:, content:)
      decline(chat)
    end
    track_booking_event_amplitude("Booking Declined")
  end

  private

  def booking_params
    params.require(:booking).permit(:request, :start_date, :end_date, :number_travellers, :message, :flexible)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_couch
    @couch = Couch.includes(:bookings).find(params[:couch_id])
  end

  def categorize_booking(booking)
    if booking.pending? || booking.pending_reconfirmation? || booking.confirmed?
      :upcoming
    elsif booking.cancelled? || booking.declined?
      :cancelled
    else
      :completed
    end
  end

  def offers(host)
    @offers = {}

    @offers[:host] = 0 if host.offers_couch
    @offers[:hangout] = 1 if host.offers_hang_out
    @offers[:cowork] = 2 if host.offers_co_work

    @offers
  end

  def cancel_booking(canceller, booking, status_before_cancellation)
    if canceller == booking.user
      redirect_to bookings_path
      case status_before_cancellation
      when "pending"
        BookingMailer.with(booking:).request_cancelled_email.deliver_later
      when "confirmed"
        BookingMailer.with(booking:).booking_cancelled_by_guest_email.deliver_later
      end
    else
      redirect_to requests_couch_bookings_path(booking.couch)
      BookingMailer.with(booking:).booking_cancelled_by_host_email.deliver_later
    end
  end

  def track_booking_event_amplitude(amplitude_event)
    event = AmplitudeAPI::Event.new(
      user_id: current_user.id.to_s,
      event_type: amplitude_event,
      couch: @booking.couch_id,
      booking: @booking.id,
      flexible: @booking.flexible,
      request: @booking.request,
      status: @booking.status,
      start_date: @booking.start_date,
      end_date: @booking.end_date,
      number_travellers: @booking.number_travellers,
      time: Time.now
    )
    AmplitudeAPI.track(event)
  end
end

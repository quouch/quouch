class BookingsController < ApplicationController
  include BookingsConcern

  before_action :set_booking, except: %i[index requests new create]
  before_action :set_couch, only: %i[new create requests]

  def index
    @bookings = Booking.includes(couch: [user: [{ photo_attachment: :blob }]]).where(user: current_user).order(start_date: :asc)
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

    # User should not be able to see the booking if they are not the guest
    redirect_to bookings_path if @guest != current_user

    @hosts_array = User.where(id: @host.id)
    @review = Review.new
    @marker = @hosts_array.geocoded.map do |host|
      {
        lat: host.latitude,
        lng: host.longitude,
        marker_html: render_to_string(partial: 'partials/marker')
      }
    end

    @chat = find_chat(@host, @guest)
    @host_review = @booking.reviews.find_by(user: @host)
    @guest_review = @booking.reviews.find_by(user: @booking.user)
  end

  def new
    @booking = Booking.new
    @host = @couch.user
    offers(@host)
  end

  def create
    @booking = prepare_booking_for_save
    @couch = @booking.couch
    # Do we use this variable on create?
    @guest = @booking.user
    @host = @couch.user

    if @booking.save
      post_create(@booking)
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
    if @booking.update(update_params)

      confirmation_message = post_update(@booking)

      flash[:notice] = confirmation_message
      redirect_to booking_path(@booking)
    else
      @host = @booking.couch.user
      offers(@host)
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    message = cancel_booking(@booking)
    if requested_by_guest?(@booking)
      redirect_to bookings_path
    else
      redirect_to requests_couch_bookings_path(@booking.couch)
    end
    flash[:notice] = message
  end

  def show_request
    @review = Review.new
    @couch = @booking.couch
    @host = @couch.user
    @guest = @booking.user

    # User should not be able to see the request if they are not the host
    redirect_to requests_couch_bookings_path(current_user.couch) if @host != current_user

    @chat = find_chat(@guest, @host)
    @host_review = @booking.reviews.find_by(user: @host)
    @guest_review = @booking.reviews.find_by(user: @booking.user)
  end

  def sent
    @host = @booking.couch.user
    guest = @booking.user
    @couch = @booking.couch
    @booking = Booking.find(params[:id])
    @chat = find_chat(guest, @host)
  end

  def accept
    accept_booking(@booking)
  end

  def decline_and_send_message
    content = params[:message]

    decline_booking(@booking, content)

    if content.blank?
      redirect_to requests_couch_bookings_path(@booking.couch)
    else
      chat = find_chat(@booking.user, current_user)
      redirect_to chat_path(chat)
    end
    flash[:notice] = 'Request has been declined.'
  rescue Exceptions::ForbiddenError => e
    flash[:error] = e.message
    redirect_to requests_couch_bookings_path(@booking.couch)
  end

  private

  def update_params
    params.require(:booking).permit(:request, :start_date, :end_date, :number_travellers, :message,
                                    :flexible)
  end

  def create_params
    booking_params = update_params
    couch_id = params.require(:couch_id)
    booking_params.merge(user_id: current_user.id, couch_id:)
  end

  def set_couch
    @couch = Couch.find(params[:couch_id])
  end

  def categorize_booking(booking)
    if booking.pending? || booking.pending_reconfirmation? || booking.confirmed?
      :upcoming
    elsif booking.cancelled? || booking.declined? || booking.expired?
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
end

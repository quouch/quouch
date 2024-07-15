class ReviewsController < ApplicationController
  before_action :set_booking
  before_action :set_couch

  def new
    @host = @couch.user
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @host = @booking.couch.user
    @review.user = current_user
    @review.couch = (@host == current_user) ? @booking.user.couch : @host.couch
    @review.booking = @booking
    handle_review(@booking, @review)

    event = AmplitudeAPI::Event.new(
      user_id: current_user.id.to_s,
      event_type: "New Review",
      rating: @review.rating,
      couch: @review.couch.id,
      booking: @review.booking.id,
      time: Time.now
    )

    AmplitudeAPI.track(event)
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def set_couch
    @couch = Couch.find(params[:couch_id])
  end

  def handle_review(booking, review)
    if review.save
      case review.user
      when booking.user
        ReviewMailer.with(booking:).new_review_host_email.deliver_later
        redirect_to booking_path(booking)
      when booking.couch.user
        ReviewMailer.with(booking:).new_review_guest_email.deliver_later
        redirect_to request_booking_path(booking)
      end
    else
      render "bookings/show", locals: {booking:}, status: :unprocessable_entity
    end
  end
end

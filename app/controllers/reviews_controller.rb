class ReviewsController < ApplicationController
	before_action :set_booking
	before_action :set_couch

	def new
		@host = @couch.user
		@review = Review.new
	end

	def create
		@review = Review.new(review_params)
		@review.couch = @couch
		@review.booking = @booking
		@review.user = current_user
		if @review.save
			case @review.user
				when @booking.user
					redirect_to bookings_path
					ReviewMailer.with(booking: @booking).new_review_host_email.deliver_later
				when @booking.couch.user
					redirect_to requests_couch_bookings_path
					ReviewMailer.with(booking: @booking).new_review_guest_email.deliver_later
				end
		else
			render new_couch_booking_review_path(@couch, @booking), notice: "Your review did not save, please try again or contact the Quouch support team"
		end
	end

	private

	def review_params
		params.require(:review).permit(:description, :rating)
	end

	def set_booking
		@booking = Booking.find(params[:booking_id])
	end

	def set_couch
		@couch = Couch.find(params[:couch_id])
	end
end

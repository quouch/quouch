class ReviewsController < ApplicationController
	before_action :set_booking, only: %i[new create]
	before_action :set_couch

	def index
	end

	def new
		@host = @couch.user
		@review = Review.new
	end

	def create
		@review = Review.new(review_params)
		@review.couch = @couch
		@review.booking = @booking
		@review.user = current_user
		if @review.save && @review.user == @booking.user
			redirect_to bookings_path
		elsif @review.save && @review.user == @booking.couch.user
			redirect_to requests_couch_bookings_path
		else
			render new_couch_booking_review_path(@couch, @booking), notice: "Your review did not save, please try again"
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

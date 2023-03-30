class ReviewsController < ApplicationController
	before_action :set_booking
	before_action :set_couch

	def new
		@host = @couch.user
		@review = Review.new
	end

	def create
		@review = Review.new(review_params)
		@review.couch = current_user.couch
		@host = @couch.user
		@review.booking = @booking
		@review.user = current_user
		if @review.save
			case @review.user
			when @booking.user
				ReviewMailer.with(booking: @booking).new_review_host_email.deliver_later
				redirect_to booking_path(@booking)
			when @booking.couch.user
				ReviewMailer.with(booking: @booking).new_review_guest_email.deliver_later
				redirect_to request_booking_path(@booking)
			end
		else
			render template: 'bookings/show', locals: { booking: @booking }
		end
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
end

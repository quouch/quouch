class ReviewsController < ApplicationController
	before_action :set_booking, only: %i[new create]
	before_action :set_couch

	def index
	end

	def new
	end

	def create
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

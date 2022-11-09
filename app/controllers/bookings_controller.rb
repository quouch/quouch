class BookingsController < ApplicationController
	before_action :set_booking, only: %i[show sent edit update destroy]
	before_action :set_couch, only: %i[new sent create]

	def index
		@bookings = Booking.all.where(user: current_user)
	end

	def show
	end

	def new
		@booking = Booking.new
	end

	def create
		@booking = Booking.new(booking_params)
    @booking.couch = @couch
    @booking.user = current_user
		@booking.status = 0
		@booking.booking_date = DateTime.now
		@booking.minimum_amount = @booking.end_date - @booking.start_date
    if @booking.save
      redirect_to sent_path(@couch, @booking), notice: "Your request has been sent."
    else
      render 'bookings/new'
    end
	end

	def edit
	end

	def update
	end

	def destroy
		@booking.destroy
		redirect_to bookings_path
	end

	def sent
		@host = @couch.user
	end

	private

	def booking_params
		params.require(:booking).permit(:start_date, :end_date, :number_travellers)
	end

	def set_booking
		@booking = Booking.find(params[:id])
	end

	def set_couch
		@couch = Couch.find(params[:couch_id])
	end
end

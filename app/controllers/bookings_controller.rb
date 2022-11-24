class BookingsController < ApplicationController
	before_action :set_booking, only: %i[show sent edit update destroy show_request]
	before_action :set_couch, only: %i[new create]

	def index
		@bookings = Booking.all.where(user: current_user)
	end

	def requests
		@requests = Booking.all.select { |booking| booking.couch.user == current_user }
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
      redirect_to sent_booking_path(@booking), notice: "Your request has been sent."
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

	def show_request
	end

	def sent
		@host = @booking.couch.user
	end

	def accept
    @booking.update(status: 1)
    redirect_to bookings_path
  end

  def decline
    @booking.update(status: 2)
    redirect_to bookings_path
  end

	def completed
		@booking.update(status: 3)
		redirect_to bookings_path
	end

	def cancel
		@booking.update(status: -1)
		redirect_to bookings_path
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

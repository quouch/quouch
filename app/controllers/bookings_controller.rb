class BookingsController < ApplicationController
  before_action :find_couch, only: [:new, :create]

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
		@couch = Couch.find(params[:couch_id])
    @booking.couch = @couch
    @booking.user = current_user
		@booking_date = DateTime.now
		@minimum_amount = @booking.start_date - @booking.end_date
    if @booking.save
      redirect_to cities_path
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

	private

	def booking_params
		params.require(:booking).permit(:couch_id, :start_date, :end_date, :number_travellers)
	end

  def find_couch
    @couch = Couch.find(params[:couch_id])
  end
end

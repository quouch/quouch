class PaymentsController < ApplicationController
	def new
    @booking = current_user.bookings.find(params[:booking_id])
    @nights = (@booking.end_date - @booking.start_date).to_i
  end
end

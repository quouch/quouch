class PaymentsController < ApplicationController
	def new
    @booking = Booking.find(params[:booking_id])
    @nights = (@booking.end_date - @booking.start_date).to_i
    @booking_payment = BookingPayment.find_by(booking: @booking)
    @payment = Payment.find(@booking_payment.payment_id)
  end
end

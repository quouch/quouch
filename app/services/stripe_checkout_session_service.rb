class StripeCheckoutSessionService
  def call(event)
    booking = Booking.where(checkout_session_id: event.data.object.id)
    booking.update(payment_status: 1)
  end
end
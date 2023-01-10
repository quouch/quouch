class StripeCheckoutSessionService
  def call(event)
    payment = Payment.find_by(checkout_session_id: event.data.object.id)
    payment.update(status: 1)
  end
end
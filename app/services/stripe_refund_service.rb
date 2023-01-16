class StripeRefundService
  def call(event)
    payment = Payment.where(checkout_session_id: event.data.object.id, operation: 0)
    payment.update(status: 1)
  end
end
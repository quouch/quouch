class StripeCheckoutSessionService
  def call(event)
		checkout_session_id = event.data.object.id
		subscription = Subscription.find_by(checkout_session_id:)
		subscription.update!(stripe_id: event.data.object.subscription)
  end
end

class StripeCheckoutSessionService
  def call(event)
    checkout_session = event.data.object
    subscription = Subscription.find_by(checkout_session_id: checkout_session.id)
    subscription.update!(stripe_id: checkout_session.subscription)
    SubscriptionMailer.with(subscription: @subscription).subscription_successful.deliver_later
  end
end

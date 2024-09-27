class StripeCheckoutSessionService
  def call(event)
    checkout_session = event.data.object
    subscription = Subscription.find_by(checkout_session_id: checkout_session.id)
    subscription.update!(stripe_id: checkout_session.subscription)
    Subscription.where(user_id: subscription.user, stripe_id: nil).destroy_all
    SubscriptionMailer.with(subscription:).subscription_successful.deliver_now
  end
end

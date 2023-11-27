class StripeDeleteSubscriptionService
  def call(event)
    subscription = event.data.object.id
    Subscription.find_by(stripe_id: subscription).destroy
  end
end

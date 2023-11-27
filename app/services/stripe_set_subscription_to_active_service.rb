class StripeSetSubscriptionToActiveService
	subscription = event.data.object.id

	Subscription.find_by(stripe_id: subscription).update!(active: true)
end

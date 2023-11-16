class StripeSetSubscriptionToInactive
	def call(event)
		p event.data
		subscription = event.data.object.id
		Subscription.find_by(stripe_id: subscription)
	end
end

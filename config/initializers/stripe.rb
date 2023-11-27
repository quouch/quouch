require_relative '../../app/services/stripe_checkout_session_service'

Rails.configuration.stripe = {
  publishable_key: ENV.fetch('STRIPE_PUBLISHABLE_KEY'),
  secret_key:      ENV.fetch('STRIPE_SECRET_KEY'),
  signing_secret:  ENV.fetch('STRIPE_WEBHOOK_SECRET_KEY')
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed' do |event|
    StripeCheckoutSessionService.new.call(event)
  end
  # this event is triggered 2 ways:
  # 1. when subscription is deleted by user manually,
  # 2. when subscription is deleted cause its billing cycle is over
  events.subscribe 'customer.subscription.deleted' do |event|
    StripeSetSubscriptionToActiveService.new.call(event)
    StripeDeleteSubscriptionService.new.call(event)
  end
  # this event is triggered when trial for inactive subscription ends
  events.subscribe 'customer.subscription.trial_will_end' do |event|
    StripeSetSubscriptionToActiveService.new.call(event)
  end
end

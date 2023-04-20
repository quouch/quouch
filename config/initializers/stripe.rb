Rails.configuration.stripe = {
  publishable_key: ENV.fetch('STRIPE_PUBLISHABLE_KEY'),
  secret_key:      ENV.fetch('STRIPE_SECRET_KEY'),
  signing_secret:  ENV.fetch('STRIPE_WEBHOOK_SECRET_KEY')
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]
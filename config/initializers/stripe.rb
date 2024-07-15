# Use Rails Credentials to initialize the configuration.
# Pass Rails.env.to_sym to ensure the correct credentials are used based on the environment.
Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.dig(:stripe, :publishable_key),
  secret_key: Rails.application.credentials.dig(:stripe, :secret_key),
  signing_secret: Rails.application.credentials.dig(:stripe, :signing_secret_key)
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.subscribe "checkout.session.completed" do |event|
    StripeCheckoutSessionService.new.call(event)
  end

  events.subscribe "customer.subscription.deleted" do |event|
    StripeDeleteSubscriptionService.new.call(event)
  end
end

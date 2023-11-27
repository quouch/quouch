class StripeCheckoutSessionService
  def call(event)
    checkout_session = event.data.object

    case checkout_session.mode
    when 'setup'
      handle_setup_mode(checkout_session)
    when 'subscription'
      handle_subscription_mode(checkout_session)
    end
  end

  private

  def handle_setup_mode(checkout_session)
    subscription = find_subscription(checkout_session)
    current_subscription = Subscription.find_by(user_id: subscription.user.id, active: true)
    current_stripe_subscription = Stripe::Subscription.retrieve(current_subscription.stripe_id)

    setup_intent = Stripe::SetupIntent.retrieve(checkout_session.setup_intent)
    payment_method_id = setup_intent.payment_method

    # Create the new subscription
    begin
      stripe_subscription = Stripe::Subscription.create(
        {
          customer: current_stripe_subscription.customer,
          billing_cycle_anchor: Time.now.to_i + 5,
          trial_end: current_stripe_subscription.current_period_end,
          items: [{ price: subscription.plan.stripe_price_id }],
          default_payment_method: payment_method_id
        }
      )
    rescue Stripe::StripeError =>
      current_subscription.destroy

      # Notify the user about the error
      flash[:error] = 'Something went wrong updating your subscription, please try again!'
    end

    subscription.update!(stripe_id: stripe_subscription.id)
  end

  def handle_subscription_mode(checkout_session)
    subscription = find_subscription(checkout_session)
    subscription.update!(stripe_id: checkout_session.subscription)
  end

  def find_subscription(checkout_session)
    Subscription.find_by(checkout_session_id: checkout_session.id)
  end
end

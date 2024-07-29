class StripeDeleteSubscriptionService
  def call(event)
    stripe_id = event.data.object.id
    subscription = Subscription.find_by(stripe_id:)
    user_id = User.find(subscription.user_id).id
    plan_id = subscription.plan_id
    return unless subscription

    stripe_subscription = Stripe::Subscription.retrieve(stripe_id)
    stripe_price_id = stripe_subscription.items.data.first.price.id
    cancel_at_period_end = stripe_subscription.cancel_at_period_end

    matching_price_config = find_matching_price_config(stripe_price_id)

    if matching_price_config
      unless cancel_at_period_end
        new_price_id = matching_price_config[:new_price_id]

        user_payment_method_id = fetch_user_payment_method(user_id)

        create_new_subscription(user_id, new_price_id, user_payment_method_id, plan_id)
      end
    else
      Rails.logger.error "No matching price configuration found for stripe_price_id #{stripe_price_id}"
    end

    subscription.destroy
  end

  private

  def find_matching_price_config(stripe_price_id)
    PRODUCTS_PRICE_IDS.each do |price_config|
      return price_config if price_config[:old_price_ids].include?(stripe_price_id)
    end
    nil
  end

  def fetch_user_payment_method(user_id)
    stripe_customer_id = find_stripe_customer_id(user_id)
    customer = Stripe::Customer.retrieve(stripe_customer_id)
    customer.invoice_settings.default_payment_method
  end

  def create_new_subscription(user_id, new_price_id, payment_method_id, plan_id)
    stripe_customer_id = find_stripe_customer_id(user_id)

    new_stripe_subscription = Stripe::Subscription.create(
      customer: stripe_customer_id,
      items: [{ price: new_price_id }],
      default_payment_method: payment_method_id,
      expand: ['latest_invoice.payment_intent']
    )

    Subscription.create(user_id:, stripe_id: new_stripe_subscription.id, plan_id:)
  end

  def find_stripe_customer_id(user_id)
    User.find(user_id).stripe_id
  end
end

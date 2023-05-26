class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  # validates :stripe_id, presence: true, uniqueness: true
  validate :validate_single_subscription

  # after_validation :create_stripe_reference, on: :create
  # before_validation :update_stripe_reference, on: :update
  before_update     :cancel_stripe_subscription, if: :subscription_inactive?

  def create_stripe_reference
    response = Stripe::Subscription.create({
      customer: user.stripe_id,
      items: [
        { price: plan.stripe_price_id }
      ],
      payment_behavior: 'default_incomplete',
      payment_settings: { save_default_payment_method: 'on_subscription' }
    })

    self.stripe_id = response.id
  end

  def update_stripe_reference
    response = Stripe::Subscription.update(
      stripe_id,
      {
        items: [
          { price: plan.stripe_price_id }
        ]
      },
      subscription: stripe_id
    )

    self.stripe_id = response.id
  end

  def cancel_stripe_subscription
    Stripe::Subscription.cancel(stripe_id)
  end

  def subscription_inactive?
    !active
  end

  def validate_single_subscription
    nil?
  end
end

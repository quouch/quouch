class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  validates :stripe_id, presence: true, uniqueness: true

  before_validation :create_stripe_reference, on: :create
  before_update     :cancel_stripe_subscription, if: :subscription_inactive?

  def create_stripe_reference
    response = Stripe::Subscription.create({
      customer: self.user.stripe_id,
      items: [
        { price: self.plan.stripe_price_id }
      ],
      payment_behavior: 'default_incomplete',
      payment_settings: {save_default_payment_method: 'on_subscription'}
    })

    self.stripe_id = response.id
  end

  def cancel_stripe_subscription
    Stripe::Subscription.cancel(stripe_id)
  end

  def subscription_inactive?
    !active
  end
end

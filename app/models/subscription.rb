class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  # validates :stripe_id, presence: true, uniqueness: true

  before_update :cancel_stripe_subscription, if: :subscription_inactive?

  def cancel_stripe_subscription
    Stripe::Subscription.cancel(stripe_id)
  end

  def subscription_inactive?
    !active
  end
end

class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  private

  def cancel_stripe_subscription
    Stripe::Subscription.cancel(stripe_id)
  end
end

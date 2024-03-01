class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  def self.clean_up
    incomplete_subscriptions = Subscription.where(stripe_id: nil)
    return if incomplete_subscriptions.empty?

    incomplete_subscriptions.destroy_all
  end
end

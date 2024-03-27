class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  def stripe_id_present?
    stripe_id.present?
  end
end

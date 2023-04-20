class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  validates :stripe_id, presence: true, uniqueness: true

  before_validation :create_stripe_reference, on: :create

  def create_stripe_reference
    Stripe::Customer.create_source(
      user.stripe_id,
      { source: generate_card_token }
    )
    response = Stripe::Subscription.create({
      customer: user.stripe_id,
      items: [
        { price: plan.stripe_price_id }
      ]
    })
    self.stripe_id = response.id
  end

  def generate_card_token
    Stripe::Token.create({
      card: {
        number: card_number,
        exp_month:,
        exp_year:,
        cvc:
      }
    }).id
  end
end
class Plan < ApplicationRecord
  validates :name, presence: true
  validates :stripe_price_id, presence: true
  validates :stripe_price_id, uniqueness: true
  validates :price_cents, presence: true

  enum interval: %i[month year]

  before_validation :create_stripe_reference, on: :create

  def create_stripe_reference
    response = Stripe::Price.create({
      unit_amount: price_cents,
      currency: 'eur',
      recurring: {
        interval:,
        interval_count: (interval == 'month') ? 6 : nil
      },
      product_data: { name: }
    })
    self.stripe_price_id = response.id
  end
end

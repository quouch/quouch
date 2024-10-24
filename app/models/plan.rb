class Plan < ApplicationRecord
  validates :name, presence: true
  validates :stripe_price_id, presence: true
  validates :stripe_price_id, uniqueness: true
  validates :price_cents, presence: true

  enum interval: %i[month year six_months]

  before_validation :create_stripe_reference, on: :create

  def create_stripe_reference
    response = Stripe::Price.create({
                                      unit_amount: price_cents,
                                      currency: 'eur',
                                      recurring: {
                                        interval: interval == 'year' ? 'year' : 'month',
                                        interval_count: interval == 'six_months' ? 6 : 1
                                      },
                                      product_data: { name: }
                                    })
    self.stripe_price_id = response.id
  end
end

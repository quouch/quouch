class Plan < ApplicationRecord
	validates :name, presence: true
	validates :stripe_price_id, presence: true
	validates :price_cents, presence: true
	validates :name, uniqueness: true
	validates :stripe_price_id, uniqueness: true

	enum interval: %i[month year]

	before_validation :create_stripe_reference, on: :create

	def create_stripe_reference
		response = Stripe::Price.create({
			unit_amount: price_cents,
			currency: 'eur',
			recurring: { interval: },
			product_data: { name: }
		})
		self.stripe_price_id = response.id
	end

	def retrieve_stripe_reference
		Stripe::Price.retrieve(stripe_price_id)
	end
end

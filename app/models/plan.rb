class Plan < ApplicationRecord
	validates :name, presence: true
	validates :stripe_price_id, presence: true
	validates :stripe_price_id, uniqueness: true
	validates :price_cents, presence: true

	enum interval: %i[month year]

	before_validation :create_stripe_reference, on: :create

	def create_stripe_reference
			response = Stripe::Customer.create(email: current_user.email)
			self.stripe_id = response.id
	rescue Stripe::StripeError => e
		handle_stripe_reference_creation_error("Error creating Stripe customer: #{e.message}")
	rescue StandardError => e
		handle_stripe_reference_creation_error("An unexpected error occurred during Stripe customer creation: #{e.message}")
	end

	def handle_stripe_reference_creation_error(error_message)
		flash[:error] = error_message
		redirect_to new_subscription_url
	end
end

class Payment < ApplicationRecord
	has_many :booking_payments
	has_many :bookings, through: :booking_payments

	enum status: { awaiting: 0, fulfilled: 1 }
	enum operation: { full_refund: -1, partial_refund: 0, payment: 1, additional_payment: 2 }

	monetize :amount_cents
end

class Payment < ApplicationRecord
	has_many :booking_payments
	has_many :bookings, through: :booking_payments

	enum status: { awaiting: 0, setup: 1, fulfilled: 2 }
	enum operation: { refund: -1, partial_refund: 0, payment: 1 }

	monetize :amount_cents
end

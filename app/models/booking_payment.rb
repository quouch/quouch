class BookingPayment < ApplicationRecord
	belongs_to :booking
	belongs_to :payment
end

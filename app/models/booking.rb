class Booking < ApplicationRecord
  belongs_to :couch
  belongs_to :user

  enum status: { pending: 0, processing_payment: 1, confirmed: 2, cancelled: -1 }
end

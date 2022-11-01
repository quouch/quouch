class Booking < ApplicationRecord
  belongs_to :couch
  belongs_to :user
  has_one :review

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :donation_amount, numericality: true, allow_nil: true

  enum status: { pending: 0, confirmed: 1, completed: 2, cancelled: -1 }
end

class Booking < ApplicationRecord
  belongs_to :couch
  belongs_to :user
  has_one :review

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :donation_amount, numericality: true, allow_nil: true
  validate :date_in_future?
  validate :valid_dates?


  enum status: { pending: 0, confirmed: 1, declined: 2, completed: 3, cancelled: -1 }

  def date_in_future?
    if Date.yesterday > start_date
      errors.add(:start_date, "Booking can't be in the past")
    end
  end

  def valid_dates?
    if start_date > end_date
      errors.add(:start_date, "Dates not valid")
    end
  end
end

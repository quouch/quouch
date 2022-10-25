class Review < ApplicationRecord
  belongs_to :booking
  belongs_to :couch
  belongs_to :user

  validates :description, presence: true, length: { minimum: 100, too_short:
    "We would love to hear more details about your stay - please write at least 100 characters" }
  validates :rating, presence: true, inclusion: { in: ['1', '2', '3', '4', '5'] }
end

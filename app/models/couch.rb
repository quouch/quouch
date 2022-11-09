class Couch < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :couch_facilities
  has_many :facilities, through: :couch_facilities

  validates :capacity, inclusion: { in: [1, 2, 3, 4, 5, 6] }
end

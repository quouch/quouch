class Couch < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_one :city, through: :user

  pg_search_scope :search_by_city, associated_against: {
    city: :name
  }

  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :couch_facilities, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :couch_facilities
  has_many :facilities, through: :couch_facilities

  validates :capacity, inclusion: { in: [1, 2, 3, 4, 5, 6] }
end

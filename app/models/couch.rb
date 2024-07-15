class Couch < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_many :user_characteristics, through: :user
  has_many :characteristics, through: :user_characteristics
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :couch_facilities, dependent: :destroy, autosave: true
  has_many :facilities, through: :couch_facilities
  accepts_nested_attributes_for :couch_facilities

  scope :active, -> { joins(:user).where(users: {offers_couch: true}) }

  pg_search_scope :search,
    associated_against: {
      user: %i[
        city
        country
      ]
    },
    using: {
      tsearch: {prefix: true}
    }
end

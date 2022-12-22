class City < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name,
    against: [ :name ],
    using: {
      tsearch: { prefix: true }
    }
  
  belongs_to :country
  has_many :users

  validates :name, inclusion: { in:
    ['Berlin', 'Paris', 'Madrid', 'Rome', 'Athens', 'Lisbon', 'London', 'Amsterdam'] }
end

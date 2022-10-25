class City < ApplicationRecord
  belongs_to :country
  has_many :users

  validates :name, inclusion: { in:
    ['Berlin', 'Paris', 'Madrid', 'Rome', 'Athens', 'Lisbon', 'London', 'Amsterdam'] }
end

class Country < ApplicationRecord
  has_many :cities
  has_many :users, through: :cities

  validates :name, inclusion: { in:
    ['Germany', 'France', 'Spain', 'Italy', 'Greece', 'Portugal', 'United Kingdom', 'Netherlands'] }
end

class Country < ApplicationRecord
  has_many :cities
  has_many :users

  validates :name, presence: { message: 'Country required' }
end

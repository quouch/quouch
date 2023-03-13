class City < ApplicationRecord  
  belongs_to :country
  has_many :users

  validates :name, presence: { message: 'City required' }
end

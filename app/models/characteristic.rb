class Characteristic < ApplicationRecord
  has_many :user_characteristics, dependent: :destroy
  has_many :users, through: :user_characteristics
  has_many :couches, through: :users
end

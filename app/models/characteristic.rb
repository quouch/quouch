class Characteristic < ApplicationRecord
	has_many :user_characteristics
	has_many :users, through: :user_characteristics
end

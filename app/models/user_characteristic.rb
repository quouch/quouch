class UserCharacteristic < ApplicationRecord
  belongs_to :user
  belongs_to :characteristic

  validates :characteristic, uniqueness: {scope: :user}
end

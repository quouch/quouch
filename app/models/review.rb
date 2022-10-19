class Review < ApplicationRecord
  belongs_to :booking
  belongs_to :couch
  belongs_to :user
end

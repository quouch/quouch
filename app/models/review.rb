class Review < ApplicationRecord
  belongs_to :booking
  belongs_to :couch
  belongs_to :user

  validates :content, presence: {message: "Please add a few lines about your experience"}
  validates :rating, presence: {message: "Please leave a rating"}
end

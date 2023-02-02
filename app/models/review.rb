class Review < ApplicationRecord
  belongs_to :booking
  belongs_to :couch
  belongs_to :user

  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: [1, 2, 3, 4, 5] }
  validates :booking, uniqueness: true
end

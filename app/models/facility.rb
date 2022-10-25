class Facility < ApplicationRecord
  has_many :couch_facilities
  has_many :couches, through: :couch_facilities

  validates :name, inclusion: { in: ['shower', 'bathtub', 'wifi', 'pets', 'microwave', 'TV', 'laundry'] }
end

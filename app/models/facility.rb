class Facility < ApplicationRecord
  has_many :couch_facilities
  has_many :couches, through: :couch_facilities
  has_one_attached :image

  validates :name, inclusion: { in: ['couch', 'bed', 'shared bathroom', 'private bathroom', 'wifi', 'pets allowed',
                                     'shared kitchen', 'TV', 'washing machine', 'public transport', 'private room',
                                     'supermarket', 'smoking allowed'] }
end

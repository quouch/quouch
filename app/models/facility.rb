class Facility < ApplicationRecord
  has_many :couch_facilities
  has_many :couches, through: :couch_facilities
  has_one_attached :svg
end

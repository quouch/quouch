class CouchFacility < ApplicationRecord
  belongs_to :couch
  belongs_to :facility

  validates :facility, uniqueness: {scope: :couch}
end

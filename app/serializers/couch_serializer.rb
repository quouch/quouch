# frozen_string_literal: true

# Serializer with the attributes for the Couch that will be returned by the JSON API:
class CouchSerializer < BaseSerializer
  belongs_to :user
  has_many :facilities
  has_many :bookings
  has_many :reviews

  attributes :id, :user_id, :capacity, :active, :rating

  attribute :user do |couch|
    UserSerializer.new(couch.user).serializable_hash[:data][:attributes]
  end

  attribute :facilities do |couch|
    couch.facilities.map do |facility|
      FacilitySerializer.new(facility).serializable_hash[:data][:attributes]
    end
  end
end

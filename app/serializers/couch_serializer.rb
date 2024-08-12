# frozen_string_literal: true

# Serializer with the attributes for the Couch that will be returned by the JSON API:
class CouchSerializer
  include JSONAPI::Serializer
  belongs_to :user, serializer: UserSerializer

  attributes :id, :user_id

  attribute :user do |couch|
    UserSerializer.new(couch.user).serializable_hash[:data][:attributes]
  end
end

# frozen_string_literal: true

# Serializer with the attributes for the User that will be returned by the JSON API:
class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :first_name
end

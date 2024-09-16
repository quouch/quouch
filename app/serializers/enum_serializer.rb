# frozen_string_literal: true

# Serializer with the attributes for the User that will be returned by the JSON API:
class EnumSerializer < BaseSerializer
  attributes :id, :name
end

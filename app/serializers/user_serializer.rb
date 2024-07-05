# frozen_string_literal: true

module ProfilePictureHelper
  extend ActiveSupport::Concern

  class_methods do
    def photo_url(user)
      user.photo.url
    end
  end
end

# Serializer with the attributes for the User that will be returned by the JSON API:
class UserSerializer
  include JSONAPI::Serializer
  include ProfilePictureHelper # mixes in your helper method as class method

  attributes :id, :email, :first_name, :last_name

  has_one :couch

  attribute :photo do |user|
    photo_url(user)
  end
end

# frozen_string_literal: true

module ProfilePictureHelper
  extend ActiveSupport::Concern

  class_methods do
    def photo_url(user)
      if Rails.configuration.active_storage.service == :test
        h = "http://#{Rails.application.routes.default_url_options[:host]}"
        ::ActiveStorage::Current.set(url_options: { host: h }) { user.photo.url }
      else
        user.photo.url
      end
    end
  end
end

# Serializer with the attributes for the User that will be returned by the JSON API:
class UserSerializer < BaseSerializer
  include ProfilePictureHelper # mixes in your helper method as class method

  set_key_transform :camel_lower

  attributes :id, :email, :first_name, :last_name, :city, :country, :zipcode, :address, :created_at, :updated_at

  has_one :couch

  attribute :photo do |user|
    photo_url(user)
  end
end

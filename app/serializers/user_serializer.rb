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

  set_type :user

  has_one :couch

  attributes :id, :created_at, :updated_at, :email, :first_name, :last_name, :date_of_birth, :summary,
             :city, :country, :zipcode, :address, :offers_couch, :offers_hang_out, :offers_co_work, :travelling, :summary

  attribute :age, &:calculated_age

  attribute :photo do |user|
    photo_url(user)
  end

  attribute :characteristics do |user|
    # Return only ID and name of the characteristics
    user.characteristics.map { |c| { id: c.id, name: c.name } }
  end
end

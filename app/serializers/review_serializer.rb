# frozen_string_literal: true

class ReviewSerializer < BaseSerializer
  belongs_to :booking
  belongs_to :couch
  belongs_to :user

  attributes :id, :content, :rating, :booking_id, :user_id, :couch_id, :created_at, :updated_at
end

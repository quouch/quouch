# frozen_string_literal: true

class ReviewSerializer < BaseSerializer
  belongs_to :user
  belongs_to :couch
  belongs_to :booking

  attributes :content, :id, :rating
end

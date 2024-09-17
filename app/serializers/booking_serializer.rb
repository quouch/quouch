# frozen_string_literal: true

class BookingSerializer < BaseSerializer
  belongs_to :user
  belongs_to :couch

  has_many :reviews

  attributes :id, :user_id, :couch_id, :start_date, :end_date, :status, :request, :message,
             :booking_date, :cancellation_date, :created_at, :updated_at, :number_travellers, :flexible
end

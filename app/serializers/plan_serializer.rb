# frozen_string_literal: true

class PlanSerializer < BaseSerializer
  attributes :id, :name, :description, :price_cents, :stripe_price_id, :interval, :collection, :created_at, :updated_at
end

# frozen_string_literal: true

module Api
  module V1
    class PlansController < ApiController
      def index
        render jsonapi: Plan.all
      end
    end
  end
end

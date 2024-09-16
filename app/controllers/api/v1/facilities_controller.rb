# frozen_string_literal: true

module Api
  module V1
    class FacilitiesController < ApiController
      skip_before_action :check_basic_auth

      def index
        render jsonapi: Facility.all
      end
    end
  end
end

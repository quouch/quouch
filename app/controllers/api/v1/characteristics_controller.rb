# frozen_string_literal: true

module Api
  module V1
    class CharacteristicsController < ApiController
      skip_before_action :check_basic_auth

      def index
        render jsonapi: Characteristic.all
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    # ApiController: This controller is responsible for handling the API requests.
    class ApiController < ActionController::API
      include JSONAPI::Filtering
      include JSONAPI::Pagination
      include JSONAPI::Fetching
      include JSONAPI::Errors

      include ActionController::HttpAuthentication::Basic::ControllerMethods
      include ActionController::HttpAuthentication::Token::ControllerMethods
      include JwtTokenHelper

      before_action :check_basic_auth

      respond_to? :json

      private

      def check_basic_auth
        unless request.authorization.present?
          head :unauthorized
          return
        end

        authenticate_with_http_basic do |email, password|
          user = User.find_by(email: email.downcase)

          if user&.authenticate(password)
            @current_user = user
          else
            head :unauthorized
          end
        end

        authenticate_with_http_token do |token, _options|
          @current_user = find_user_by_jwt_token(token)
        end

        head :unauthorized unless @current_user
      end

      def jsonapi_meta(resources)
        pagination = jsonapi_pagination_meta(resources)

        { pagination: } if pagination.present?
      end

      attr_reader :current_user
    end
  end
end

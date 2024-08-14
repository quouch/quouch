# frozen_string_literal: true

module Api
  module V1
    # ApiController: This controller is responsible for handling the API requests.
    class ApiController < ActionController::API
      include ActionController::HttpAuthentication::Basic::ControllerMethods
      include ActionController::HttpAuthentication::Token::ControllerMethods
      include JwtTokenHelper

      before_action :check_basic_auth

      respond_to? :json

      rescue_from ActiveRecord::RecordNotFound do |e|
        render json: {
          code: 404,
          error: 'Record not found.',
          message: e.message
        }, status: :not_found
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        render json: {
          code: 404,
          error: 'Record not found.',
          message: e.message
        }, status: :not_found
      end

      rescue_from JwtError do |e|
        render json: {
          code: 401,
          error: 'Invalid token.',
          message: e
        }, status: :unauthorized
      end

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

      def pagy_metadata(pagy)
        {
          page: pagy.page,
          items: pagy.items,
          total: pagy.count,
          from: pagy.from,
          to: pagy.to,
          prev: pagy.prev,
          next: pagy.next,
          last: pagy.last
        }
      end

      attr_reader :current_user
    end
  end
end

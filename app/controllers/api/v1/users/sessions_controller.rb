# frozen_string_literal: true

module Api
  module V1
    module Users
      # SessionsController: This controller is responsible for handling the user's login and logout.
      class SessionsController < Devise::SessionsController
        include RackSessionsFix
        include JwtTokenHelper

        # Skip the CSRF token verification for the API login and logout.
        skip_before_action :verify_authenticity_token

        respond_to? :json

        rescue_from JwtError do |e|
          render json: {
            code: 401,
            message: 'Invalid token.',
            data: {
              errors: [e]
            }
          }, status: :unauthorized
        end

        protected

        def require_no_authentication
          assert_is_devise_resource!
          return unless is_navigational_format?

          no_input = devise_mapping.no_input_strategies

          authenticated = if no_input.present?
                            args = no_input.dup.push scope: resource_name
                            warden.authenticate?(*args)
                          else
                            warden.authenticated?(resource_name)
                          end

          return unless authenticated && warden.user(resource_name)

          render json: {
            code: 409,
            message: "You're already signed in."
          }, status: :conflict
        end

        private

        def respond_with(current_user, _opts = {})
          if current_user.nil?
            render json: {
              code: 401,
              message: 'Invalid login credentials. Please try again.',
            }, status: :unauthorized, error_status: :unauthorized
          else
            render json: {
              code: 200,
              message: 'Logged in successfully.',
              data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
            }, status: :ok
          end
        end

        def respond_to_on_destroy
          if jwt_token_is_valid?(request.authorization)
            render json: {
              code: 200,
              message: 'Logged out successfully.'
            }, status: :ok
          else
            render json: {
              code: 401,
              message: "Couldn't find an active session."
            }, status: :unauthorized
          end
        end
      end
    end
  end
end

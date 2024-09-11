# frozen_string_literal: true

module Api
  module V1
    module Users
      # SessionsController: This controller is responsible for handling the user's login and logout.
      class SessionsController < Devise::SessionsController
        include RackSessionsFix
        include JwtTokenHelper
        include ApiHelper

        # Skip the CSRF token verification for the API login and logout.
        skip_before_action :verify_authenticity_token

        respond_to? :json

        rescue_from JwtError do |e|
          render_error(status: :unauthorized, title: 'Invalid token.', detail: e.message)
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

          render_error(status: :conflict, title: 'Conflict', detail: 'You are already signed in.')
        end

        private

        def respond_with(current_user, _opts = {})
          if current_user.nil? || current_user.id.nil?
            render_error(status: :unauthorized, title: 'Invalid login credentials.')
          else
            options = {
              meta: {
                message: 'Logged in successfully.'
              }
            }
            render json: UserSerializer.new(current_user, options).serializable_hash
          end
        end

        def respond_to_on_destroy
          if jwt_token_is_valid?(request.authorization)
            render json: {
              meta: {
                message: 'Logged out successfully.'
              }
            }, status: :ok
          else
            render_error(status: :unauthorized, title: 'Unauthorized', detail: 'Couldn\'t find an active session.')
          end
        end
      end
    end
  end
end

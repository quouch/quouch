# frozen_string_literal: true

module Api
  module V1
    module Users
      # SessionsController: This controller is responsible for handling the user's login and logout.
      class SessionsController < Devise::SessionsController
        include RackSessionsFix
        include JwtTokenHelper
        include JSONAPI::Errors

        # Skip the CSRF token verification for the API login and logout.
        skip_before_action :verify_authenticity_token

        respond_to? :json

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

            render jsonapi: current_user
          end
        end

        def respond_to_on_destroy
          raise JwtError unless jwt_token_is_valid?(request.authorization)

          render jsonapi: [], status: :ok
        end

        def jsonapi_meta(_resources)
          return {} if response.status != 200

          message = 'Logged in successfully.'
          message = 'Logged out successfully.' if request.params[:action] == 'destroy'

          # if the logout response is successful, add a message to the metadata
          { message: }
        end
      end
    end
  end
end

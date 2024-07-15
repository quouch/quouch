# frozen_string_literal: true

module Api
  module V1
    module Users
      # SessionsController: This controller is responsible for handling the user's login and logout.
      class SessionsController < Devise::SessionsController
        include RackSessionsFix
        # Skip the CSRF token verification for the API login and logout.
        skip_before_action :verify_authenticity_token

        respond_to? :json

        def respond_with(current_user, _opts = {})
          render json: {
            status: {
              code: 200, message: "Logged in successfully.",
              data: {user: UserSerializer.new(current_user).serializable_hash[:data][:attributes]}
            }
          }, status: :ok
        end

        def respond_to_on_destroy
          if request.headers["Authorization"].present?
            jwt_payload = JWT.decode(request.headers["Authorization"].split.last,
              Rails.application.credentials.dig(:devise, :jwt_secret_key)).first
            current_user = User.find(jwt_payload["sub"])
          end

          if current_user
            render json: {
              status: 200,
              message: "Logged out successfully."
            }, status: :ok
          else
            render json: {
              status: 401,
              message: "Couldn't find an active session."
            }, status: :unauthorized
          end
        end
      end
    end
  end
end

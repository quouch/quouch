module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        include RegistrationConcern
        include JSONAPI::Deserialization
        include JSONAPI::Errors

        respond_to :json

        def edit
          render jsonapi: current_user
        end

        def update
          # Make sure that ONLY the logged in user is being edited!
          update_user_characteristics if params[:user_characteristic]
          super do |resource|
            disable_offers_if_travelling(resource)
          end
        end

        def respond_with(current_user, _opts = {})
          if resource.persisted?
            render jsonapi: current_user
          else
            # Fixme: raise an error instead of using render_error
            message = "User couldn't be created successfully."

            render_error(status: :unprocessable_entity,
                         title: 'User could not be created.',
                         detail: message,
                         source: current_user.errors)
          end
        end

        protected

        def jsonapi_meta(_resource)
          message = 'Signed up successfully.'
          message = 'Updated successfully.' if request.params[:action] == 'update'

          { message: }
        end

        def account_update_params
          params.require(:data).require(%i[id type attributes])

          # Raise a forbidden error if the user is trying to edit another user
          raise JSONAPI::ForbiddenError, 'You are not allowed to edit this user.' unless current_user.id.to_s == params[:id]

          jsonapi_deserialize(params, only: %i[first_name last_name email password password_confirmation country city])
        end
      end
    end
  end
end

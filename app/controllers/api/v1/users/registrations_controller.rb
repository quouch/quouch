module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        include RegistrationConcern

        respond_to :json, :html

        def update
          # Update all the allowed user attributed
          user_params = params.require(:user).permit(:first_name, :last_name, :email, :password,
                                                     :password_confirmation, :country, :city)

          @user.update(**user_params)

          update_user_characteristics if params[:user_characteristic]

          super
          beautify_country if params[:user][:country] || params[:user][:city]
          disable_offers_if_travelling
        end

        def respond_with(current_user, _opts = {})
          message = 'Signed up successfully.'
          message = 'Updated successfully.' if request.params[:action] == 'update'
          if resource.persisted?
            render json: {
              status: { code: 200, message: },
              data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
            }
          else
            render json: {
              status: { message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}" }
            }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end

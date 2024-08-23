module Users
  class RegistrationsController < Devise::RegistrationsController
    include RegistrationConcern

    def create
      # This should prevent users from signing up without an invite code
      invite_id = find_invited_by
      build_resource(sign_up_params.merge(invited_by_id: invite_id))
      create_user_characteristics

      resource.save

      if resource.persisted?
        create_couch
        update_profile
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
        UserMailer.welcome_email(resource).deliver_later
      else
        if resource.errors[:invited_by_id].present?
          flash[:error] = 'There seems to be an issue with your invite code. Please contact the Quouch team!'
        end

        crumb = Sentry::Breadcrumb.new(
          message: 'User could not be created',
          level: 'error',
          category: 'user',
          data: { errors: resource.errors.full_messages }
        )
        Sentry.add_breadcrumb(crumb)

        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end

      event = AmplitudeAPI::Event.new(
        user_id: resource.id.to_s,
        event_type: 'New User',
        user_properties: {
          age: resource.calculated_age,
          country: resource.country,
          host: resource.offers_couch,
          travelling: resource.travelling,
          invited_by: resource.invited_by_id
        },
        time: Time.now
      )

      AmplitudeAPI.track(event)
    end

    def update
      @user.update(country: params[:user][:country], city: params[:user][:city])

      @couch = @user.couch
      create_couch_facilities

      update_user_characteristics
      super
      beautify_country
      disable_offers_if_travelling
    end

    def destroy
      User.where(invited_by_id: @user.id).update!(invited_by_id: nil)
      if @user.destroy!
        sign_out(@user) # Optional: Sign out the user after deletion
        redirect_to root_path
        flash[:alert] = 'You successfully unsubscribed the Quouch service and deleted your profile. Sad to see you go!'
      else
        redirect_to root_path
        flash[:alert] = 'Something went wrong. Please contact the Quouch Team to make sure you are not billed again.'
      end
    end
  end
end

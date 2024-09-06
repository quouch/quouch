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
        flash[:error] = resource.errors[:stripe_id].first if resource.errors[:stripe_id].present?

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

      AmplitudeEventTracker.track_user_event(resource, 'New User')
    end

    def update
      if params[:user][:old_password].blank?
        @couch = @user.couch
        create_couch_facilities
        update_user_characteristics

        super do |_resource|
          disable_offers_if_travelling
        end
      else
        update_password
      end
    rescue StandardError => e
      Rails.logger.error(e.message)
      # flash[:error] = 'Something went wrong. Please try again.'
      # redirect_to edit_user_registration_path
      # Send more data to Sentry
      Sentry.add_breadcrumb(Sentry::Breadcrumb.new(message: e.message, data: { request: },
                                                   level: 'error', category: 'user'))
      Sentry.capture_exception(e)
    end

    def update_password
      # This is a custom method to update the password without changing any other data
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

      user_params = password_update_params
      current_password = user_params.delete(:old_password)
      if user_params[:password].blank?
        resource.errors.add(:password, :blank)
        user_params.delete(:password)
        user_params.delete(:password_confirmation) if user_params[:password_confirmation].blank?
      end

      if resource.valid_password?(current_password)
        # check that the new password is valid
        resource.assign_attributes(user_params)
        is_valid_password = password_valid?
        resource_updated = if is_valid_password
                             # update the user password
                             resource.update_attribute(:password, user_params[:password])
                             resource.update_attribute(:password_confirmation, user_params[:password_confirmation])
                           else
                             false
                           end
      else
        resource.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
        resource_updated = false
      end

      if resource_updated
        set_flash_message_for_update(resource, false)

        bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

        respond_with resource, location: after_update_path_for(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
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

    protected

    def password_update_params
      devise_parameter_sanitizer.sanitize(:password_update)
    end

    def password_valid?
      resource.valid?(:password_update)
    end
  end
end

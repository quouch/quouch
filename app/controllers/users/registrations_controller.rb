# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    super
    @couch = @user.couch
    @couchfacilities = @couch.couch_facilities
    if @couch.nil? && @couchfacilities.nil?
      @couch = Couch.new(couch_params)
      @couch.user = @user
      @couch.save
      create_couch_facilities
    elsif @couch.present? && @couchfacilities.blank?
      update_couch
      create_couch_facilities
    else
      update_couch
      @couchfacilities.update(couch_id: @couch, facility_id: couch_facility_params[:facility_id])
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def couch_params
    params.require(:couch).permit(:capacity)
  end

  def couch_facility_params
    params.require(:couch_facility).permit(:facility_id)
  end

  def create_couch_facilities
    @couchfacilities = CouchFacility.new(couch_id: @couch.id, facility_id: couch_facility_params[:facility_id])
    @couchfacilities.save!
  end

  def update_couch
    @couch.update(couch_params)
  end


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.


  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

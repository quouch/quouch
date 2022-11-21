class ApplicationController < ActionController::Base
  # before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :date_of_birth, :email, :password, :password_confirmation])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:photo, :first_name, :last_name, :date_of_birth, :pronouns, :city_id, :summary, :offers_couch, :offers_co_work, :offers_hang_out, :question_one, :question_two, :question_three, :question_four, couch_attributes: [:capacity], couch_facility_attributes: [:facility_id]])
  end
end

class InvitesController < ApplicationController
  include InviteCodeHelper
  skip_before_action :authenticate_user!, only: %i[invite_code_form validate_invite_code]

  ERROR_MESSAGES = {
    invalid_code: 'This does not look like a valid code. Please make sure you have the correct code or contact the Quouch Team',
    invite_code_not_found: 'Invite code not found. Try again or contact the Quouch team',
    default: 'Something went wrong. Please try again or contact the Quouch team'
  }.freeze

  def invite_code_form; end

  def validate_invite_code
    invite_code = params[:invite][:invite_code].strip.downcase
    if valid_syntax?(invite_code)
      user = User.find_by!(invite_code:)
      redirect_to new_user_registration_path(invite_code:) if user
    else
      flash[:alert] = ERROR_MESSAGES[:invalid_code]
      render :invite_code_form, status: :unprocessable_entity
      nil
    end
  rescue ActiveRecord::RecordNotFound => e
    flash[:alert] = ERROR_MESSAGES[:invite_code_not_found]
    Sentry.capture_exception(e)
    Sentry.capture_message("No user found with invite code: #{invite_code}", level: 'info')

    render :invite_code_form, status: :unprocessable_entity
  rescue StandardError
    flash[:alert] = ERROR_MESSAGES[:default]
    render :invite_code_form, status: :unprocessable_entity
  end

  def invite_friend
    @invite_code = current_user.invite_code
    @invite_url = "https://quouch-app.com/users/sign_up?invite_code=#{@invite_code}"
  end

  def send_invite_email
    email = params[:invite][:email]

    if email.present?
      InviteMailer.with(email:, current_user:).invite_email.deliver_now
      redirect_to :invite_friend
      flash[:notice] = 'Invite sent!'
    else
      redirect_to :invite_friend
      flash[:alert] = 'No email provided. Please try again.'
    end
  end
end

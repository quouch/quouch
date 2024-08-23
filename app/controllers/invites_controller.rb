class InvitesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[invite_code_form validate_invite_code]

  def invite_code_form; end

  def validate_invite_code
    invite_code = params[:invite][:invite_code].strip.downcase
    if User.exists?(invite_code: invite_code)
      redirect_to new_user_registration_path(invite_code:)
    else
      flash[:alert] = 'Invite code not valid. Try again or contact the Quouch team'
      render :invite_code_form, status: :unprocessable_entity
    end
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

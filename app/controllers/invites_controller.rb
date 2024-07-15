class InvitesController < ApplicationController
  skip_before_action :authenticate_user!

  def invite_code_form
  end

  def validate_invite_code
    invite_code = params[:invite][:invite_code]
    if User.exists?(invite_code: invite_code.strip) || User.exists?(invite_code: invite_code.strip.downcase)
      redirect_to new_user_registration_path(invite_code:)
    else
      flash[:alert] = "Invite code not valid. Try again or contact the Quouch team"
      render :invite_code_form, status: :unprocessable_entity
    end
  end

  def invite_friend
    @user = current_user
    @invite_code = @user.invite_code
  end
end

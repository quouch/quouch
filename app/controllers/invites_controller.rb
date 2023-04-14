class InvitesController < ApplicationController
	skip_before_action :authenticate_user!

	def invite_code_form; end

	def validate_invite_code
		invite_code = params[:invite][:invite_code]
		if User.exists?(invite_code:)
			redirect_to new_user_registration_path(invite_code:)
		else
			flash[:alert] = 'Invite code not valid. Try again or contact the Quouch team'
			render :invite_code_form, status: :unprocessable_entity
		end
	end
end

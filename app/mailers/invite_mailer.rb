class InviteMailer < ApplicationMailer
	default from: 'Quouch <hello@quouch-app.com>'

	def invite_email(invite)
		@inviter = current_user
		@invitee = params[:email]
		@url = new_user_registration_url(invite_token: invite.token)
		mail(to: @invitee, subject: "#{@inviter.first_name.capitalize} invited you to Quouch!")
	end
end

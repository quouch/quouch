class UserMailer < ApplicationMailer
	default from: 'nora@quouch-app.com'

	def welcome_email
		@user = params[:user]
		@guidelines = 'https://quouch-app.com/guidelines'
		@feedback_form_guest = 'https://forms.gle/mAiFEpxrw5PsbKD87'
		@feedback_form_host = 'https://forms.gle/AwrdCDawwWJ1VNvL9'
		@feedback_form_app = 'https://forms.gle/by6szdpGKtpfv6mD7'
		@invite_code = 'https://quouch-app.com/invite-friend'
		@sign_in = 'https://quouch-app.com/users/sign_in'
		mail(to: @user.email, subject: 'Welcome to Quouch 💜🧡')
	end
end

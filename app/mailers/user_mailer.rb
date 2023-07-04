class UserMailer < ApplicationMailer
	default from: 'dev.quouch@gmail.com'

	def welcome_email
		@user = params[:user]
		@url  = 'http://quouch-app.net/users/sign_in'
		mail(to: @user.email, subject: 'Welcome to Quouch')
	end
end

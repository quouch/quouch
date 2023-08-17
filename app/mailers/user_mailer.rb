class UserMailer < ApplicationMailer
	default from: 'hello.quouch@gmail.com'

	def welcome_email
		@user = params[:user]
		@url  = 'https://quouch-app.com/users/sign_in'
		mail(to: @user.email, subject: 'Welcome to Quouch')
	end
end

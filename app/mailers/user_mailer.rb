class UserMailer < ApplicationMailer
  default from: "Quouch <hello@quouch-app.com>"

  def welcome_email(resource)
    @user = resource
    mail(to: @user.email, subject: "Welcome to Quouch! 🎉")
  end
end

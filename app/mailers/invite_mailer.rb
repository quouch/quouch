class InviteMailer < ApplicationMailer
  default from: 'Quouch <hello@quouch-app.com>'

  def invite_email
    @inviter = params[:current_user]
    @invite_code = @inviter.invite_code
    @invitee = params[:email]
    @url = "https://quouch-app.com/users/sign_up?invite_code=#{@invite_code}"
    mail(to: @invitee, subject: "#{@inviter.first_name.capitalize} invited you to Quouch!")
  end
end

class MessageMailer < ApplicationMailer
  before_action :set_message_details
  default from: "Quouch <hello@quouch-app.com>"

  def message_notification
    mail(to: @recipient.email, subject: "New Message 💜🧡")
  end

  private

  def find_recipient(message)
    @users = [User.find(message.chat.user_sender_id), User.find(message.chat.user_receiver_id)]
    @users.each do |user|
      next if user.eql?(message.user)

      @user = user
    end
    @user
  end

  def set_message_details
    @chat = params[:chat]
    @recipient = params[:recipient]
    @sender = params[:message].user
    @message = params[:message]
    @chat_url = chat_url(@chat)
  end
end

class MessageMailer < ApplicationMailer
	before_action :set_message_details
	default from: 'hello.quouch@gmail.com'

	def message_notification
		mail(to: @recipient.email, subject: "You have a new message")
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
		@url = chat_url(@chat)
	end
end

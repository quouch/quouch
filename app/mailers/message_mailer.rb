class MessageMailer < ApplicationMailer
	before_action :set_message_details
	default from: 'dev.quouch@gmail.com'

	def message_notification
		mail(to: @receiver.email, subject: "You have a new message")
	end

	private

	def set_message_details
		@message = params[:message]
		@receiver = User.find(@message.chat.user_receiver_id)
		@sender = User.find(@message.chat.user_sender_id)
	end
end

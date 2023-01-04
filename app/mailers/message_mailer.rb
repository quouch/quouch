class MessageMailer < ApplicationMailer
	default from: 'dev.quouch@gmail.com'

	def new_message_email
		mail(to: @host.email, subject: "You have a new message")
	end
end

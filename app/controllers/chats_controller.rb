class ChatsController < ApplicationController
	def index
		@chats = Chat.all.where(user_sender_id: current_user.id)
		@receivers = []
		@chats.each do |chat|
			@receivers << User.find_by(id: chat.user_receiver_id)
		end
	end

	def show
		@chat = Chat.find(params[:id])
		@name = User.find_by(id: @chat.user_receiver_id).first_name
		@message = Message.new
	end

	def create
		@chat = Chat.new(user_sender_id: params[:user_sender_id], user_receiver_id: params[:user_receiver_id])
		@chat.save
		redirect_to chat_path(@chat)
	end
end

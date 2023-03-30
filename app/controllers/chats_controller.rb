class ChatsController < ApplicationController
	def index
		@chats = Chat.includes(:messages).where(user_sender_id: current_user.id).or(Chat.includes(:messages).where(user_receiver_id: current_user.id))
		.order('messages.created_at DESC')
	end

	def show
		@chat = Chat.find(params[:id])
		@receiver = User.find_by(id: @chat.user_receiver_id)
		@receiver == current_user ? @name = User.find_by(id: @chat.user_sender_id).first_name : @name = @receiver.first_name
		@message = Message.new
	end

	def create
		@chat = Chat.new(user_sender_id: params[:user_sender_id], user_receiver_id: params[:user_receiver_id])
		if @chat.save
			redirect_to chat_path(@chat)
		end
	end
end

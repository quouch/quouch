class ChatsController < ApplicationController
	before_action :set_chat, only: %i[show set_notifications_to_read]
	before_action :set_notifications_to_read, only: %i[show]

	def index
		@chats = Chat.includes(:messages).where(user_sender_id: current_user.id).or(Chat.includes(:messages)
								 .where(user_receiver_id: current_user.id)).order('messages.created_at DESC')
    @chat = params[:chat].present? ? Chat.find(params[:chat]) : @chats.first
	end

	def show
		@receiver = User.find_by(id: @chat.user_receiver_id)
		@receiver == current_user ? @name = User.find_by(id: @chat.user_sender_id).first_name : @name = @receiver.first_name
		@message = Message.new
	end

	def create
		@chat = Chat.new(user_sender_id: params[:user_sender_id], user_receiver_id: params[:user_receiver_id])
		redirect_to chats_path(chat: @chat) if @chat.save
	end

		private

	def set_chat
		@chat = Chat.find(params[:id])
	end

	def set_notifications_to_read
		notifications = @chat.notifications_as_chat.where(recipient: current_user).unread
		notifications.mark_as_read!
	end
end

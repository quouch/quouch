class ChatsController < ApplicationController
  before_action :set_chat, only: %i[show set_notifications_to_read]
  before_action :set_notifications_to_read, only: %i[show]

  def index
    @chats = current_user.chats.includes(user_sender: [{photo_attachment: :blob}]).order("messages.created_at DESC")
    @messages = []
    @chats.each { |chat| @messages.concat(chat.messages.to_a) }
    @chat = params[:chat].present? ? Chat.find(params[:chat]) : @chats.first
    @other_user = @chat.other_user(current_user) unless @chat.nil?
  end

  def show
    @chats = current_user.chats.includes(user_receiver: [{photo_attachment: :blob}]).order("messages.created_at DESC")
    @other_user = @chat.other_user(current_user)
    @receiver = User.find_by(id: @chat.user_receiver_id)
    @name = (@receiver == current_user) ? User.find_by(id: @chat.user_sender_id).first_name : @receiver.first_name
    @message = Message.new
  end

  def create
    @chat = Chat.new(user_sender_id: params[:user_sender_id], user_receiver_id: params[:user_receiver_id])
    redirect_to chat_path(@chat) if @chat.save
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

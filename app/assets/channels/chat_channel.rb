class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat = Chat.find(params[:id])
    stream_for chat
  end

  def speak(data)
    message = Message.create(body: data['message'])
    socket = { message: message.body }
    ChatChannel.broadcast_to('chat_channel', socket)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

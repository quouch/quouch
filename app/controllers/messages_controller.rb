class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.user = current_user
    return unless @message.save

    ChatChannel.broadcast_to(
      @chat,
      { message: render_to_string(partial: 'message', locals: { message: @message }), sender_id: @message.user.id }
    )
    head :ok

    AmplitudeEventTracker.track_message_event('New Message')
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end

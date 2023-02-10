class Api::V1::MessagesController < Api::V1::BaseController
  # skip_before_action :verify_authenticity_token
	def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.user = current_user
    @message.save
    render json: @chat
    render json: @message
    ChatChannel.broadcast_to(
      @chat,
      render_to_string(partial: "messages/message", locals: {message: @message})
    )
    # head :ok
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end 

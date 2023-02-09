class Api::V1::ChatsController < Api::V1::BaseController
	acts_as_token_authentication_handler_for User, except: [ :index, :show ]
	before_action :set_chat, only: [ :show ]

  def index
    @chats = Chat.all
  end

	def show
	end

	def create
		@chat = Chat.new(user_sender_id: params[:user_sender_id], user_receiver_id: params[:user_receiver_id])
		if @chat.save
      render :show, status: :created
    else
      render_error
    end
	end

	private

	def chat_params
    params.require(:chat).permit(:user_sender_id, :user_receiver_id)
  end

	def set_chat
    @chat = Chat.find(params[:id])
  end

	def render_error
    render json: { errors: @chats.errors.full_messages },
      status: :unprocessable_entity
  end
end
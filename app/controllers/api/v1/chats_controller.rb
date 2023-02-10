class Api::V1::ChatsController < Api::V1::BaseController
	acts_as_token_authentication_handler_for User, except: [ :index, :show ]
	before_action :set_chat, only: [ :show ]

  def index
    @chats = Chat.all
		render json: @chats
  end

	def show
	end

	def create
		@chat = Chat.new(chat_params)
		if @chat.save
			render json: @chat
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
    render json: { errors: @chat.errors.full_messages },
      status: :unprocessable_entity
  end
end
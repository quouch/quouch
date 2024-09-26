# frozen_string_literal: true

module Api
  module V1
    class ChatsController < ApiController
      def index
        @chats = current_user.chats.includes(user_sender: [{ photo_attachment: :blob }]).order('messages.created_at DESC')
        render jsonapi: @chats
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApiController
      before_action :find_chat

      def index
        render jsonapi: @chat.messages.order(created_at: :asc)
      end

      private

      def find_chat
        chat_id = params.require(:chat_id)
        @chat = Chat.find(chat_id)
      end
    end
  end
end

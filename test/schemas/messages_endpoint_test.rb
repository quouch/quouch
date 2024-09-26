# frozen_string_literal: true

require 'api_test_helper'

class MessagesEndpointTest < ApiEndpointTest
  def setup
    @user, @headers = api_prepare_headers

    @sender = @user
    @receiver = FactoryBot.create(:user, :for_test, :with_couch)

    @chat = Chat.create(user_sender: @user, user_receiver: @receiver)
    @message = Message.create(chat: @chat, user: @sender, content: 'Hello!')
  end

  test 'GET /messages' do
    get "/api/v1/chats/#{@chat.id}/messages", headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /messages without authentication' do
    get "/api/v1/chats/#{@chat.id}/messages"
    assert_response :unauthorized

    assert_match_openapi_doc
  end

  test 'GET /messages for non-existent chat' do
    get '/api/v1/chats/999/messages', headers: @headers
    assert_response :not_found

    assert_match_openapi_doc
  end
end

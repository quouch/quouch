# frozen_string_literal: true

require 'api_test_helper'

class ChatsEndpointTest < ApiEndpointTest
  def setup
    @user, @headers = api_prepare_headers

    @sender = @user
    @receiver = FactoryBot.create(:user, :for_test, :with_couch)

    @chat = Chat.create(user_sender: @user, user_receiver: @receiver)
  end

  test 'GET /chats' do
    get '/api/v1/chats', headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /chats without authentication' do
    get '/api/v1/chats'
    assert_response :unauthorized

    assert_match_openapi_doc
  end
end

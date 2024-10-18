require 'test_helper'

class ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user, :for_test, :with_couch)
    @host = FactoryBot.create(:user, :for_test, :offers_couch)
    @chat = Chat.create(user_sender: @user, user_receiver: @host)
    @unaffiliated_chat = Chat.create(user_sender: @host,
                                     user_receiver: FactoryBot.create(:user,
                                                                      :for_test, :offers_couch))
    sign_in_as @user
  end

  test 'should see chat page' do
    get chat_url(@chat)

    assert_response :success
  end

  test 'should not see unaffiliated chat page' do
    get chat_url(@unaffiliated_chat)
    assert_redirected_to chats_path
  end
end

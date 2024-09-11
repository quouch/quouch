# frozen_string_literal: true

require 'api_test_helper'

class SessionEndpointsTest < ApiEndpointTest
  def setup
    @user = FactoryBot.create(:user, :for_test, :with_couch)
  end

  def teardown
    # Do nothing
  end

  test 'POST /login' do
    login_credentials = { user: { email: @user.email, password: @user.password } }
    post '/api/v1/login', params: login_credentials

    assert_match_openapi_doc
  end

  test 'POST /login invalid email' do
    login_credentials = { user: { email: 'not@gmail.com', password: @user.password } }
    post '/api/v1/login', params: login_credentials

    assert_match_openapi_doc
  end

  test 'DELETE /logout' do
    login_credentials = { user: { email: @user.email, password: @user.password } }
    post '/api/v1/login', params: login_credentials
    token = response.headers['Authorization']

    delete '/api/v1/logout', headers: { 'Authorization' => token }

    assert_match_openapi_doc
  end

  test 'DELETE /logout without token' do
    delete '/api/v1/logout'

    assert_match_openapi_doc
  end
end

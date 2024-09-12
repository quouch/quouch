# frozen_string_literal: true

require 'api_test_helper'

class UserEndpointsTest < ApiEndpointTest
  def setup
    @user, @headers = api_prepare_headers
  end

  test 'GET /users' do
    get '/api/v1/users?page[limit]=10&page[offset]=3', headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /users/:id' do
    get "/api/v1/users/#{@user.id}", headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /users/:id not found' do
    get '/api/v1/users/20', headers: @headers
    assert_response :not_found

    assert_match_openapi_doc
  end
end

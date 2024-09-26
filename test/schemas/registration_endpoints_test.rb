# frozen_string_literal: true

require 'api_test_helper'

class RegistrationEndpointsTest < ApiEndpointTest
  setup do
    @user, @headers = api_prepare_headers
  end
  test 'GET /users/edit' do
    get('/api/v1/users/edit', headers: @headers)

    assert_match_openapi_doc
  end

  test 'POST /update/:id invalid request' do
    params = {
      data: {
        type: 'user'
      }
    }
    post("/api/v1/update/#{@user[:id]}", headers: @headers, params:)

    assert_match_openapi_doc
  end

  test 'POST /update/:id' do
    params = {
      data: {
        type: 'user',
        id: @user[:id],
        attributes: {
          first_name: 'new_first_name'
        }
      }
    }

    post("/api/v1/update/#{@user[:id]}", headers: @headers, params:)

    assert_match_openapi_doc({ request_body: true })
  end

  test 'POST /update/:id forbidden error' do
    user2 = FactoryBot.create(:user, :for_test)
    params = { data: { id: user2[:id], type: 'user', attributes: { first_name: 'New first name' } } }
    post("/api/v1/update/#{user2.id}", headers: @headers, params:)

    assert_response :forbidden
    assert_match_openapi_doc({ request_body: true })
  end
end

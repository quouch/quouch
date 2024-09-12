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

    assert_match_openapi_doc
  end
end

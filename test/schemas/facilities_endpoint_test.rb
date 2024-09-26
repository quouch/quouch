# frozen_string_literal: true

require 'api_test_helper'

class FacilitiesEndpointTest < ApiEndpointTest
  def setup
    @user, @headers = api_prepare_headers
  end

  test 'GET /facilities' do
    get '/api/v1/facilities', headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /facilities without authentication' do
    get '/api/v1/facilities'
    assert_response :ok

    assert_match_openapi_doc
  end
end

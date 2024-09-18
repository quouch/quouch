# frozen_string_literal: true

require 'api_test_helper'

class PlansEndpointTest < ApiEndpointTest
  def setup
    @user, @headers = api_prepare_headers
  end

  test 'GET /plans' do
    get '/api/v1/plans', headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /plans without authentication' do
    get '/api/v1/plans'
    assert_response :unauthorized

    assert_match_openapi_doc
  end
end

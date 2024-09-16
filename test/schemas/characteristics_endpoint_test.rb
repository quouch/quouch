# frozen_string_literal: true

require 'api_test_helper'

class CharacteristicsEndpointTest < ApiEndpointTest
  def setup
    @user, @headers = api_prepare_headers
  end

  test 'GET /characteristics' do
    get '/api/v1/characteristics', headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /characteristics without authentication' do
    get '/api/v1/characteristics'
    assert_response :ok

    assert_match_openapi_doc
  end
end

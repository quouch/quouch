# frozen_string_literal: true

require 'api_test_helper'

class CouchEndpointsTest < ApiEndpointTest
  def setup
    @user, @headers = api_prepare_headers

    # Add a facility to the couch
    first_facility = Facility.first!
    @user.couch.couch_facilities.create!(facility: first_facility)
  end

  test 'GET /couches without authorization' do
    get '/api/v1/couches'
    assert_response :unauthorized

    assert_match_openapi_doc
  end

  test 'GET /couches' do
    get '/api/v1/couches?page[limit]=10&page[offset]=3', headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /couches/:id' do
    get "/api/v1/couches/#{@user.couch.id}", headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /couches/:id not found' do
    get '/api/v1/couches/20', headers: @headers
    assert_response :not_found

    assert_match_openapi_doc
  end
end

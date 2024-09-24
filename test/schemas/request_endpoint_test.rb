# frozen_string_literal: true

require 'api_test_helper'

class RequestEndpointTest < ApiEndpointTest
  fixtures :bookings

  def setup
    @user, @headers = api_prepare_headers
    @user.couch.capacity = 2
    @user.couch.couch_facilities.create!(facility: Facility.first)
    @user.couch.save!

    @guest = FactoryBot.create(:user, :for_test)
    @request = FactoryBot.create(:booking, couch: @user.couch, user: @guest)
  end

  test 'GET /requests without authentication' do
    get '/api/v1/requests'
    assert_response :unauthorized

    assert_match_openapi_doc
  end

  test 'GET /requests' do
    get '/api/v1/requests', headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /requests/:id' do
    get "/api/v1/requests/#{@request.id}", headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /requests/:id forbidden' do
    booking = Booking.where.not(couch: @user.couch).sample
    get "/api/v1/requests/#{booking.id}", headers: @headers
    assert_response :forbidden

    assert_match_openapi_doc
  end

  test 'GET /requests/:id not found' do
    get '/api/v1/requests/999', headers: @headers
    assert_response :not_found

    assert_match_openapi_doc
  end

  test 'PATCH /requests/:id with status: confirmed' do
    setup_for_update

    patch("/api/v1/requests/#{@request.id}?status=confirmed", headers: @headers)
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'PATCH /requests/:id forbidden' do
    request = Booking.where.not(couch: @user.couch).sample
    url = "/api/v1/requests/#{request.id}?status=confirmed"
    patch(url, headers: @headers)
    assert_response :forbidden

    assert_match_openapi_doc
  end

  private

  def setup_for_update
    @request.status = :pending
    @request.save!
  end
end

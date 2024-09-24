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

  test 'PATCH /requests/:id without id in request' do
    # select any booking and assign it to the current user
    booking = setup_for_update

    booking_data = booking.attributes
    booking_data['status'] = :cancelled
    booking_data['id'] = nil

    params = request_params(booking_data, booking.user, booking.couch)
    patch("/api/v1/requests/#{booking.id}", headers: @headers, params:)
    assert_response :unprocessable_entity

    assert_match_openapi_doc
  end

  test 'PATCH /requests/:id forbidden' do
    booking = setup_for_update
    booking.user = User.where.not(id: @user.id).sample
    booking.couch = User.where.not(id: @user.id || booking.user.id).sample.couch
    booking.save!

    booking_data = booking.attributes
    booking_data['status'] = :cancelled

    params = request_params(booking_data, booking.user, booking.couch)
    patch("/api/v1/requests/#{booking.id}", headers: @headers, params:)
    assert_response :forbidden

    assert_match_openapi_doc
  end

  private

  def setup_for_update
    booking = Booking.all.sample
    booking.couch = @user.couch
    booking.status = :pending
    booking.save!

    booking['status'] = :cancelled
    booking
  end

  def request_params(booking_data, user, couch)
    {
      data: {
        id: booking_data['id'],
        type: 'booking',
        attributes: {
          **booking_data,
          user_id: user.id,
          couch_id: couch.id
        },
        relationships: {
          user: {
            data: {
              type: 'user',
              id: user.id
            }
          },
          couch: {
            data: {
              type: 'couch',
              id: couch.id
            }
          }
        }
      }
    }
  end
end

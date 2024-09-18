# frozen_string_literal: true

require 'api_test_helper'

class BookingEndpointTest < ApiEndpointTest
  fixtures :bookings

  def setup
    @user, @headers = api_prepare_headers
  end

  test 'GET /bookings without authentication' do
    get '/api/v1/bookings'
    assert_response :unauthorized

    assert_match_openapi_doc
  end

  test 'GET /bookings' do
    get '/api/v1/bookings', headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /bookings/:id' do
    booking = Booking.all.sample
    get "/api/v1/bookings/#{booking.id}", headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /booking/:id not found' do
    get '/api/v1/bookings/999', headers: @headers
    assert_response :not_found

    assert_match_openapi_doc
  end

  test 'POST /bookings' do
    booking_data = {
      start_date: Date.today,
      end_date: Date.today + 1,
      request: :host,
      message: Faker::Hipster.paragraph_by_chars(characters: 60),
      number_travellers: 1
    }

    params = request_params(booking_data, @user, Couch.all.sample)

    post('/api/v1/bookings', headers: @headers, params:)

    assert_response :created

    assert_match_openapi_doc({ request_body: true })
  end

  test 'PATCH /bookings/:id' do
    # select any booking and assign it to the current user
    booking = setup_for_update

    params = request_params(booking.attributes, booking.user, booking.couch)
    patch("/api/v1/bookings/#{booking.id}", headers: @headers, params:)
    assert_response :ok

    assert_match_openapi_doc({ request_body: true })
  end

  test 'PATCH /bookings/:id without id in request' do
    # select any booking and assign it to the current user
    booking = setup_for_update

    booking_data = booking.attributes
    booking_data['status'] = :cancelled
    booking_data['id'] = nil

    params = request_params(booking_data, booking.user, booking.couch)
    patch("/api/v1/bookings/#{booking.id}", headers: @headers, params:)
    assert_response :unprocessable_entity

    assert_match_openapi_doc
  end

  test 'PATCH /bookings/:id forbidden' do
    booking = setup_for_update
    booking.user = User.where.not(id: @user.id).sample
    booking.couch = User.where.not(id: @user.id || booking.user.id).sample.couch
    booking.save!

    booking_data = booking.attributes
    booking_data['status'] = :cancelled

    params = request_params(booking_data, booking.user, booking.couch)
    patch("/api/v1/bookings/#{booking.id}", headers: @headers, params:)
    assert_response :forbidden

    assert_match_openapi_doc
  end

  private

  def setup_for_update
    booking = Booking.all.sample
    booking.user = @user
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

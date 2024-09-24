# test/controllers/api/v1/bookings_controller_test.rb
require 'test_helper'

module Api
  module V1
    class RequestsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user, @headers = api_prepare_headers
        @user.offers_couch = true
        @user.save!

        @guest = FactoryBot.create(:user, :for_test)
      end

      test 'should get index' do
        get api_v1_request_url, headers: @headers

        assert_response :success
        assert_not_nil json_response['data']
        assert_equal @user.bookings.count, json_response['data'].length
      end

      test 'should only see own requests' do
        @request = create_request(@guest, @user)
        get api_v1_request_url, headers: @headers

        assert_response :success
        assert_not_nil json_response['data']
        assert_equal 0, json_response['data'].length
      end

      test 'should show booking details' do
        @request = create_user_booking(@guest, @user)
        get api_v1_request_url(@request), headers: @headers
        assert_response :success

        booking_data = json_response['data']
        assert_equal @request.id.to_s, booking_data['id']
        assert_equal @user.couch.id.to_s, booking_data['relationships']['couch']['data']['id']
        assert_equal @request.status.to_s, booking_data['attributes']['status']
      end

      test 'should update own request' do
        @booking = create_user_booking

        attributes = @booking.attributes
        attributes['status'] = :confirmed
        params = request_params(attributes, @booking.user, @booking.couch)

        assert_equal 'pending', @booking.status
        patch(api_v1_request_url(@booking), headers: @headers, params:)
        assert_response :success

        assert_not_nil json_response['data']['id']

        @booking.reload
        assert_equal 'confirmed', @booking.status
        assert_equal 'confirmed', json_response['data']['attributes']['status']
      end

      test 'should not update unaffiliated request' do
        @user2 = FactoryBot.create(:user, :for_test)
        @booking = create_user_booking(@user2, @host)

        attributes = @booking.attributes
        attributes['status'] = :confirmed
        params = request_params(attributes, @booking.user, @booking.couch)

        patch(api_v1_request_url(@booking), headers: @headers, params:)
        assert_response :forbidden
      end

      test 'should only be able to change status of request' do
        @booking = create_user_booking

        attributes = @booking.attributes
        attributes['status'] = :confirmed
        attributes['message'] = 'This is a new message'
        params = request_params(attributes, @booking.user, @booking.couch)

        patch(api_v1_request_url(@booking), headers: @headers, params:)
        assert_response :success

        @booking.reload
        assert_equal 'confirmed', @booking.status
        assert_equal 'This is a new message', @booking.message
      end

      private

      def create_request(user = @user, host = @host)
        booking = FactoryBot.create(:booking, user: @user, couch: @host.couch)
        booking.couch = host.couch
        booking.user = user

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
  end
end

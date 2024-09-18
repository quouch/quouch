# test/controllers/api/v1/bookings_controller_test.rb
require 'test_helper'

module Api
  module V1
    class BookingsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user, @headers = api_prepare_headers
        @host = FactoryBot.create(:user, :for_test, :offers_couch)
      end

      test 'should get index' do
        get api_v1_bookings_url, headers: @headers

        assert_response :success
        assert_not_nil json_response['data']
        assert_equal @user.bookings.count, json_response['data'].length
      end

      test 'should show booking details' do
        @booking = create_user_booking
        get api_v1_booking_url(@booking), headers: @headers
        assert_response :success

        booking_data = json_response['data']
        assert_equal @booking.id.to_s, booking_data['id']
        assert_equal @user.id.to_s, booking_data['relationships']['user']['data']['id']
        assert_equal @booking.status.to_s, booking_data['attributes']['status']
      end

      test 'should create booking' do
        booking_data = {
          start_date: Date.today,
          end_date: Date.today + 1,
          request: :host.to_s,
          message: Faker::Hipster.paragraph_by_chars(characters: 60),
          number_travellers: 1
        }

        params = request_params(booking_data, @user, @host.couch)

        assert_difference('Booking.count') do
          post api_v1_bookings_url, headers: @headers, params:
        end

        assert_response :created

        last_booking = Booking.last

        assert_not_nil json_response['data']['id']
        assert_equal last_booking.id.to_s, json_response['data']['id']
        assert_equal last_booking.message, json_response['data']['attributes']['message']
        assert_equal booking_data[:request], json_response['data']['attributes']['request']
        assert_equal 'pending', last_booking.status
      end

      test 'should update booking' do
        @booking = create_user_booking

        attributes = @booking.attributes
        attributes['status'] = :confirmed
        params = request_params(attributes, @booking.user, @booking.couch)

        assert_equal 'pending', @booking.status
        patch(api_v1_booking_url(@booking), headers: @headers, params:)
        assert_response :success

        assert_not_nil json_response['data']['id']

        @booking.reload
        assert_equal 'confirmed', @booking.status
        assert_equal 'confirmed', json_response['data']['attributes']['status']
      end

      test 'should not update booking with wrong user' do
        @user2 = FactoryBot.create(:user, :for_test)
        @booking = create_user_booking(@user2, @host)

        attributes = @booking.attributes
        attributes['status'] = :confirmed
        params = request_params(attributes, @booking.user, @booking.couch)

        patch(api_v1_booking_url(@booking), headers: @headers, params:)
        assert_response :forbidden
      end

      test 'should not create booking with missing data' do
        @booking = FactoryBot.build(:booking, user: @user, couch: @host.couch)

        attributes = @booking.attributes
        attributes['request'] = nil
        params = request_params(attributes, @booking.user, @booking.couch)

        post(api_v1_bookings_url, headers: @headers, params:)
        assert_response :unprocessable_entity

        first_error = json_response['errors'][0]
        assert_equal 'Invalid record', first_error['title']
        assert_includes first_error['source']['pointer'], 'request'
      end

      private

      def create_user_booking(user = @user, host = @host)
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

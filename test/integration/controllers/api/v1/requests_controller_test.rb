# test/controllers/api/v1/bookings_controller_test.rb
require 'test_helper'

module Api
  module V1
    class RequestsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user, @headers = api_prepare_headers
        @user.offers_couch = true
        @user.couch.capacity = 2
        @user.couch.couch_facilities.create!(facility: Facility.first)
        @user.couch.save!
        @user.save!

        @host = @user

        @guest = FactoryBot.create(:user, :for_test)
      end

      test 'should get index' do
        get api_v1_requests_url, headers: @headers

        assert_response :success
        assert_not_nil json_response['data']
        assert_equal @user.couch.bookings.count, json_response['data'].length
      end

      test 'should only see own requests' do
        FactoryBot.create(:booking, user: @guest)
        get api_v1_requests_url, headers: @headers

        assert_response :success
        assert_not_nil json_response['data']
        assert_equal 0, json_response['data'].length
      end

      test 'should show request details' do
        request = create_request
        get api_v1_request_url(request), headers: @headers
        assert_response :success

        booking_data = json_response['data']
        assert_equal request.id.to_s, booking_data['id']
        assert_equal @user.couch.id.to_s, booking_data['relationships']['couch']['data']['id']
        assert_equal request.status.to_s, booking_data['attributes']['status']
      end

      test 'should not see own booking as request' do
        booking = FactoryBot.create(:booking, user: @user)

        get api_v1_request_url(booking), headers: @headers
        assert_response :forbidden
      end

      test 'should confirm request' do
        request = create_request

        patch(api_v1_request_url(request, { status: 'confirmed' }), headers: @headers)
        assert_response :success

        request.reload
        assert_equal 'confirmed', request.status
      end

      test 'should decline request' do
        request = create_request

        patch(api_v1_request_url(request, { status: 'declined' }), headers: @headers)
        assert_response :success

        request.reload
        assert_equal 'declined', request.status
      end

      test 'should not cancel request' do
        request = create_request

        patch(api_v1_request_url(request, { status: 'cancelled' }), headers: @headers)
        assert_response :forbidden

        request.reload
        assert_equal 'pending', request.status
      end

      test 'should not change any other properties of request' do
        request = create_request

        new_message = 'value'
        patch(api_v1_request_url(request, { status: 'confirmed', message: new_message }), headers: @headers)
        assert_response :ok

        request.reload
        assert_equal 'confirmed', request.status
        assert_not_equal new_message, request.message
      end

      test 'should not confirm request if not host' do
        request = FactoryBot.create(:booking, user: @guest)

        patch(api_v1_request_url(request, { status: 'confirmed' }), headers: @headers)
        assert_response :forbidden

        request.reload
        assert_equal 'pending', request.status
      end

      private

      def create_request(guest = @guest, host = @host)
        FactoryBot.create(:booking, user: guest, couch: host.couch)
      end
    end
  end
end

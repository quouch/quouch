require 'test_helper'

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      def setup
        @user, @headers = api_prepare_headers
      end

      test 'should see all users' do
        total_users = User.count
        get '/api/v1/users', headers: @headers

        assert_response :success

        assert_equal total_users, json_response['data'].count
      end

      test 'should see all users with pagination' do
        total_users = User.count
        expected_items = 5
        params = { page: { size: expected_items } }
        get('/api/v1/users', headers: @headers, params:)

        assert_response :success

        assert_equal expected_items, json_response['data'].count
        assert_equal total_users, json_response['meta']['pagination']['records']
        assert_equal 1, json_response['meta']['pagination']['current']
      end

      test 'should navigate pages with parameters' do
        # first, get the first 5 users
        expected_items = 5
        params = { page: { size: expected_items } }
        get('/api/v1/users', headers: @headers, params:)

        first_five_users = json_response['data']
        assert_equal 1, json_response['meta']['pagination']['current']

        # then, get the next 5 users
        params = { page: { size: expected_items, number: 2 } }
        get('/api/v1/users', headers: @headers, params:)

        assert_response :success
        assert_equal 2, json_response['meta']['pagination']['current']
        assert_equal expected_items, json_response['data'].count

        # assert that the items are not the same!
        refute_equal first_five_users, json_response['data']
      end
    end
  end
end

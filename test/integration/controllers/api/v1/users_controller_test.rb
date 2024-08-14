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

        json_response = JSON.parse(response.body)
        assert_equal total_users, json_response['items'].count
      end

      test 'should see all users with pagination' do
        total_users = User.count
        expected_items = 5
        params = { items: expected_items }
        get('/api/v1/users', headers: @headers, params:)

        assert_response :success
        json_response = JSON.parse(response.body)

        assert_equal expected_items, json_response['items'].count
        assert_equal total_users, json_response['pagination']['total']
        assert_equal expected_items, json_response['pagination']['items']
        assert_equal 1, json_response['pagination']['page']
      end

      test 'should navigate pages with parameters' do
        # first, get the first 5 users
        expected_items = 5
        params = { items: expected_items }
        get('/api/v1/users', headers: @headers, params:)
        json_response = JSON.parse(response.body)
        first_five_users = json_response['items']

        # then, get the next 5 users
        params = { items: expected_items, page: 2 }
        get('/api/v1/users', headers: @headers, params:)

        assert_response :success
        json_response = JSON.parse(response.body)
        assert_equal 2, json_response['pagination']['page']
        assert_equal expected_items, json_response['items'].count

        # assert that the items are not the same!
        refute_equal first_five_users, json_response['items']
      end
    end
  end
end

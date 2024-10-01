# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class CouchesControllerTest < ActionDispatch::IntegrationTest
      def setup
        @user, @headers = api_prepare_headers
      end

      def teardown
        # Do nothing
      end

      test 'should get index' do
        expected_items = 10
        params = { page: { size: expected_items } }
        get(api_v1_couches_url, headers: @headers, params:)
        assert_response :success

        assert_equal expected_items, json_response['data'].length
        assert_equal Couch.count - 2, json_response['meta']['pagination']['records']

        refute_includes json_response['data'], @user.couch

        first_item = json_response['data'][0]
        assert_not_nil first_item['id']
        # Check that items include user's information
        assert_not_nil first_item['attributes']['user']
        assert_not_nil first_item['attributes']['user']['first_name']
      end

      test 'should see detail for one couch' do
        couch = Couch.first
        get api_v1_couch_url(couch), headers: @headers
        assert_response :success

        data = json_response['data']
        assert_equal couch.id.to_s, data['id']
        assert_equal 'couch', data['type']
        assert_equal couch.user_id, data['attributes']['user_id']
        assert_equal couch.user.first_name, data['attributes']['user']['first_name']
      end

      test 'should get a 404 when couch is not found' do
        get api_v1_couch_url(id: 999), headers: @headers
        assert_response :not_found

        first_error = json_response['errors'][0]
        assert_equal 'Not Found', first_error['title']
        assert_equal '404', first_error['status']
      end

      test 'should not see own user' do
        # Only the own user should have 'Test city' as it's city
        city_name = @user.city

        get api_v1_couches_url, params: { query: city_name }, headers: @headers
        assert_response :success

        assert_equal 0, json_response['data'].length
      end

      test 'should filter couches by exact city' do
        # get a city that exists in the database
        city_name = User.first.city
        # find out how many users have a couch in that city
        couches_in_city = User.where(city: city_name).count

        get api_v1_couches_url, params: { query: city_name }, headers: @headers
        assert_response :success

        assert_equal couches_in_city, json_response['data'].length
      end

      test 'should filter couches by partial city or country' do
        # create an imaginary city and assign it to some users
        city = 'NonExistingCity'
        User.where.not(id: @user.id).sample(2).each do |user|
          user.city = city
          user.save
        end

        # Set only part of the city name
        city_chars = 'NonExisting'

        # find out how many users have a couch in that city, by using the partial name
        couches_in_city = User.where('city LIKE?', "%#{city_chars}%").count

        get api_v1_couches_url, params: { query: city_chars }, headers: @headers
        assert_response :success

        assert_equal couches_in_city, json_response['data'].length
      end
    end
  end
end

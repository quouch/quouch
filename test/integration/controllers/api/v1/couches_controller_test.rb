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
        get api_v1_couches_url, headers: @headers
        assert_response :success

        json_response = JSON.parse(response.body)
        assert_equal 9, json_response['items'].length
        assert_equal Couch.count - 1, json_response['pagination']['total']

        refute_includes json_response['items'], @user.couch

        assert_not_nil json_response['items'][0]['id']
        # Check that items include user's information
        assert_not_nil json_response['items'][0]['user']
        assert_not_nil json_response['items'][0]['user']['first_name']
      end

      test 'should see detail for one couch' do
        couch = Couch.first
        get api_v1_couch_url(couch), headers: @headers
        assert_response :success

        json_response = JSON.parse(response.body)
        assert_equal couch.id, json_response['id']
        assert_equal couch.user_id, json_response['user_id']
        assert_equal couch.user.first_name, json_response['user']['first_name']
      end

      test 'should get a 404 when couch is not found' do
        get api_v1_couch_url(id: 999), headers: @headers
        assert_response :not_found

        assert_equal 'Record not found.', JSON.parse(response.body)['error']
        assert_equal 404, JSON.parse(response.body)['code']
      end

      test 'should not see own user' do
        # Only the own user should have 'Test city' as it's city
        city_name = @user.city

        get api_v1_couches_url, params: { query: city_name }, headers: @headers
        assert_response :success

        json_response = JSON.parse(response.body)
        assert_equal 0, json_response['items'].length
      end

      test 'should filter couches by exact city' do
        # get a city that exists in the database
        city_name = User.first.city
        # find out how many users have a couch in that city
        couches_in_city = User.where(city: city_name).count

        get api_v1_couches_url, params: { query: city_name }, headers: @headers
        assert_response :success

        json_response = JSON.parse(response.body)
        assert_equal couches_in_city, json_response['items'].length
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

        json_response = JSON.parse(response.body)
        assert_equal couches_in_city, json_response['items'].length
      end
    end
  end
end

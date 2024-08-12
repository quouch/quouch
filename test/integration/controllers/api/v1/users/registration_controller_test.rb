# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class RegistrationControllerTest < ActionDispatch::IntegrationTest
      def setup
        @user, @headers = api_prepare_headers
      end

      def teardown
        # Do nothing
      end

      test 'should see own user information' do
        get "/api/v1/users/#{@user.id}", headers: @headers

        assert_response :success
        json_response = JSON.parse(response.body)

        assert_equal 'user', json_response['type']
        assert_equal @user[:id], json_response['attributes']['id']
        assert_equal @user[:email], json_response['attributes']['email']
        assert_equal @user[:first_name], json_response['attributes']['first_name']

        assert_equal @user.couch[:id].to_s, json_response['relationships']['couch']['data']['id']
      end

      test 'should edit own user information' do
        current_name = @user.first_name
        new_first_name = "#{@user.first_name}2"

        get '/api/v1/users/edit', headers: @headers

        assert_response :success
        json_response = JSON.parse(response.body)
        assert_equal @user[:id], json_response['user']['id']
        assert_equal current_name, json_response['user']['first_name']

        params = { user: { first_name: new_first_name } }
        post("/api/v1/update/#{@user.id}", headers: @headers, params:)

        assert_response :success
        json_response = JSON.parse(response.body)
        assert_equal @user[:id], json_response['data']['id']
        assert_equal new_first_name, json_response['data']['first_name']
        assert_equal 'Updated successfully.', json_response['status']['message']
      end
    end
  end
end

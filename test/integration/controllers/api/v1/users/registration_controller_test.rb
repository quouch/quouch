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
        json_response = response.parsed_body

        attributes = json_response['data']['attributes']

        assert_equal 'user', json_response['data']['type']
        assert_equal @user[:id], attributes['id']
        assert_equal @user[:email], attributes['email']
        assert_equal @user[:first_name], attributes['firstName']

        assert_equal @user.couch[:id].to_s, json_response['data']['relationships']['couch']['data']['id']
      end

      test 'should edit own user information' do
        current_name = @user.first_name
        new_first_name = "#{@user.first_name}2"

        get '/api/v1/users/edit', headers: @headers

        assert_response :success
        json_response = response.parsed_body
        attributes = json_response['data']['attributes']

        assert_equal @user[:id], attributes['id']
        assert_equal current_name, attributes['firstName']

        params = { user: { first_name: new_first_name } }
        post("/api/v1/update/#{@user.id}", headers: @headers, params:)

        assert_response :success
        json_response = response.parsed_body
        attributes = json_response['data']['attributes']
        assert_equal @user[:id], attributes['id']
        assert_equal new_first_name, attributes['firstName']
        assert_equal 'Updated successfully.', json_response['meta']['message']
      end
    end
  end
end

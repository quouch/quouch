# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class ApiControllerTest < ActionDispatch::IntegrationTest
      test 'should redirect unauthorized calls' do
        get '/api/v1/users', headers: { 'Authorization' => nil }
        assert_response :unauthorized
      end

      test 'should not redirect when bearer token is present' do
        _, headers = api_prepare_headers
        get('/api/v1/users', headers:)
        assert_response :success
      end

      test 'should return 401 when the token is invalid' do
        _, headers = api_prepare_headers
        headers['Authorization'] = 'Bearer invalidToken'
        get('/api/v1/users', headers:)
        assert_response :unauthorized

        json_response = JSON.parse(response.body)
        assert_equal 401, json_response['code']
        assert_equal 'Invalid token.', json_response['error']
      end
    end
  end
end

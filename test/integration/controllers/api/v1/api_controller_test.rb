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
        user, headers = api_prepare_headers
        get '/api/v1/users', headers: headers
        assert_response :success
      end
    end
  end
end

require 'test_helper'

module Api
  module V1
    module Users
      class SessionsControllerTest < ActionDispatch::IntegrationTest
        include Devise::Test::IntegrationHelpers

        def setup
          @user = FactoryBot.create(:test_user)
          @user.password = 'password'
          @user.save!
        end

        test 'should log in with valid credentials' do
          credentials = { user: { email: @user.email, password: 'password' } }
          post '/api/v1/login', params: credentials
          json_response = JSON.parse(response.body)

          assert_response :success
          assert_equal @user[:id], json_response['data']['user']['id']
        end

        test 'should not log in with invalid credentials' do
          credentials = { user: { email: @user.email, password: 'wrong_password' } }
          post '/api/v1/login', params: credentials
          json_response = JSON.parse(response.body)

          assert_equal 401, json_response['code']
          assert_nil json_response['data']['user']
        end

        test 'should log out' do
          # first log in
          credentials = { user: { email: @user.email, password: 'password' } }
          post '/api/v1/login', params: credentials

          # then log out
          delete '/api/v1/logout', headers: { 'Authorization' => response.headers['Authorization'] }
          assert_response :success
          assert_nil session[:user_id]
        end

        def teardown
          ActiveStorage::Current.reset
          super
        end
      end
    end
  end
end

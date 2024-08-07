# frozen_string_literal: true

require 'test_helper'

class UserSessionTest < ActionDispatch::IntegrationTest
  setup do
    @password = 'password'
    @email = 'test@quouch.com'
    @user = create_user_with(email: @email, password: @password)
  end

  test 'should login user' do
    post user_session_path, params: { user: { email: @email, password: @password } }
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!

    assert_equal "Signed in successfully.", flash[:notice]
  end

  test 'should logout user' do
    # Login user
    sign_in_as(@user)

    # Logout user
    delete destroy_user_session_path
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!

    assert_equal "Signed out successfully.", flash[:notice]
  end
end

# frozen_string_literal: true

require 'test_helper'

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = FactoryBot.create(:user, :for_test, :with_couch)
  end

  test 'should reset forgotten password' do
    post user_password_url, params: { user: { email: @user.email } }
    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_includes flash[:notice],
                    'You will receive an email with instructions on how to reset your password in a few minutes.'

    reset_token = ActionMailer::Base.deliveries.last.body.match(/reset_password_token=(.*)"/)[1]

    patch user_password_path,
          params: { user: { password: 'newpassword', password_confirmation: 'newpassword',
                            reset_password_token: reset_token } }

    assert_response :redirect

    assert @user.reload.valid_password?('newpassword')
  end

  test 'should not reset forgotten password with invalid token' do
    post user_password_url, params: { user: { email: @user.email } }
    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_includes flash[:notice],
                    'You will receive an email with instructions on how to reset your password in a few minutes.'

    patch user_password_path,
          params: { user: { password: 'newpassword', password_confirmation: 'newpassword',
                            reset_password_token: 'invalidtoken' } }

    assert_response :unprocessable_entity

    assert_not @user.reload.valid_password?('newpassword')
  end

  test 'should reset forgotten password even if user is invalid' do
    # Make the user invalid
    @user.update_attribute(:last_name, nil)

    post user_password_url, params: { user: { email: @user.email } }
    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_includes flash[:notice],
                    'You will receive an email with instructions on how to reset your password in a few minutes.'

    reset_token = ActionMailer::Base.deliveries.last.body.match(/reset_password_token=(.*)"/)[1]

    patch user_password_path,
          params: { user: { password: 'newpassword', password_confirmation: 'newpassword',
                            reset_password_token: reset_token } }

    assert_response :redirect

    assert @user.reload.valid_password?('newpassword')
  end
end

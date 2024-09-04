require 'system_test_helper'

module Users
  class PasswordResetTest < ApplicationSystemTestCase
    include ActionMailer::TestHelper

    def setup
      @reset_user = FactoryBot.create(:user, :for_test, :with_couch)
    end

    test 'should not reset password with invalid email' do
      visit new_user_session_path

      click_on 'Forgot your password?'

      fill_in 'Email Address', with: 'notanemail@example.com'

      find('input[type="submit"]').click

      assert_selector '.form_error', text: 'not found'
    end

    test 'should reset password' do
      visit new_user_session_path

      click_on 'Forgot your password?'

      fill_in 'Email Address', with: @reset_user.email

      submit_and_open_reset_link

      new_password = 'newpassword'
      fill_in 'New password', with: new_password
      fill_in 'Confirm your new password', with: new_password

      find('input[type="submit"]').click

      assert_selector 'div.flash', text: 'Your password has been changed successfully.'

      assert @reset_user.reload.valid_password?(new_password)
    end

    test 'should reset password even if user is invalid' do
      # Make the user invalid
      @reset_user.first_name = ''
      @reset_user.save!(validate: false)

      visit new_user_session_path

      click_on 'Forgot your password?'

      fill_in 'Email Address', with: @reset_user.email

      submit_and_open_reset_link

      new_password = 'newpassword'
      fill_in 'New password', with: new_password
      fill_in 'Confirm your new password', with: new_password

      find('input[type="submit"]').click

      assert_selector 'div.flash', text: 'Your password has been changed successfully.'

      assert @reset_user.reload.valid_password?(new_password)
    end

    private

    def submit_and_open_reset_link
      assert_emails 1 do
        find('input[type="submit"]').click
      end

      assert_selector 'div.flash',
                      text: 'You will receive an email with instructions on how to reset your password in a few minutes.'

      # Get the reset password link
      sent_email = ActionMailer::Base.deliveries.last
      reset_password_link = sent_email.body.to_s.match(/href="(?<reset_link>.+?)"/)[:reset_link]

      # Remove the localhost part of the link
      reset_password_link = reset_password_link.gsub('http://localhost:3000', '')
      visit reset_password_link

      assert_selector 'h2', text: 'Change Password'.upcase
    end
  end
end

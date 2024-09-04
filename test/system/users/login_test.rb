# frozen_string_literal: true

require 'system_test_helper'

module Users
  class LoginTest < ApplicationSystemTestCase
    def setup
      @login_user = FactoryBot.create(:user, :for_test, :with_couch)
    end

    test 'should log in successfully' do
      visit root_path

      click_on 'Log in'

      fill_in 'Email Address', with: @login_user.email
      fill_in 'Password', with: @login_user.password

      # There are two log in buttons, one is a link and the other one is an input.
      # We want to click on the input one.
      find('input[type="submit"]').click

      assert_selector 'div.flash', text: 'Signed in successfully.'
    end

    test 'should not log in with invalid credentials' do
      visit root_path

      click_on 'Log in'

      fill_in 'Email Address', with: @login_user.email
      fill_in 'Password', with: 'invalid_password'

      # There are two log in buttons, one is a link and the other one is an input.
      # We want to click on the input one.
      find('input[type="submit"]').click

      assert_selector 'div.flash', text: 'Invalid Email or password.'
    end
  end
end

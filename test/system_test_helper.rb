ENV['RAILS_ENV'] ||= 'test'
require 'test_helper'
require 'application_system_test_case'
require 'selenium-webdriver'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400] do |driver_option|
    #driver_option.add_argument('headless')
    driver_option.add_argument('disable-search-engine-choice-screen')
  end
end

class ApplicationSystemTestCase
  def sign_in_as(user)
    visit new_user_session_path
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: user.password
    # There are two log in buttons, one if a link and the other one is an input.
    # We want to click on the input one.
    find('input[type="submit"]').click
  end

  fixtures :all


  Minitest.after_run do
    ActiveRecord::Base.subclasses.each do |subclass|
      subclass.delete_all if subclass.table_name
    end
  end
end

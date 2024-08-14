ENV['RAILS_ENV'] ||= 'test'
require 'test_helper'
require 'application_system_test_case'
require 'selenium-webdriver'
require_relative 'helpers/system_sign_in_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400] do |driver_option|
    driver_option.add_argument('headless') if ENV['CI']
    driver_option.add_argument('disable-search-engine-choice-screen')
  end
end

class ApplicationSystemTestCase
  include SystemSignInHelper

  fixtures :all
end

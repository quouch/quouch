ENV['RAILS_ENV'] ||= 'test'
require 'test_helper'
require 'selenium-webdriver'
require_relative 'helpers/system_sign_in_helper'

SCREEN_SIZES = {
  desktop: {
    "4k": [3840, 2160],
    "full_hd": [1920, 1080],
    "hd": [1366, 768],
    "sxga": [1280, 1024],
    "xga": [1024, 768]
  },
  mobile: {
    "iphone_se": [375, 667],
    "iphone_12_pro": [390, 844],
    "pixel_7": [412, 915],
    "galaxy": [360, 740],
  }
}

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  WINDOW_SIZE = SCREEN_SIZES[:desktop][:hd]

  driven_by :selenium, using: :chrome, screen_size: WINDOW_SIZE do |driver_option|
    driver_option.add_argument('headless') if ENV['CI']
    driver_option.add_argument('disable-search-engine-choice-screen')
  end
end

class ApplicationSystemTestCase
  include SystemSignInHelper

  fixtures :all
end

class MobileSystemTestCase < ApplicationSystemTestCase
  setup do
    current_window.resize_to(*SCREEN_SIZES[:mobile][:iphone_se])
  end

  teardown do
    current_window.resize_to(*ApplicationSystemTestCase::WINDOW_SIZE)
  end
end

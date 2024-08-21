ENV['RAILS_ENV'] ||= 'test'
require 'test_helper'
require 'selenium-webdriver'
require_relative 'helpers/system_sign_in_helper'

SCREEN_SIZES = {
  desktop: {
    '4k': [3840, 2160],
    full_hd: [1920, 1080],
    hd: [1366, 768],
    sxga: [1280, 1024],
    xga: [1024, 768]
  },
  mobile: {
    iphone_se: [375, 667],
    iphone_12_pro: [390, 844],
    pixel_7: [412, 915],
    galaxy: [360, 740]
  }
}.freeze

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

  setup do
    selected_screen_size = find_resolution
    current_window.resize_to(*selected_screen_size)
  end

  teardown do
    current_window.resize_to(*ApplicationSystemTestCase::WINDOW_SIZE)
  end

  protected

  def is_mobile?
    mobile_flag = ENV.fetch('MOBILE', false)
    mobile_flag == 'true' || mobile_flag == '1' || mobile_flag == 1 || mobile_flag == true
  end

  def is_desktop?
    !is_mobile?
  end

  private

  def find_resolution
    resolution = ENV.fetch('SCREEN_TYPE', 'hd').to_sym
    mobile = is_mobile?
    selected_screen_size = SCREEN_SIZES[mobile ? :mobile : :desktop][resolution]
    unless selected_screen_size
      warn "Invalid screen type: #{resolution}. Defaulting to #{mobile ? 'iphone_se' : 'hd'}"
      selected_screen_size = is_mobile? ? SCREEN_SIZES[:mobile][:iphone_se] : SCREEN_SIZES[:desktop][:hd]
    end

    selected_screen_size
  end
end

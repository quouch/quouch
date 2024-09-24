ENV['RAILS_ENV'] ||= 'test'
require 'test_helper'
require 'selenium-webdriver'
require_relative 'helpers/system_sign_in_helper'
require 'helpers/device_helper'

module SpecialSelectors
  private

  def select_date(css_selector, date)
    # TODO: enable selecting a different month
    find(css_selector).click
    assert_selector '.flatpickr-calendar', visible: true
    find('.flatpickr-day', text: date.day).click
  end
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include SystemSignInHelper
  include GeocoderMocker
  include SpecialSelectors

  driven_by :selenium, using: :chrome do |driver_option|
    driver_option.add_argument('headless') if ENV['CI']
    driver_option.add_argument('disable-search-engine-choice-screen')
  end

  fixtures :all

  setup do
    selected_screen_size = find_screen_size
    current_window.resize_to(*selected_screen_size)
  end

  teardown do
    current_window.resize_to(*default_window_size)
  end

  protected

  def mobile?
    mobile_flag = ENV.fetch('MOBILE', false)
    ['true', '1', 1, true].include?(mobile_flag)
  end

  def desktop?
    !mobile?
  end

  private

  def find_screen_size
    resolution = ENV.fetch('SCREEN_TYPE', 'hd').to_sym
    mobile = mobile?

    device_helper.find_screen_size(is_mobile: mobile, screen_type: resolution)
  end

  def device_helper
    @device_helper ||= DeviceHelper.new
  end

  def default_window_size
    [1366, 768]
  end
end

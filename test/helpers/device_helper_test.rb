# frozen_string_literal: true

require 'minitest/autorun'
require 'helpers/device_helper'

class DeviceHelperTest < Minitest::Test
  def setup
    @device_helper = DeviceHelper.new
  end

  def test_should_return_screen_resolution
    screen_size = @device_helper.find_screen_size
    assert_equal [1366, 768], screen_size
  end

  def test_should_return_screen_resolution_for_mobile
    screen_size = @device_helper.find_screen_size(is_mobile: true)
    assert_equal [375, 667], screen_size
  end

  def test_should_return_screen_resolution_for_mobile_pixel
    screen_size = @device_helper.find_screen_size(is_mobile: true, screen_type: 'pixel_7')
    assert_equal [412, 915], screen_size
  end
end

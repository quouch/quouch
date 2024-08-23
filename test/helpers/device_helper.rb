# frozen_string_literal: true

class DeviceHelper
  desktop_devices = {
    '4k': { screen_size: [3840, 2160] },
    full_hd: { screen_size: [1920, 1080] },
    hd: { screen_size: [1366, 768] },
    sxga: { screen_size: [1280, 1024] },
    xga: { screen_size: [1024, 768] }
  }
  mobile_devices = {
    iphone_se: { screen_size: [375, 667], os: 'ios' },
    iphone_12_pro: { screen_size: [390, 844], os: 'ios' },
    pixel_7: { screen_size: [412, 915], os: 'android' },
    galaxy: { screen_size: [360, 740], os: 'android' }
  }

  DEVICE_MAP = {
    desktop: desktop_devices,
    mobile: mobile_devices
  }.freeze

  def find_resolution(is_mobile: false, screen_type: 'hd')
    selected_screen_size = DEVICE_MAP[is_mobile ? :mobile : :desktop][screen_type.to_sym]
    unless selected_screen_size
      warn "Invalid screen type: #{screen_type}. Defaulting to #{is_mobile ? 'iphone_se' : 'hd'}"
      selected_screen_size = is_mobile ? DEVICE_MAP[:mobile][:iphone_se] : DEVICE_MAP[:desktop][:hd]
    end

    selected_screen_size
  end

  def find_screen_size(is_mobile: false, screen_type: 'hd')
    resolution = find_resolution(is_mobile:, screen_type:)
    resolution[:screen_size]
  end
end

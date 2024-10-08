# frozen_string_literal: true

require 'system_test_helper'

class MapTest < ApplicationSystemTestCase
  setup do
    # modify database to have only one possible host
    User.update_all(offers_couch: false, travelling: true)

    @user = FactoryBot.create(:user, :for_test, :with_couch)
    sign_in_as(@user)

    # create one active couch
    @host = FactoryBot.create(:user, :for_test, :offers_couch)
    # Fix host location to Mumbai
    mumbai_address = ADDRESSES.find { |address| address[:city] == 'Mumbai' }
    @host.address = mumbai_address[:street]
    @host.city = mumbai_address[:city]
    @host.country = mumbai_address[:country]
    @host.country_code = mumbai_address[:country_code]
    @host.zipcode = mumbai_address[:zipcode]
    @host.longitude = 72.869247
    @host.latitude = 19.073816
    @host.save!
  end

  test 'should see map with one marker' do
    visit couches_path

    assert_selector '.mapboxgl-canvas', visible: true

    click_on_map

    assert_selector '.mapboxgl-popup-content'

    assert_selector '.mapboxgl-popup__name', text: @host.first_name
  end

  test 'should navigate to couch page' do
    visit couches_path

    click_on_map

    assert_selector '.mapboxgl-popup-content'

    find('.mapboxgl-popup__link > img').click

    assert_current_path couch_path(@host.couch)

    assert_selector '.couch__name', text: @host.first_name
  end

  private

  def click_on_map
    map_selector = '.mapboxgl-canvas'
    canvas = find(map_selector)
    # Scroll to the map to make sure the markers are visible,
    # then click on the map (will click the center, which should have a marker)
    scroll_to(canvas, align: :center)
    sleep(1)
    canvas.click
  end
end

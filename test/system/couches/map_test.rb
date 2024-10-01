# frozen_string_literal: true

require 'system_test_helper'

class MapTest < ApplicationSystemTestCase
  setup do
    # modify database to have only one possible host
    User.update_all(offers_couch: false, travelling: true)

    @user = FactoryBot.create(:user, :for_test, :with_couch)
    sign_in_as(@user)

    # create one active couch
    FactoryBot.create(:user, :for_test, :offers_couch)
  end

  test 'should see map with markers' do
    visit couches_path

    assert_selector '.mapboxgl-canvas', visible: true

    # Check that all markers are present
    assert_selector '.mapboxgl-marker', count: 1
  end

  test 'should filter by city' do
    city_name = 'Test city'
    new_user = FactoryBot.create(:user, :for_test, :offers_couch)
    new_user.city = city_name
    new_user.save

    city = new_user.city

    visit couches_path

    fill_in 'Find hosts in location', with: city
    click_on 'Search'

    assert_selector '.mapboxgl-marker', count: 1
  end

  test 'should filter by characteristics' do
    new_user = FactoryBot.create(:user, :for_test, :offers_couch)
    characteristic = Characteristic.create!(name: 'Test Characteristic')
    new_user.characteristics << characteristic

    visit couches_path
    find('.search__hide-filters').click if mobile?

    find('label', text: characteristic.name).click

    assert_selector '.mapboxgl-marker', count: 1
  end

  test 'should see marker info' do
    visit couches_path

    marker = first('.mapboxgl-marker i')

    couch_id = marker[:'data-couch-id']
    couch_user = Couch.find(couch_id).user

    marker.click

    assert_selector '.mapboxgl-popup-content'
    assert_selector '.mapboxgl-popup__name', text: couch_user.first_name
  end

  test 'should navigate to couch page' do
    visit couches_path

    marker = first('.mapboxgl-marker i', obscured: false)

    couch_id = marker[:'data-couch-id']
    couch = Couch.find(couch_id)

    marker.click

    find('.mapboxgl-popup__link > img').click

    assert_current_path couch_path(couch)

    assert_selector '.couch__name', text: couch.user.first_name
  end
end

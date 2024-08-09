# frozen_string_literal: true

require 'system_test_helper'

class CouchesFilterTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:test_user_couch)
    sign_in_as(@user)
  end

  test 'should see first page of couches' do
    visit couches_path
    # As we have 16 couches, we should see a full first page
    assert_selector 'li.couches__list-item', count: 9
  end

  test 'should see pagination buttons' do
    visit couches_path
    assert_selector 'nav.pagy-nav', count: 1
    assert_selector 'span.page.prev', class: 'disabled'
    assert_selector 'span.page.next', count: 1
    assert_selector 'span.page.active', text: '1'
  end

  test 'should navigate to second page' do
    visit couches_path

    # As we have 16 couches, we should only see 7 in the second page
    find('span.page.next').click

    # First, check that the navigation is correct
    assert_selector 'span.page.prev', count: 1
    assert_selector 'span.page.prev', class: 'disabled', count: 0
    assert_selector 'span.page.active', text: '2'

    # Then, check that the number of couches is correct
    assert_selector 'li.couches__list-item', count: 7
  end

  test 'should filter by city' do
    first_user = User.first!
    city = first_user.city

    # Find how many users have the same city as that user
    users_with_city = User.where(city: city)

    # Search with query filter
    visit couches_path
    fill_in 'Find hosts in location', with: city
    click_on 'Search'

    # Check that the number of couches returned matches the number of users with that city
    assert_selector 'li.couches__list-item', count: users_with_city.length
  end

  test 'should filter by country' do
    first_user = User.first!
    country = first_user.country

    # Find how many users have the same country as that user
    users_with_country = User.where(country: country)

    # Search with query filter
    visit couches_path
    fill_in 'Find hosts in location', with: country
    click_on 'Search'

    # Check that the number of couches returned matches the number of users with that country
    assert_selector 'li.couches__list-item', count: users_with_country.length
  end

  test 'should filter by characteristics' do
    characteristic = Characteristic.first!

    # Search with characteristics filter and items count = 100
    visit couches_path
    find('label', text: characteristic.name).click

    # Check that the number of couches returned matches the number of users with that characteristic
    # according to the fixtures, there should be 17 users with this characteristic, so we should see the entire first page
    assert_selector 'li.couches__list-item', count: 9

    # navigate to second page
    find('span.page.next').click

    assert_selector 'span.page.active', text: '2'
    # according to the fixtures, there should be 16 users with this characteristic, so we should see 7 in the second page
    assert_selector 'li.couches__list-item', count: 7
  end

  test 'should filter multiple characteristics' do
    characteristic1 = Characteristic.first!
    characteristic2 = Characteristic.second!

    # Select both characteristics
    visit couches_path
    find('label', text: characteristic1.name).click
    find('label', text: characteristic2.name).click

    # according to the fixtures, there should be 6 users with both characteristics
    assert_selector 'li.couches__list-item', count: 6

    # check that all results have this characteristic
    all('li.couches__list-item').each do |couch|
      assert couch.has_selector?('li', text: characteristic1.name)
      assert couch.has_selector?('li', text: characteristic2.name)
    end
  end

  test 'clear filters' do
    characteristic = Characteristic.third!

    # Search with characteristics filter
    visit couches_path
    find('label', text: characteristic.name).click

    # should have two pages of results
    assert_selector 'span.page.active', text: '1'
    assert_selector 'span.page', text: '2'
    # According to the fixtures, there should be 10 users with this characteristic
    assert_selector 'li.couches__list-item', count: 9

    # Navigate to page 2, where there should be only one result
    find('span.page.next').click
    sleep(1)
    assert_selector 'span.page.active', text: '2'
    assert_selector 'li.couches__list-item', count: 1

    # Clear the filter and check that we are back to the first page
    click_on 'Clear Filter'
    assert_selector 'span.page.active', text: '1'
    assert_selector 'li.couches__list-item', count: 9

    # Navigate to page 2, where there should be 7 more results
    find('span.page.next').click
    assert_selector 'span.page.active', text: '2'
    assert_selector 'li.couches__list-item', count: 7
  end

  private
end

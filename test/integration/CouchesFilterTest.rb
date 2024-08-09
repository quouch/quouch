# frozen_string_literal: true

require 'test_helper'

class CouchesFilterTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:test_user_couch)
    sign_in_as(@user)
  end

  test 'should see couches filter' do
    # Check that we're in the dashboard
    assert_response :success
    assert_select 'form[action=?]', couches_path
  end

  test 'should see first page of couches' do
    get couches_path
    assert_response :success
    # As we have 16 couches, we should see a full first page
    assert_select 'li.couches__list-item', 9
  end

  test 'should see pagination buttons' do
    get couches_path
    assert_select 'nav.pagy-nav', 1
    assert_select 'span.page.prev.disabled', 1
    assert_select 'span.page.active', '1'
    assert_select 'a[rel=next]', '2'
    assert_select 'span.page.next', 1
  end

  test 'should see second page' do
    get couches_path(page: 2)

    assert_response :success
    # As we have 16 couches, we should only see 7 in the second page
    assert_select 'li.couches__list-item', 7
    assert_select 'span.page.active', '2'
    assert_select 'span.page.prev.disabled', 0
    assert_select 'span.page.prev', 1
  end

  test 'should filter by city' do
    first_user = User.first!
    city = first_user.city

    # Find how many users have the same city as that user
    users_with_city = User.where(city: city)

    # Search with query filter
    params = { query: city }
    get couches_path(params)

    assert_response :success
    # Check that the number of couches returned matches the number of users with that city
    assert_select 'li.couches__list-item', users_with_city.length
  end

  test 'should filter by country' do
    first_user = User.first!
    country = first_user.country

    # Find how many users have the same country as that user
    users_with_country = User.where(country: country)

    # Search with query filter
    params = { query: country }
    get couches_path(params)

    assert_response :success
    # Check that the number of couches returned matches the number of users with that country
    assert_select 'li.couches__list-item', users_with_country.length
  end

  test 'should filter by characteristics' do
    characteristic = Characteristic.first!
    # Find how many users have this characteristic
    users_with_characteristic = User.joins(:user_characteristics).where(user_characteristics: { characteristic: characteristic })

    # Search with characteristics filter and items count = 100
    params = { characteristics: [characteristic.id], items: 100 }
    get couches_path(params)

    assert_response :success
    # Check that the number of couches returned matches the number of users with that characteristic
    assert_select 'li.couches__list-item', users_with_characteristic.length
    # check that the characteristic is checked
    assert_select 'input#characteristic_' + characteristic.id.to_s + '[checked=checked]', 1

  end

  test 'should filter multiple characteristics' do
    characteristic1 = Characteristic.first!
    characteristic2 = Characteristic.second!

    # Search with characteristics filter and items count = 100
    params = { characteristics: [characteristic1.id, characteristic2.id], items: 100 }
    get couches_path(params)

    assert_response :success

    # according to the fixtures, there should be 6 users with both characteristics
    assert_select 'li.couches__list-item', 6
    # check that the characteristics are checked
    assert_select 'input#characteristic_' + characteristic1.id.to_s + '[checked=checked]', 1
    assert_select 'input#characteristic_' + characteristic2.id.to_s + '[checked=checked]', 1
  end

  private
end

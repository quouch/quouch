# frozen_string_literal: true

require 'test_helper'

class AddressHelperTest < ActiveSupport::TestCase
  include AddressHelper

  ADDRESSES.each_with_index do |address, index|
    define_method "test_should_beautify_address_#{index}" do
      country = address[:country_code]

      assert_equal address[:country], beautify_country(country), "Address #{address[:address]} failed"
    end
  end

  test 'should throw an error if the country is not found' do
    country = 'XX'

    assert_raise(ArgumentError) { beautify_country(country) }
  end

  test 'should throw an error if the country cannot be translated' do
    issue_countries_in_db = %w[DE NL FI US AT FR NO]

    issue_countries_in_db.each do |country_code|
      # Assert that no errors are thrown for the countries in the list
      assert_nothing_raised { beautify_country(country_code) }
    end
  end

  test 'should format address' do
    address = { street: 'Main Street', zipcode: '12345', city: 'Springfield', country: 'US' }
    formatted_address = AddressHelper::Formatter.format_address(address)
    assert_equal 'Main Street, 12345, Springfield, US', formatted_address
  end

  test 'should find country code' do
    country = 'Germany'
    assert_equal 'DE', find_country_code(country)

    country = 'Netherlands'
    assert_equal 'NL', find_country_code(country)

    country = 'Oman'
    assert_equal 'OM', find_country_code(country)

    country = 'Bhutan'
    assert_equal 'BT', find_country_code(country)
  end
end

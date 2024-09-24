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

  test 'should map United States to US' do
    country = 'United States'
    assert_equal 'US', find_country_code(country)
  end

  test 'should map United Kingdom to GB' do
    country = 'United Kingdom'
    assert_equal 'GB', find_country_code(country)
  end

  test 'should map The Bahamas to BS' do
    country = 'The Bahamas'
    assert_equal 'BS', find_country_code(country)
  end

  test 'should handle all countries where the iso_short_name does not match the translation' do
    skip 'This test is slow and should be run manually' unless ENV['SLOW_TESTS']

    all_iso_countries = ISO3166::Country.all

    all_iso_countries.each do |iso_country|
      country = beautify_country(iso_country.alpha2)
      next unless country != iso_country.iso_short_name

      Rails.logger.debug "Country '#{country}' has a translation that is not the same as the short name #{iso_country.iso_short_name}"

      assert_equal iso_country.alpha2, find_country_code(country)
    end
  end
end

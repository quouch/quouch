# frozen_string_literal: true

require 'test_helper'

class RegistrationConcernTest < ActiveSupport::TestCase
  include RegistrationConcern

  setup do
    create_seed_user

    @user = FactoryBot.create(:user, :with_couch, :for_test)
    @couch = @user.couch
  end

  ADDRESSES.each_with_index do |address, index|
    define_method "test_should_beautify_address_#{index}" do
      params[:user] = {
        country: address[:country_code]
      }

      assert_equal address[:country], beautify_country, "Address #{address[:address]} failed"
    end
  end

  test 'should throw an error if the country is not found' do
    params[:user] = {
      country: 'XX'
    }

    assert_raise(ArgumentError) { beautify_country }
  end

  test 'should throw an error if the country cannot be translated' do
    issue_countries_in_db = %w[DE NL FI US AT FR NO]

    issue_countries_in_db.each do |country_code|
      params[:user] = {
        country: country_code
      }

      # Assert that no errors are thrown for the countries in the list
      assert_nothing_raised { beautify_country }
    end
  end

  test 'should find the user ID by invite code' do
    other_user = FactoryBot.create(:user)
    invite_code = other_user.invite_code

    params[:invite_code] = invite_code
    found_id = find_invited_by
    assert_equal other_user.id, found_id
  end

  test 'should not find the user ID by invalid invite code' do
    params[:invite_code] = 'invalid'
    found_id = find_invited_by
    assert_nil found_id
  end

  test 'should find the user ID when invite code is capitalized' do
    other_user = FactoryBot.create(:user)
    invite_code = other_user.invite_code

    params[:invite_code] = invite_code.upcase
    found_id = find_invited_by
    assert_equal other_user.id, found_id
  end

  test 'should find the user ID when invite code includes spaces' do
    other_user = FactoryBot.create(:user)
    invite_code = other_user.invite_code

    params[:invite_code] = "  #{invite_code}  "
    found_id = find_invited_by
    assert_equal other_user.id, found_id
  end

  test 'should update the user profile with beautified country' do
    params[:user] = {
      country: 'DE'
    }

    update_profile
    @user.reload
    assert_equal 'Germany', @user.country
  end

  test 'should raise an error if facilities are empty' do
    params[:couch_facility] = {
      facility_ids: []
    }

    assert_raise(ArgumentError) { create_couch_facilities }

    params[:couch_facility] = {
      facility_ids: ['']
    }

    assert_raise(ArgumentError) { create_couch_facilities }
  end

  test 'should save couch facilities' do
    facility = Facility.first
    params[:couch_facility] = {
      facility_ids: [facility.id.to_s]
    }

    create_couch_facilities
    assert_equal 1, @couch.couch_facilities.count
  end

  test 'should not save empty couch facilities' do
    facility = Facility.first
    params[:couch_facility] = {
      facility_ids: ['', facility.id.to_s]
    }

    create_couch_facilities
    assert_equal 1, @couch.couch_facilities.count
  end

  test 'should remove couch facilities' do
    facility = Facility.first
    params[:couch_facility] = {
      facility_ids: [facility.id.to_s]
    }

    create_couch_facilities
    assert_equal 1, @couch.couch_facilities.count

    params[:couch_facility] = {}

    create_couch_facilities
    assert_equal 0, @couch.couch_facilities.count
  end
end

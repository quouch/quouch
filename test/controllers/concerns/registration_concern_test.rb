# frozen_string_literal: true

require 'test_helper'

class RegistrationConcernTest < ActiveSupport::TestCase
  include RegistrationConcern

  setup do
    create_seed_user

    @user = FactoryBot.create(:user)
  end

  test 'should beautify all countries in the addresses' do
    ADDRESSES.each do |address|
      params[:user] = {
        country: address[:country_code]
      }

      assert_equal address[:country], beautify_country
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
end

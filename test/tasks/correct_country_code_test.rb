require 'test_helper'
require 'rake'

class CorrectCountryCodeTest < ActiveSupport::TestCase
  fixtures :users

  setup do
    # load the rake tasks
    Rails.application.load_tasks
  end

  test 'should change Germany to DE' do
    # prepare the data to have one user with country Germany
    @user = User.all.sample
    @user.update_attribute(:country_code, 'Germany')
    @user.update_attribute(:country, 'Germany')

    Rake::Task['users:convert_country_to_country_code'].invoke

    # assert that the country codes have been converted
    @user.reload
    assert_equal 'DE', @user.country_code
    assert_equal 'Germany', @user.country
  end

  test 'should convert country to country code' do
    original_countries = {}
    # prepare the data to have users with invalid country codes
    User.all.each do |user|
      user.update_attribute(:country_code, user.country)
      original_countries[user.id] = user.country
    end

    Rake::Task['users:convert_country_to_country_code'].invoke

    # assert that the country codes have been converted
    User.all.each do |user|
      assert_not_equal user.country, user.country_code
      assert_equal original_countries[user.id], user.country
    end
  end
end

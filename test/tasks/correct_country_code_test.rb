require 'test_helper'
require 'rake'

class CorrectCountryCodeTest < ActiveSupport::TestCase
  fixtures :users

  setup do
    # load the rake tasks
    Rails.application.load_tasks
  end

  test 'should convert country to country code' do
    original_countries = {}
    # prepare the data to have users with invalid country codes
    User.all.each do |user|
      random_country = ADDRESSES.sample[:country]
      user.update_attribute(:country_code, random_country)
      user.update_attribute(:country, random_country)
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

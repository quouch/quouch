require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  def setup
    @user = FactoryBot.build(:user, :for_test)
    super
  end

  test 'should not save user without a first name' do
    @user.first_name = nil
    assert_not @user.valid?
  end

  test 'should not save user without a last name' do
    @user.last_name = nil
    assert_not @user.valid?
  end

  test 'should not save user without a date of birth' do
    @user.date_of_birth = nil
    assert_not @user.valid?
  end

  test 'should not save user without an address' do
    @user.address = nil
    assert_not @user.valid?
  end

  test 'should not save user without a zipcode' do
    @user.zipcode = nil
    assert_not @user.valid?
  end

  test 'should not save user without a city' do
    @user.city = nil
    assert_not @user.valid?
  end

  test 'should not save user without a country' do
    @user.country_code = nil
    @user.country = nil
    assert_not @user.valid?
    assert_equal @user.errors.messages[:country], ['Country required']
    assert_equal @user.errors.messages[:country_code], ['Please provide a valid country code']
  end

  test 'should calculate the country based on the country_code' do
    @user.country_code = 'DE'
    @user.country = nil

    assert @user.valid?
    assert_equal 'Germany', @user.country
  end

  test 'should fail if the country code is not an ISO code' do
    @user.country_code = 'DEU'
    @user.country = nil

    assert_not @user.valid?
    assert_equal @user.errors.messages[:country_code], ['Please provide a valid country code']
  end

  test 'should overwrite the country if both are present' do
    @user.country_code = 'DE'
    @user.country = 'Deutschland'

    assert @user.valid?
    assert_equal 'Germany', @user.country
  end

  test 'should not save user without a summary' do
    @user.summary = nil
    assert_not @user.valid?
  end

  test 'should not save user with a summary less than 50 characters' do
    @user.summary = 'Short summary'
    assert_not @user.valid?
  end

  test 'should not save user without characteristics' do
    @user.user_characteristics = []
    UserCharacteristic.where(user: @user).delete_all

    assert_not @user.valid?
    assert_equal @user.errors.messages[:user_characteristics], ['Let others know what is important to you']
  end

  test 'should not save user if age is less than 18' do
    @user.date_of_birth = 5.years.ago
    assert_not @user.valid?
    assert_equal @user.errors.messages[:date_of_birth], ['Sorry you are too young, please come back when you are 18!']
  end

  test 'should not save user if no option is checked' do
    @user.offers_couch = false
    @user.offers_co_work = false
    @user.offers_hang_out = false
    @user.travelling = false
    assert_not @user.valid?
    assert_equal @user.errors.messages[:travelling], ['at least one option must be checked']
  end

  test 'should save user with valid attributes' do
    assert @user.valid?, 'User is not valid'
  end

  test 'should properly calculate age' do
    @user.date_of_birth = 20.years.ago
    assert_equal 20, @user.calculated_age

    @user.date_of_birth = 20.years.ago + 1.day
    assert_equal 19, @user.calculated_age
  end

  test 'should generate invite code' do
    @user.generate_invite_code
    assert_not_nil @user.invite_code
  end

  test 'should not save user without invite code' do
    @user.invited_by_id = nil
    assert_not @user.valid?
    assert_equal @user.errors.messages[:invited_by_id], ['Please provide a valid invite code']
  end

  test 'should manually geocode address' do
    # reset the user's latitude and longitude
    @user.latitude = nil
    @user.longitude = nil

    @user.manual_geocode
    assert_not_nil @user.latitude
    assert_not_nil @user.longitude
    assert_equal 1, @user.latitude
  end

  test 'should add an error if the address does not exist' do
    # Make GeocoderService.execute return an empty array
    GeocoderService.stub :execute, ->(_address) { [] } do
      @user.manual_geocode
      assert_equal @user.errors.messages[:address], ['Geocoding failed, please provide a valid address']
    end
  end

  test 'should be valid if offers couch and has facilities' do
    @user = FactoryBot.create(:user, :for_test, :with_couch)
    @user.couch.couch_facilities.destroy_all

    @user.couch.couch_facilities.create(facility: Facility.first)
    @user.offers_couch = true
    assert @user.valid?
  end

  test 'should not be valid if offers couch and has no facilities' do
    @user = FactoryBot.create(:user, :for_test, :with_couch)
    @user.couch.couch_facilities.destroy_all

    @user.offers_couch = true
    assert_not @user.valid?
  end

  test 'should be valid if not offers couch and has no facilities' do
    @user = FactoryBot.create(:user, :for_test)
    @user.offers_couch = false
    assert @user.valid?
  end

  test 'should subscribe to plan' do
    @user = FactoryBot.create(:user, :for_test)
    plan = FactoryBot.create(:plan, user: @user)
    assert_equal plan, @user.subscription.plan
    assert @user.subscription.present?
    assert @user.subscription.stripe_id_present?
  end

  test 'should not be subscribed' do
    @user = FactoryBot.create(:user, :for_test)
    assert_not @user.subscribed?
  end

  test 'should not be subscribed without Stripe ID' do
    plan = FactoryBot.create(:plan)
    @user = FactoryBot.create(:user, :for_test)
    assert_not @user.subscribed?

    Subscription.create!(user: @user, plan: plan)
    assert @user.subscription.present?
    assert_not @user.subscribed?
  end

  test 'should be subscribed' do
    @user = FactoryBot.create(:user, :for_test, :subscribed)
    assert @user.subscribed?
  end
end

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  def setup
    @user = FactoryBot.build(:test_user)
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
    @user.country = nil
    assert_not @user.valid?
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

  test 'should save first user without invite code' do
    # Remove all users first
    User.delete_all

    assert_equal 0, User.count
    @user.invited_by_id = nil
    assert_equal true, @user.valid?
  end

  test 'should not save user without invite code when other users are present' do
    assert_not_equal 0, User.count

    @user.invited_by_id = nil
    assert_not @user.valid?
    assert_equal @user.errors.messages[:invited_by_id], ['Please provide a valid invite code']
  end
end

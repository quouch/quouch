require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    random_address = ADDRESSES.sample
    @user = User.new(
      first_name: 'John',
      last_name: 'Doe',
      email: Faker::Internet.email,
      password: Faker::Internet.password,
      date_of_birth: 25.years.ago,
      address: random_address[:street],
      zipcode: random_address[:zipcode],
      city: random_address[:city],
      country: random_address[:country],
      summary: Faker::Hipster.paragraph_by_chars(characters: 60),
      characteristics: [Characteristic.first, Characteristic.second],
      offers_couch: true
    )

    @user.photo.attach(active_storage_blobs(:avatar_blob))
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
    @user.characteristics = []
    assert_not @user.valid?
  end

  test 'should not save user if age is less than 18' do
    @user.date_of_birth = 5.years.ago
    assert_not @user.valid?
  end

  test 'should not save user if no option is checked' do
    @user.offers_couch = false
    @user.offers_co_work = false
    @user.offers_hang_out = false
    @user.travelling = false
    assert_not @user.valid?
  end

  test 'should save user with valid attributes' do
    assert @user.valid?, 'User is not valid'
  end
end

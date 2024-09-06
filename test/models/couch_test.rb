require 'test_helper'

class CouchTest < ActiveSupport::TestCase
  test 'should not save couch without a user' do
    couch = Couch.new
    assert_not couch.valid?
  end

  test 'should save couch with a user' do
    create_seed_user
    @user = FactoryBot.create(:user, :for_test)

    couch = Couch.new(user: @user)
    assert couch.valid?
  end

  test 'should have facilities' do
    create_seed_user
    @user = FactoryBot.create(:user, :for_test)
    couch = Couch.new(user: @user)
    couch.save

    facility = Facility.first
    couch.couch_facilities.create(facility:)

    assert couch.facilities?
  end

  test 'should not have facilities' do
    create_seed_user
    @user = FactoryBot.create(:user, :for_test)
    couch = Couch.new(user: @user)
    couch.save

    assert_not couch.facilities?
  end

  test 'should remove facilities' do
    create_seed_user
    @user = FactoryBot.create(:user, :for_test)
    couch = Couch.new(user: @user)
    couch.save

    facility = Facility.first
    couch.couch_facilities.create(facility:)
    couch.couch_facilities.destroy_all

    assert_not couch.facilities?
  end
end

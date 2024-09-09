# frozen_string_literal: true

require 'test_helper'

class RegistrationConcernTest < ActiveSupport::TestCase
  include RegistrationConcern

  setup do
    create_seed_user

    @user = FactoryBot.create(:user, :with_couch, :for_test)
    @couch = @user.couch
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

    params[:couch_facility] = {
      facility_ids: []
    }

    create_couch_facilities
    assert_equal 0, @couch.couch_facilities.count
  end
end

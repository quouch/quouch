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

  def params
    @params ||= {}
  end

  def session
    @session ||= {}
  end
end

require 'test_helper'

module Users
  class UpdateRegistrationTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      # First, create a user
      @user = FactoryBot.create(:user, :for_test, :with_couch)
      sign_in @user

      @user_data = @user.attributes
      @user_data['current_password'] = @user.password
    end

    test 'should update the user' do
      @user_data['first_name'] = 'New name'
      patch user_registration_url,
            params: { user: @user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_response :redirect
      @user.reload
      assert_equal 'New name', @user.first_name
    end

    test 'should not change characteristics if user_characteristics is not sent' do
      current_characteristics = @user.user_characteristics
      # Update the user without characteristics
      patch user_registration_url,
            params: { user: @user_data }

      assert_response :redirect
      @user.reload
      assert_equal current_characteristics, @user.user_characteristics
    end

    test 'should not update the user if the user_characteristics are empty' do
      @user_data['first_name'] = 'New name'
      patch user_registration_url,
            params: { user: @user_data,
                      user_characteristic: { characteristic_ids: [] } }

      assert_response :unprocessable_entity
      @user.reload
      assert_not_equal 'New name', @user.first_name
    end

    test 'should not update the user if the current password is wrong' do
      @user_data['first_name'] = 'New name'
      @user_data['current_password'] = 'wrong_password'
      patch user_registration_url,
            params: { user: @user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_response :unprocessable_entity
      @user.reload
      assert_not_equal 'New name', @user.first_name
    end

    test 'should beautify the country on update' do
      @user_data['country_code'] = 'IT'
      patch user_registration_url,
            params: { user: @user_data,
                      password: @user.password,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_response :redirect
      @user.reload
      assert_equal 'Italy', @user.country
    end

    test 'should save couch facilities' do
      # Update the user with facilities
      patch user_registration_url,
            params: { user: @user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] },
                      couch_facility: { facility_ids: [Facility.first.id] } }

      assert_response :redirect
      @user.reload
      assert_equal 1, @user.couch.couch_facilities.count
    end

    test 'should save user without facilities' do
      @user_data['offers_couch'] = false
      @user_data['offers_hang_out'] = true
      patch user_registration_url,
            params: { user: @user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_response :redirect
      @user.reload
      assert_equal 0, @user.couch.couch_facilities.count
      assert_equal false, @user.offers_couch
      assert_equal true, @user.offers_hang_out
    end

    test 'should not update if facilities are empty' do
      @user_data['first_name'] = 'New name'
      @user_data['offers_couch'] = true
      # Update the user with facilities
      patch user_registration_url,
            params: { user: @user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] },
                      couch_facility: { facility_ids: [] } }

      assert_response :unprocessable_entity
      @user.reload
      assert_not_equal 'New name', @user.first_name
    end

    test 'should not save user that offers couch without facilities' do
      @user_data['first_name'] = 'New name'
      @user_data['offers_couch'] = true
      patch user_registration_url,
            params: { user: @user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_response :unprocessable_entity
      @user.reload
      assert_equal 0, @user.couch.couch_facilities.count
      assert_not_equal 'New name', @user.first_name
    end

    test 'should not remove couch facilities' do
      # Update the user with facilities
      patch user_registration_url,
            params: { user: @user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] },
                      couch_facility: { facility_ids: [Facility.first.id] } }

      assert_response :redirect
      @user.reload
      assert_equal 1, @user.couch.couch_facilities.count

      # Update the user without facilities and check if the facilities are removed
      @user_data['offers_couch'] = false
      @user_data['offers_hang_out'] = true
      patch user_registration_url,
            params: { user: @user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_response :redirect
      @user.reload
      assert_equal 1, @user.couch.couch_facilities.count
    end

    test 'should only change the password' do
      password_data = {
        password: 'new_password',
        password_confirmation: 'new_password',
        email: 'anotheremail@quouch.com',
        old_password: @user.password
      }

      patch user_registration_url, params: { user: password_data }

      assert_response :redirect
      @user.reload
      assert @user.valid_password?('new_password')
      assert_equal @user_data['email'], User.last.email
    end

    test 'should not change the password if new password is invalid' do
      password_data = {
        password: 'a',
        password_confirmation: 'a',
        old_password: @user.password
      }

      patch user_registration_url, params: { user: password_data }

      assert_response :unprocessable_entity
      @user.reload
      assert @user.valid_password?(@user.password)
    end

    test 'should not change the password if confirmation does not match' do
      password_data = {
        password: 'strongpassword',
        password_confirmation: 'b',
        old_password: @user.password
      }

      patch user_registration_url, params: { user: password_data }

      assert_response :unprocessable_entity
      @user.reload
      assert @user.valid_password?(@user.password)
    end

    test 'should not change the password if the current password is wrong' do
      password_data = {
        password: 'new_password',
        password_confirmation: 'new_password',
        old_password: 'wrong_password'
      }

      patch user_registration_url,
            params: { user: password_data }

      assert_response :unprocessable_entity
    end

    test 'should change the password even if user is invalid' do
      # Make the user invalid
      @user.first_name = ''
      @user.save!(validate: false)

      password_data = {
        password: 'new_password',
        password_confirmation: 'new_password',
        first_name: '',
        old_password: @user.password
      }
      patch user_registration_url,
            params: { user: password_data }

      assert_response :redirect
      @user.reload
      assert @user.valid_password?('new_password')
    end
  end
end

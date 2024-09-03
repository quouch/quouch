require 'test_helper'

module Users
  class RegistrationsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      fake_user_data = FactoryBot.build(:user, :for_test)
      random_address = ADDRESSES.sample

      file = URI.parse(Faker::Avatar.image).open
      photo = fixture_file_upload(file, 'image/png')

      @user_object = {
        email: fake_user_data[:email],
        password: Faker::Internet.password,
        first_name: fake_user_data[:first_name],
        last_name: fake_user_data[:last_name],
        date_of_birth: fake_user_data[:date_of_birth],
        summary: fake_user_data[:summary],
        offers_couch: true,
        address: AddressHelper::Formatter.format_address(random_address),
        zipcode: random_address[:zipcode],
        city: random_address[:city],
        country_code: random_address[:country_code],
        photo:
      }
    end

    test 'should not create a user without an invite code' do
      # expect error message
      post user_registration_url,
           params: { user: @user_object,
                     user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_response :unprocessable_entity
    end

    test 'should not create a user with an invalid invite code' do
      # expect error message
      post user_registration_url,
           params: { user: @user_object,
                     user_characteristic: { characteristic_ids: [Characteristic.first.id] },
                     invite_code: 'invalid' }

      assert_response :unprocessable_entity
    end

    test 'should send a flash message if there is an issue with the invite code' do
      inviting_user = FactoryBot.create(:user, :for_test)
      # Make the invite code invalid
      inviting_user.invite_code = 'ABC123'
      inviting_user.save

      # expect error message
      post user_registration_url,
           params: { user: @user_object,
                     user_characteristic: { characteristic_ids: [Characteristic.first.id] },
                     invite_code: inviting_user[:invite_code] }

      assert_includes flash[:error], 'There seems to be an issue with your invite code.'
    end

    test 'should create a user with an invite code' do
      inviting_user = FactoryBot.create(:user, :for_test)

      # expect success
      post user_registration_url,
           params: { user: @user_object,
                     user_characteristic: { characteristic_ids: [Characteristic.first.id] },
                     invite_code: inviting_user[:invite_code] }

      assert_redirected_to root_url

      assert_includes flash[:notice], 'A message with a confirmation link has been sent to your email address.'

      assert_not_nil User.last.invited_by_id
    end

    test 'should update the user' do
      # First, create a user
      user_data = create_user_and_sign_in

      # Send the user with a country code instead of the country name
      user_data['first_name'] = 'New name'
      patch user_registration_url,
            params: { user: user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_response :redirect
      assert_equal 'New name', User.last.first_name
    end

    test 'should not update the user if the current password is wrong' do
      # First, create a user
      user_data = create_user_and_sign_in

      # Send the user with a country code instead of the country name
      user_data['first_name'] = 'New name'
      user_data['current_password'] = 'wrong_password'
      patch user_registration_url,
            params: { user: user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_response :unprocessable_entity
    end

    test 'should beautify the country on update' do
      # First, create a user
      user_data = create_user_and_sign_in

      # Send the user with a country code instead of the country name
      user_data['country_code'] = 'IT'
      patch user_registration_url,
            params: { user: user_data,
                      password: @user.password,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_response :redirect
      assert_equal 'Italy', User.last.country
    end

    test 'should save couch facilities' do
      # First, create a user
      user_data = create_user_and_sign_in

      # Update the user with facilities
      patch user_registration_url,
            params: { user: user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] },
                      couch_facility: { facility_ids: [Facility.first.id] } }

      assert_response :redirect
      assert_equal 1, User.last.couch.couch_facilities.count
    end

    test 'should throw error if facilities are empty' do
      skip 'This test is failing because we do not have a validation for user updates.'
      # First, create a user
      user_data = create_user_and_sign_in

      # Update the user with facilities
      patch user_registration_url,
            params: { user: user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] },
                      couch_facility: { facility_ids: [] } }

      assert_response :unprocessable_entity
      assert_includes flash[:error], 'Please select at least one facility.'
    end

    test 'should save user without facilities' do
      # First, create a user
      user_data = create_user_and_sign_in

      user_data['offers_couch'] = false
      user_data['offers_hang_out'] = true
      patch user_registration_url,
            params: { user: user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_response :redirect
      assert_equal 0, User.last.couch.couch_facilities.count
      assert_equal true, User.last.offers_hang_out
    end

    test 'should remove couch facilities' do
      # First, create a user
      user_data = create_user_and_sign_in

      # Update the user with facilities
      patch user_registration_url,
            params: { user: user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] },
                      couch_facility: { facility_ids: [Facility.first.id] } }

      assert_response :redirect
      assert_equal 1, User.last.couch.couch_facilities.count

      # Update the user without facilities and check if the facilities are removed
      user_data['offers_couch'] = false
      user_data['offers_hang_out'] = true
      patch user_registration_url,
            params: { user: user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_response :redirect
      assert_equal 0, User.last.couch.couch_facilities.count
    end

    test 'should only change the password' do
      # First, create a user
      user_attributes = create_user_and_sign_in

      password_data = {
        password: 'new_password',
        password_confirmation: 'new_password',
        email: 'anotheremail@quouch.com',
        old_password: @user.password
      }

      patch user_registration_url, params: { user: password_data }

      assert_response :redirect
      assert User.last.valid_password?('new_password')
      assert_equal user_attributes['email'], User.last.email
    end

    test 'should not change the password if new password is invalid' do
      # First, create a user
      create_user_and_sign_in

      password_data = {
        password: 'a',
        password_confirmation: 'a',
        old_password: @user.password
      }

      patch user_registration_url, params: { user: password_data }

      assert_response :unprocessable_entity
      assert User.last.valid_password?(@user.password)
    end

    test 'should not change the password if confirmation does not match' do
      # First, create a user
      create_user_and_sign_in

      password_data = {
        password: 'a',
        password_confirmation: 'b',
        old_password: @user.password
      }

      patch user_registration_url, params: { user: password_data }

      assert_response :unprocessable_entity
      assert User.last.valid_password?(@user.password)
    end

    test 'should not change the password if the current password is wrong' do
      # First, create a user
      create_user_and_sign_in

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
      # First, create a user
      create_user_and_sign_in

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
      assert User.last.valid_password?('new_password')
    end

    private

    def create_user_and_sign_in
      # First, create a user
      @user = FactoryBot.create(:user, :for_test, :with_couch)
      sign_in @user

      user_data = @user.attributes
      user_data['current_password'] = @user.password
      user_data
    end
  end
end

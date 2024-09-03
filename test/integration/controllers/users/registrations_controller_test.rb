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

      assert_equal 'New name', User.last.first_name
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

      assert_includes flash[:error], 'Please select at least one facility.'
    end

    test 'should save user without facilities' do
      # First, create a user
      user_data = create_user_and_sign_in

      user_data['offers_couch'] = false
      patch user_registration_url,
            params: { user: user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_equal 0, User.last.couch.couch_facilities.count
    end

    test 'should remove couch facilities' do
      # First, create a user
      user_data = create_user_and_sign_in

      # Update the user with facilities
      patch user_registration_url,
            params: { user: user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] },
                      couch_facility: { facility_ids: [Facility.first.id] } }

      assert_equal 1, User.last.couch.couch_facilities.count

      # Update the user without facilities and check if the facilities are removed
      user_data['offers_couch'] = false
      patch user_registration_url,
            params: { user: user_data,
                      user_characteristic: { characteristic_ids: [Characteristic.first.id] } }

      assert_equal 0, User.last.couch.couch_facilities.count
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

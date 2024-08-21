require 'test_helper'

module Users
  class RegistrationsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      fake_user_data = FactoryBot.build(:test_user)
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
        address: random_address[:street],
        zipcode: random_address[:zipcode],
        city: random_address[:city],
        country: random_address[:country_code],
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

    test 'should create a user with an invite code' do
      inviting_user = FactoryBot.create(:test_user)

      # expect success
      post user_registration_url,
           params: { user: @user_object,
                     user_characteristic: { characteristic_ids: [Characteristic.first.id] },
                     invite_code: inviting_user[:invite_code] }

      assert_redirected_to root_url

      assert_includes flash[:notice], 'A message with a confirmation link has been sent to your email address.'

      assert_not_nil User.last.invited_by_id
    end
  end
end

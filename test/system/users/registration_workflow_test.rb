# frozen_string_literal: true

require 'system_test_helper'

class RegistrationWorkflowTest < ApplicationSystemTestCase
  def setup
    random_address = ADDRESSES.first

    @fake_user_data = FactoryBot.build(:user, :for_test)
    @fake_user_data[:address] = AddressHelper.format_address(random_address)
    @fake_user_data[:zipcode] = random_address[:zipcode]
    @fake_user_data[:city] = random_address[:city]
    @fake_user_data[:country] = random_address[:country_code]

    @avatar = URI.parse(Faker::Avatar.image).open

    @inviting_user = FactoryBot.create(:user, :for_test, :with_couch)
  end

  test 'should open validate invite code page' do
    visit root_path

    click_on 'Sign up'

    assert_selector 'h1', text: 'Validate invite code'.upcase
  end

  test 'should throw error if code does not exist' do
    visit '/invite-code'

    assert_selector 'h1', text: 'Validate invite code'.upcase

    # Fill in the form
    fill_in 'invite[invite_code]', with: 'abcdef'
    click_on 'Validate'

    assert_selector 'div.flash', text: 'Invite code not found'
  end

  test 'should throw error if code is invalid' do
    visit '/invite-code'

    assert_selector 'h1', text: 'Validate invite code'.upcase

    # Fill in the form
    fill_in 'invite[invite_code]', with: 'invalid'
    click_on 'Validate'

    assert_selector 'div.flash', text: 'This does not look like a valid code'
  end

  test 'should redirect to sign up page if code is valid' do
    visit '/invite-code'

    assert_selector 'h1', text: 'Validate invite code'.upcase

    # Fill in the form
    fill_in 'invite[invite_code]', with: @inviting_user.invite_code
    click_on 'Validate'

    assert_selector 'h1', text: 'Set account details'.upcase
  end

  test 'should navigate to sign up page with code in url' do
    visit user_registration_path

    assert_selector 'h1', text: 'Set account details'.upcase
  end

  test 'should present errors in form' do
    visit user_registration_path

    fill_in 'user[first_name]', with: @fake_user_data[:first_name]
    click_on 'Create Account'

    assert_no_current_path root_path
    assert_selector '.form_error', text: 'Last name required'
  end

  test 'should create a user with an invite code' do
    visit user_registration_path

    assert_selector 'h1', text: 'Set account details'.upcase

    # Fill in the form
    fill_in_form_data

    click_on 'Create Account'

    # Should be in the main page again and see success a message
    assert_selector 'div.flash', text: 'A message with a confirmation link'
    assert_current_path root_path

    # Check that the user was created and has invited_by_id value set
    user = User.last
    assert_equal user[:email], @fake_user_data[:email]
    assert_equal user[:invited_by_id], @inviting_user[:id]
  end

  private

  def user_registration_path
    "/users/sign_up?invite_code=#{@inviting_user[:invite_code]}"
  end

  def fill_in_form_data
    attach_file(@avatar.path) do
      find('div.input.file.user_photo').click
    end
    fill_in 'user[first_name]', with: @fake_user_data[:first_name]
    fill_in 'user[last_name]', with: @fake_user_data[:last_name]
    fill_in 'user[email]', with: @fake_user_data[:email]
    month = @fake_user_data[:date_of_birth].strftime('%B')
    year = @fake_user_data[:date_of_birth].year
    day = @fake_user_data[:date_of_birth].day
    select year, from: 'user_date_of_birth_1i'
    select month, from: 'user_date_of_birth_2i'
    select day, from: 'user_date_of_birth_3i'
    fill_in 'user[summary]', with: @fake_user_data[:summary]

    # Fill in the address
    formatted_address = AddressHelper.format_address(ADDRESSES.first)
    fill_in 'Search', with: formatted_address
    first_suggestion = first('.mapboxgl-ctrl-geocoder--suggestion')
    first_suggestion.click
    # make sure that all address fields are filled
    fill_in 'user[zipcode]', with: @fake_user_data[:zipcode]
    fill_in 'user[city]', with: @fake_user_data[:city]

    # select characteristics
    char_id = Characteristic.first.id
    find("#user_characteristic_characteristic_ids_#{char_id}").check
    check 'user[offers_hang_out]'

    password = Faker::Internet.password
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password
  end
end

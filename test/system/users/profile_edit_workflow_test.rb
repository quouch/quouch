# frozen_string_literal: true

require 'system_test_helper'

class ProfileEditWorkflowTest < ApplicationSystemTestCase
  def setup
    @inviting_user = FactoryBot.create(:user, :for_test, :with_couch)

    @editing_user = FactoryBot.create(:user, :for_test, :with_couch)

    sign_in_as(@editing_user)
  end

  test 'should open edit page' do
    visit edit_user_registration_path

    assert_selector 'h1', text: 'Edit profile'.upcase
  end

  test 'should navigate to edit page' do
    visit root_path

    find('#dropdown_menu').click
    click_on 'Edit Profile'

    assert_selector 'h1', text: 'Edit profile'.upcase
  end

  test 'should have user information prefilled' do
    visit edit_user_registration_path

    assert_field 'user[first_name]', with: @editing_user[:first_name]
    assert_field 'user[last_name]', with: @editing_user[:last_name]
    assert_field 'user[email]', with: @editing_user[:email]
    assert_field 'user[summary]', with: @editing_user[:summary]
    assert_field 'user[zipcode]', with: @editing_user[:zipcode]
    assert_field 'user[city]', with: @editing_user[:city]
    assert_field 'user[country_code]', with: @editing_user[:country_code]
  end

  test 'should not save without password input' do
    visit edit_user_registration_path

    fill_in 'user[first_name]', with: 'New name'
    click_on 'Update'

    assert_selector '.password-error', text: 'can\'t be blank'
  end

  test 'should update and redirect to home page' do
    visit edit_user_registration_path

    fill_in 'user[first_name]', with: 'New name'
    submit_form

    assert_selector 'div.flash', text: 'Your account has been updated successfully.'
    assert_current_path root_path
  end

  test 'should present errors in form' do
    visit edit_user_registration_path

    fill_in 'user[last_name]', with: ''
    submit_form

    assert_no_current_path root_path
    assert_selector '.form_error', text: 'Last name required'
  end

  private

  def submit_form
    fill_in 'user[current_password]', with: @editing_user.password
    click_on 'Update'
  end
end
# frozen_string_literal: true

require 'test_helper'

class DeviseMailerTemplatesTest < ActionMailer::TestCase
  fixtures :users

  test 'password reset' do
    user = FactoryBot.create(:user, :for_test)
    mail = Devise::Mailer.reset_password_instructions(user, 'faketoken')
    assert_equal [user.email], mail.to
    assert_equal 'Reset password instructions', mail.subject
    assert_match 'faketoken', mail.body.encoded

    # assert that the capitalized user name appears in the email body
    assert_match "Dear #{user.first_name.capitalize}", mail.body.encoded
  end

  test 'password reset without user name' do
    user = FactoryBot.create(:user, :for_test)
    user.first_name = nil

    mail = Devise::Mailer.reset_password_instructions(user, 'faketoken')
    assert_equal [user.email], mail.to
    assert_equal 'Reset password instructions', mail.subject
    assert_match 'faketoken', mail.body.encoded

    # assert that the email appears in the email body
    assert_match "Dear #{user.email}", mail.body.encoded
  end
end

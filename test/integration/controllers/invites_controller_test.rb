require 'test_helper'

class InvitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
  end

  test 'should get invite_code_form' do
    get invite_code_path
    assert_response :success
  end

  test 'should validate invite code' do
    get validate_invite_code_url, params: { invite: { invite_code: @user.invite_code } }
    assert_redirected_to new_user_registration_path(invite_code: @user.invite_code)
  end

  test 'should validate invite code with spaces' do
    get validate_invite_code_url, params: { invite: { invite_code: "#{@user.invite_code} " } }
    assert_redirected_to new_user_registration_path(invite_code: @user.invite_code)
  end

  test 'should not validate invalid invite code' do
    get validate_invite_code_url, params: { invite: { invite_code: 'invalid_code' } }
    assert_response :unprocessable_entity

    assert flash[:alert].present?
    assert_includes flash[:alert], 'Invite code not valid'
  end
end

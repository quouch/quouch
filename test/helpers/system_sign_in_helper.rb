# Used for System tests, not integration or unit tests
module SystemSignInHelper
  def sign_in_as(user)
    visit new_user_session_path
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: user.password
    # There are two log in buttons, one if a link and the other one is an input.
    # We want to click on the input one.
    find('input[type="submit"]').click
  end
end

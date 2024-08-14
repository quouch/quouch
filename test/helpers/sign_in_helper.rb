module SignInHelper
  def sign_in_as(user)
    post user_session_path, params: { user: { email: user.email, password: user.password } }
    follow_redirect!
  end

  def api_prepare_headers
    user = FactoryBot.create(:test_user_couch)
    # Ensure that the city is unique, so we don't have to worry about it in the tests
    user.city = 'Test city'
    user.country = 'Test country'
    user.save

    @headers = api_prepare_headers_for(user)

    @user = User.find_by(id: user.id)
    [@user, @headers]
  end

  def api_prepare_headers_for(user)
    # first log in
    credentials = { user: { email: user.email, password: user.password } }
    post '/api/v1/login', params: credentials

    @headers = { 'Authorization' => response.headers['Authorization'] }
  end
end

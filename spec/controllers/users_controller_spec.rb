RSpec.describe CouchesController, type: :controller do
  context 'GET #show' do
    xit 'returns a success response' do
      user = User.new(first_name: 'First',
                      last_name: 'Last',
                      email: 'first.last@example.com',
                      password: 'password',
                      confirmed_at: Time.now)
      user.save(validate: false)
      couch = Couch.create!(user: user)
      get :show, params: { id: couch.to_param }
      expect(response).to be_success
    end
  end
end

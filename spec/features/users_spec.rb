RSpec.feature 'User Features', type: :feature do
  # input an invalid invite code to the "invite" form
  context 'create new user' do
    before(:each) do
      visit '/invite-code'
      within('form.invite') do
        fill_in 'Enter invite code here', with: 'john'
      end
    end

    scenario 'should fail' do
      click_button 'Validate Invite Code'
      expect(page).to have_content 'Invite code not valid'
    end
  end
end

namespace :password do
	desc 'Reset password after user import'

	task reset: :environment do
		User.all.each do |user|
			user.reset_password('abc123', 'abc123')
			user.send_reset_password_instructions
		end
	end
end

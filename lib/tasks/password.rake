namespace :password do
	desc 'Reset password after user import'

	task reset: :environment do
		User.all.each do |user|
			unless user.confirmed?
				user.confirm
				user.reset_password('abc123', 'abc123')
				user.send_reset_password_instructions
				p "password instruction sent to #{user.id}"
			end
		end
	end
end

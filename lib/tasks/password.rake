namespace :password do
  desc "Reset password after user import"

  task reset: :environment do
    User.all.each do |user|
      next if user.confirmed?

      user.confirm
      user.reset_password("abc123", "abc123")
      sleep 1
      p "password instruction sent to #{user.id}" if user.send_reset_password_instructions
    end
  end
end

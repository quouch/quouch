namespace :users do
  desc "Update passion field for users containing email addresses"
  task update_passions: :environment do
    email_regex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/

    User.find_each do |user|
      if user.passion.nil? || user.passion.match?(email_regex)
        user.update(passion: "")
        puts "Updated user ##{user.id}'s passion field"
      end
    end

    puts "Update complete"
  end
end

require 'csv'

namespace :emails do
  desc 'Export user email addresses to CSV'
  task export: :environment do
    csv_data = CSV.generate do |csv|
      User.all.each do |user|
        csv << [user.email]
      end
    end

    File.write('user_emails.csv', csv_data)
    puts 'User emails exported to user_emails.csv'
  end
end

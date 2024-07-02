namespace :dev do
  desc 'Fill database with sample data'
  task populate: :environment do
    10.times do
      FactoryBot.create(:random_user)
    end
  end
end

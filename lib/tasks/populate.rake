# frozen_string_literal: true

namespace :dev do
  desc "Fill database with sample data"
  task populate: :environment do
    abort("This task cannot be run in the production environment.") if Rails.env.production?

    puts "Delete all users except the one with the BASE_USER_EMAIL"
    User.where.not(email: ENV.fetch("BASE_USER_EMAIL", nil)).destroy_all
    Couch.where.not(user: User.find_by(email: ENV.fetch("BASE_USER_EMAIL", nil))).destroy_all

    puts "Create 30 randomized users"
    30.times do
      new_user = FactoryBot.create(:random_user)
      puts "Created user with address: #{new_user.address}, #{new_user.zipcode} #{new_user.city}, #{new_user.country}"
    end
  end
end

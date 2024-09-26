# frozen_string_literal: true

require 'factory_bot_rails'

# enable logger
log_level = ENV.fetch('LOG_LEVEL', 'INFO')
Rails.application.configure do
  config.logger = Logger.new($stdout)
  config.log_level = log_level.to_sym
end

namespace :dev do
  desc 'Fill database with sample data'
  task populate: :environment do
    abort('This task cannot be run in the production environment.') if Rails.env.production?
    abort('This task requires the BASE_USER_EMAIL environment variable to be set.') unless ENV.key?('BASE_USER_EMAIL')

    Rails.logger.warn 'Delete all users except the one with the BASE_USER_EMAIL'
    User.where.not(email: ENV.fetch('BASE_USER_EMAIL', nil)).destroy_all
    Couch.where.not(user: User.find_by(email: ENV.fetch('BASE_USER_EMAIL', nil))).destroy_all

    Rails.logger.info 'Create 30 randomized users'
    30.times do
      new_user = FactoryBot.create(:user, :with_couch)
      Rails.logger.info "Created user with address: #{new_user.address}"
    end
  end

  task test_booking: :environment do
    user = User.all.sample
    user.offers_couch = true

    couch = user.couch
    couch.capacity = rand(1..5)
    couch.save!

    Rails.logger.debug("Couch capacity: #{couch.capacity}")

    facilities = Facility.all.sample(3)
    facilities.each do |facility|
      Rails.logger.info("Adding facility: #{facility.name}")
      CouchFacility.create!(couch:, facility:)
    end
  end

  task test_plans: :environment do
    abort('This task cannot be run in the production environment.') if Rails.env.production?
    Rails.logger.warn 'Delete all existing plans and create a couple of fake plans'
    Subscription.destroy_all
    Plan.destroy_all

    Plan.create!(name: 'Monthly Fake Plan', price_cents: 1000, interval: 'month')
    Plan.create!(name: 'Yearly Fake Plan', price_cents: 800, interval: 'year')

    Rails.logger.info 'Create a fake subscription for the main user'
    user = User.find_by(email: ENV.fetch('BASE_USER_EMAIL', nil))

    plan = Plan.first
    Subscription.create!(user:, plan:, stripe_id: 'fake_subscription_id')
    Rails.logger.info "Created subscription for user #{user.email} with plan"
  end
end

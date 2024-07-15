source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Authentication
gem "devise"
gem "devise-jwt"
gem "jsonapi-serializer"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 7.0.4"

gem "dotenv-rails"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

gem "airrecord"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Gem to send emails straight from contact form
gem "mail_form"

# Gem for notifications
gem "noticed", "~> 1.6"

# Let's you write Ruby Cron Tasks in ruby code
gem "whenever", require: false

# Search
gem "pg_search"

# Geocoder for address search when sign up
gem "geocoder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Debugging
gem "pry-byebug"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'kredis'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem 'bcrypt', '~> 3.1.7'

# Integration of money gem - used for handling prices in DB
gem "money-rails", "~>1.12"

# CDN
gem "cloudinary"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sassc-rails"

# Give a list of ISO countries
gem "countries"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem 'image_processing', '~> 1.2'

# Performance optimization analysis
#
group :development, :rubocop, :test do
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "standard", require: false
  gem "standard-rails", require: false
end

gem "autoprefixer-rails"
gem "font-awesome-sass", "~> 6.1"
gem "simple_form", github: "heartcombo/simple_form"

# Pagination
gem "pagy"

# Give team access to DB
gem "rails_admin", "3.0"

# Stripe for payments
gem "stripe"
gem "stripe_event"

# Amplitude API for tracking
gem "amplitude-api"

# Importmap for JS modules
gem "importmap-rails", "~> 1.2.3"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "bullet"
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails"
  # Fake test data
  gem "factory_bot_rails"
  gem "faker", git: "https://github.com/faker-ruby/faker.git", branch: "main"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end

group :test do
  gem "simplecov", require: false
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  # Use static analysis tools
  gem "brakeman", require: false
  gem "bundler-audit", require: false
end

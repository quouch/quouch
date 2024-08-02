ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'faker'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new unless ENV['RM_INFO']

Faker::Config.random = Random.new

# TODO: Mock away Geocoder in tests
module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # Clean up the database
    Minitest.after_run do
      ActiveRecord::Base.subclasses.each do |subclass|
        subclass.delete_all if subclass.table_name
      end
    end
  end
end

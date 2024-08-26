ENV['RAILS_ENV'] ||= 'test'

if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-markdown'

  if ENV['CI']
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                     SimpleCov::Formatter::MarkdownFormatter,
                                                                     SimpleCov::Formatter::HTMLFormatter
                                                                   ])
  end

  SimpleCov.start 'rails' do
    add_filter '/vendor/' # Don't include vendored stuff
    add_filter '/test/'
    add_filter '/config/'
    add_filter '/lib/tasks/'
    add_filter '/log/'
  end

  # We're not at the stage where this makes sense, but it's a good goal to have
  # SimpleCov.minimum_coverage 60

end

require_relative '../config/environment'
require 'rails/test_help'
require 'faker'
require 'minitest/autorun'
require 'minitest/reporters'
require_relative 'helpers/sign_in_helper'
require_relative 'helpers/user_helper'
require_relative 'helpers/db_helper'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new unless ENV['RM_INFO']

Faker::Config.random = Random.new

# TODO: Mock away Geocoder in tests

# Clean up the database
Minitest.after_run do
  ActiveRecord::Base.subclasses.each do |subclass|
    subclass.delete_all if subclass.table_name
  end
end

module ActionView
  class TestCase
    fixtures :characteristics
  end
end

# Modify ActiveSupport::TestCase to include the UserHelper module, fixtures and clean up the database after each test
module ActiveSupport
  class TestCase
    include UserHelper
    include DBHelper

    # Run tests in parallel with specified workers
    # parallelize(workers: :number_of_processors)
    # Parallelizing tests don't work with coverage, so we don't include it by default
    # To add it to a test class, include ParallelizeTests

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :characteristics

    # Add more helper methods to be used by all tests here...

    # default setup for all unit tests
    def params
      @params ||= {}
    end

    def session
      @session ||= {}
    end

    def current_user
      @user ||= {}
    end
  end
end

module ActionDispatch
  class IntegrationTest
    include SignInHelper
    include UserHelper
    include DBHelper

    fixtures :all
  end
end

# Include this in tests that should be parallelized to run faster:
# include ParallelizeTests
module ParallelizeTests
  def self.included(base)
    base.parallelize(workers: :number_of_processors)
  end
end

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

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new unless ENV['RM_INFO']

Faker::Config.random = Random.new

# Clean up the database
Minitest.after_run do
  ActiveRecord::Base.subclasses.each do |subclass|
    subclass.delete_all if subclass.table_name
  end
end

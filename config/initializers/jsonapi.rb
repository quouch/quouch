# config/initializers/jsonapi.rb
require 'jsonapi'

JSONAPI::Rails.install!

require_relative '../../app/helpers/jsonapi'

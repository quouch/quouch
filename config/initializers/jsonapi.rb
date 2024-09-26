# config/initializers/jsonapi.rb
require 'jsonapi'

JSONAPI::Rails.install!

require_relative '../../app/helpers/jsonapi'

# This is needed to fix an issue with test coverage,
# since the name JSONAPI does not adhere to ruby naming conventions
module Jsonapi
  extend JSONAPI
end

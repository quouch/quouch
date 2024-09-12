# config/initializers/jsonapi.rb
require 'jsonapi'

JSONAPI::Rails.install!

# add more error handlers to JSONAPI::Errors module
module JSONAPI
  module Errors
    def self.included(base)
      base.class_eval do
        rescue_from(
          StandardError,
          with: :render_jsonapi_internal_server_error
        ) unless defined?(::Rails) && ::Rails.env.test?

        rescue_from(
          ActiveRecord::RecordNotFound,
          with: :render_jsonapi_not_found
        ) if defined?(ActiveRecord::RecordNotFound)

        rescue_from(
          ActionController::ParameterMissing,
          with: :render_jsonapi_unprocessable_entity
        ) if defined?(ActionController::ParameterMissing)

        rescue_from(
          JwtError,
          with: :render_jsonapi_unauthorized
        ) if defined?(JwtError)
      end
    end

    private

    def render_jsonapi_unauthorized(exception)
      puts exception.message
      message = exception.message || 'Couldn\'t find an active session.'
      render_error(status: :unauthorized, title: Rack::Utils::HTTP_STATUS_CODES[401], detail: message)
    end

    # Methods for properly rendering errors in the API
    # @param :status [Integer] the status code of the error
    # @param :title [String] the title of the error
    # @param :detail [String] the error message (optional)
    # @param :source [Hash] the source of the error (optional)
    # @param :data [Hash] the data of the error (optional)
    def format_error(status:, title:, detail: nil, source: nil, data: nil)
      # transform status symbol into an integer before adding to the error object
      status_code = Rack::Utils.status_code(status)

      error = { status: status_code.to_s, title: }

      error[:detail] = detail if detail
      error[:source] = source || { pointer: '' }
      error[:data] = data if data

      [error, status]
    end

    def render_error(status:, title:, detail: nil, source: nil, data: nil)
      error, status = format_error(status:, title:, detail:, source:, data:)
      puts error

      render jsonapi_errors: [error], status:
    end
  end
end

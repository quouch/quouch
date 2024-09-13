# add more error handlers to JSONAPI::Errors module
module JSONAPI
  class ForbiddenError < StandardError
  end

  module Errors
    def self.included(base)
      base.class_eval do
        unless defined?(::Rails) && ::Rails.env.test?
          rescue_from(
            StandardError,
            with: :render_jsonapi_internal_server_error
          )
        end

        if defined?(ActiveRecord::RecordNotFound)
          rescue_from(
            ActiveRecord::RecordNotFound,
            with: :render_jsonapi_not_found
          )
        end

        if defined?(ActionController::ParameterMissing)
          rescue_from(
            ActionController::ParameterMissing,
            with: :render_jsonapi_unprocessable_entity
          )
        end

        if defined?(JwtError)
          rescue_from(
            JwtError,
            with: :render_jsonapi_invalid_token
          )
        end

        rescue_from(
          ForbiddenError,
          with: :render_jsonapi_forbidden
        )
      end
    end

    private

    def render_jsonapi_invalid_token(exception)
      message = exception.message || 'Couldn\'t find an active session.'
      render_error(status: :unauthorized, title: 'Invalid token', detail: message)
    end

    def render_jsonapi_forbidden(exception)
      message = exception.message || 'You are not allowed to perform this action.'
      render_error(status: :forbidden, title: Rack::Utils::HTTP_STATUS_CODES[403], detail: message)
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

      render jsonapi_errors: [error], status:
    end
  end
end

# frozen_string_literal: true

module ApiHelper
  # Methods for properly rendering errors in the API
  # @param :status [Integer] the status code of the error
  # @param :title [String] the title of the error
  # @param :detail [String] the error message (optional)
  # @param :source [Hash] the source of the error (optional)
  # @param :data [Hash] the data of the error (optional)
  def format_error(status:, title:, detail: nil, source: nil, data: nil)
    # transform status symbol into an integer before adding to the error object
    status_code = Rack::Utils.status_code(status)
    error = { status: status_code, title: }

    error[:detail] = detail if detail
    error[:source] = source if source
    error[:data] = data if data

    format_errors([error], status)
  end

  def format_errors(errors, status = :unprocessable_entity)
    [{ errors: }, status]
  end

  def render_error(status:, title:, detail: nil, source: nil, data: nil)
    errors, status = format_error(status:, title:, detail:, source:, data:)

    render json: errors, status:
  end
end

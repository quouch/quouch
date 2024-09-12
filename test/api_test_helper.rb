require 'test_helper'

class ApiEndpointTest < ActionDispatch::IntegrationTest
  def before_setup
    @doc = OpenapiContracts::Doc.parse(Rails.root.join('api'), 'index.yaml')

    super
  end

  protected

  def assert_match_openapi_doc(options = {})
    result = match_openapi_doc(options)

    # Display the response body in the console if there's an error
    # todo: Pretty print JSON
    Rails.logger.info(response.body) # unless result

    # Display in the assertion message the errors
    assert result, "OpenAPI contract mismatch: #{@errors}"
  end

  private

  def match_openapi_doc(options = {})
    # Remove the /api/v1 part of the path unless the path has already been specified
    options = options.merge({ path: request.path.gsub(%r{^/api/v1}, '') }) unless options[:path]

    match = OpenapiContracts.match(
      @doc,
      response,
      options.merge({ status: @status }.compact)
    )
    return true if match.valid?

    @errors = match.errors
    false
  end
end

require 'test_helper'

class ApiEndpointTest < ActionDispatch::IntegrationTest
  def before_setup
    @doc = OpenapiContracts::Doc.parse(Rails.root.join('api'), 'index.yaml')

    super
  end

  protected

  def assert_match_openapi_doc(options = {})
    result = match_openapi_doc(@doc, options)

    # Display the response body in the console if there's an error
    Rails.logger.debug(JSON.pretty_generate(response.parsed_body)) # unless result

    # Display in the assertion message the errors
    assert result, "OpenAPI contract mismatch: #{@errors}"
  end

  private

  def match_openapi_doc(doc, options = {})
    # Remote the /api/v1 part of the path
    options = options.merge({ path: request.path.gsub(%r{^/api/v1}, '') })
    match = OpenapiContracts::Match.new(
      doc,
      response,
      options.merge({ status: @status }.compact)
    )
    return true if match.valid?

    @errors = match.errors
    false
  end
end

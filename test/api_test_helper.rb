require 'test_helper'
$doc = OpenapiContracts::Doc.parse(Rails.root.join('api'), 'index.yaml')

if ENV['COVERAGE']
  OpenapiContracts.collect_coverage = true

  Minitest.after_run do
    $doc.coverage.report.generate(Rails.root.join('coverage/openapi.json'))
  end
end

class ApiEndpointTest < ActionDispatch::IntegrationTest
  def before_setup
    @doc = $doc
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

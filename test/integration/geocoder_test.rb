require 'test_helper'

class GeocoderTest < ActionDispatch::IntegrationTest
  setup do
    # we need to sleep for a second to avoid hitting the rate limit
    # we might want to mark this test as optional in the future, somehow
    sleep(1)
  end

  test 'should strip the address until it finds a match' do
    formatted_address = 'Rue Dr. Robert Delmas, HT6110, Port-au-Prince, Haiti'
    result = GeocoderService.search(formatted_address)

    assert_not_nil result.latitude
    assert_not_nil result.longitude
    assert_not_equal 1, result.latitude
  end

  test 'should query the geocoder API' do
    address = '123 Main St, New York, United States'
    result = GeocoderService.execute(address).first
    assert_not_nil result
    assert_equal 'New York', result.state
  end

  test 'should parse html and return the title' do
    response = '<html><head><title>Test Title</title></head><body><h1>Access blocked</h1></body></html>'
    title = GeocoderService.extract_html_title(response)
    assert_equal 'Test Title', title
  end
end

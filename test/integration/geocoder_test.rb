require 'unit_helper'

class GeocoderTest < ActionDispatch::IntegrationTest
  test 'should strip the address until it finds a match' do
    formatted_address = 'Rue Dr. Robert Delmas, HT6110, Port-au-Prince, Haiti'
    result = GeocoderService.search(formatted_address)

    assert_not_nil result.latitude
    assert_not_nil result.longitude
    assert_equal 'Haiti', result.country
    assert_not_equal 1, result.latitude
  end

  test 'should parse html and return the title' do
    response = '<html><head><title>Test Title</title></head><body><h1>Access blocked</h1></body></html>'
    title = GeocoderService.extract_html_title(response)
    assert_equal 'Test Title', title
  end
end

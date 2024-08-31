require 'test_helper'

class GeocoderTest < ActionDispatch::IntegrationTest
  setup do
    Geocoder.configure(lookup: :mapbox)

    Geocoder::Lookup::Test.reset
  end

  test 'should use geocoder service' do
    Geocoder.configure(lookup: :mapbox)

    formatted_address = 'Rue Dr. Robert Delmas, HT6110, Port-au-Prince, Haiti'
    result = GeocoderService.search(formatted_address)

    assert_not_nil result.latitude
    assert_not_nil result.longitude
    assert_equal 'Haiti', result.country
    assert_not_equal 1, result.latitude
  end

  test 'should strip the address until it finds a match' do
    formatted_address = 'Rue Dr. Robert Delmas, HT6110, Port-au-Prince, Haiti'
    # Stub the geocoder to return an empty array for the first query
    Geocoder::Lookup::Test.add_stub(formatted_address, [])

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

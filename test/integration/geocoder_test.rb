require 'test_helper'

class GeocoderTest < ActionDispatch::IntegrationTest
  test 'should strip the address until it finds a match' do
    formatted_address = 'Rue Dr. Robert Delmas, HT6110, Port-au-Prince, Haiti'
    result = GeocoderService.search(formatted_address)

    assert_not_nil result.latitude
    assert_not_nil result.longitude
    assert_not_equal 1, result.latitude
  end

  test 'should raise an error if the address truly does not exist' do
    address = '123 Fake St, DoNotFindThis, DoNotFindThis'
    assert_raise(StandardError) { GeocoderService.search(address) }
  end

  test 'should query the geocoder API' do
    address = '123 Main St, New York, United States'
    result = GeocoderService.execute(address).first
    assert_not_nil result
    assert_equal 'New York', result.state
  end
end

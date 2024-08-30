# Used for integration tests
module DBHelper
  def db_cleanup
    Couch.delete_all
    UserCharacteristic.delete_all
    User.delete_all
  end
end

# Mock away Geocoder in tests by default.
# If a test shouldn't mock Geocoder, set $mock_geocoder = false in the setup block of the test.
module GeocoderMocker
  def before_setup
    super
    $mock_geocoder = self.class.name != 'GeocoderTest'

    return unless $mock_geocoder

    Geocoder.configure(lookup: :test, ip_lookup: :test)
    Geocoder::Lookup::Test.set_default_stub(
      [
        {
          'coordinates' => [1, 1],
          'address' => 'New York, NY, USA',
          'state' => 'New York',
          'state_code' => 'NY',
          'country' => 'United States',
          'country_code' => 'US'
        }
      ]
    )
  end

  def after_teardown
    super
    Geocoder::Lookup::Test.reset
  end
end

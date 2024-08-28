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
    # rubocop:disable Style/ClassEqualityComparison
    $mock_geocoder = self.class.name != 'GeocoderTest'
    # rubocop:enable Style/ClassEqualityComparison
    $geocoder_result = { latitude: 1, longitude: 1 }

    return unless $mock_geocoder

    def GeocoderService.execute(*_args)
      return [] if $geocoder_result == :not_found

      [OpenStruct.new($geocoder_result)]
    end
  end
end

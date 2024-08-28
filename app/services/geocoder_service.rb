class GeocoderError < StandardError; end
class GeocoderService
  def self.search(address)
    loop do
      begin
        found_match = self.execute(address).first
      rescue Geocoder::Error => e
        Rails.logger.error("Error executing query: #{e.message}")
        Sentry.capture_exception(e, extra: { address: address, response: e.response })
        found_match = nil
      end

      return found_match if found_match

      stripped_address = address.split(',').drop(1).join(',').strip
      raise GeocoderError.new 'No match found' if stripped_address.blank?

      Rails.logger.warn("No match found for #{address}, retrying with #{stripped_address}")

      address = stripped_address
    end
  end

  def self.execute(address)
    query = Geocoder::Query.new(address, {})

    Geocoder.search(query.text, query.options)
  end
end

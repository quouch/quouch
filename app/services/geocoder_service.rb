class GeocoderError < StandardError; end

class GeocoderService
  def self.search(address)
    loop do
      begin
        found_match = execute(address).first
      rescue Geocoder::Error => e
        error_title = extract_html_title(e.response)
        Rails.logger.error("Error executing query: #{error_title}")
        Sentry.capture_exception(e, extra: { address:, error_title:, response: e.response })
        found_match = nil
      end

      return found_match if found_match

      stripped_address = address.split(',').drop(1).join(',').strip
      raise GeocoderError, 'No match found' if stripped_address.blank?

      Rails.logger.warn("No match found for #{address}, retrying with #{stripped_address}")

      address = stripped_address
    end
  end

  def self.execute(address)
    query = Geocoder::Query.new(address, {})

    Geocoder.search(query.text, query.options)
  end

  def self.extract_html_title(response)
    Nokogiri::HTML(response).css('title').text
  end
end

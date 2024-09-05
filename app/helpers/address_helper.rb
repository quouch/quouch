# frozen_string_literal: true

module AddressHelper
  def beautify_country(country)
    Rails.logger.info("Beautifying country: #{country}")
    iso_country = ISO3166::Country[country]
    raise StandardError, 'iso_country is empty' if iso_country.nil?

    translated_country = iso_country.translations[I18n.locale.to_s]
    Rails.logger.info("Country beautification: #{country} -> #{iso_country} -> #{translated_country}")
    raise StandardError, 'translated_country is empty' if translated_country.nil? || translated_country == country

    translated_country
  rescue => e
    Rails.logger.error("Error beautifying country: #{e.message}")
    crumb = Sentry::Breadcrumb.new(
      message: 'Error beautifying country',
      level: 'error',
      category: 'user',
      data: { country:, iso_result: iso_country, translated_country:, error: e }
    )
    Sentry.add_breadcrumb(crumb)
    raise ArgumentError, "Country not found: #{country}"
  end

  def find_country_code(country)
    Rails.logger.info("Finding country code: #{country}")
    iso_country = ISO3166::Country.find_country_by_iso_short_name(country)
    if iso_country.nil?
      return handle_non_iso_conform_country(country)
    end
    Rails.logger.info("Country code found: #{iso_country}")
    iso_country.alpha2
  rescue => e
    Rails.logger.error("Error finding country code: #{e.message}")
  end

  class Formatter
    def self.format_address(address)
      "#{address[:street]}, #{address[:zipcode]}, #{address[:city]}, #{address[:country]}"
    end
  end

  private

  # Handle countries whose english translation is not the same as the iso short name
  def handle_non_iso_conform_country(country)
    case country.downcase
    when 'united states'
      return 'US'
    when 'united kingdom'
      return 'GB'
    when 'bolivia'
      return 'BO'
    when 'congo, the democratic republic of the'
      return 'CD'
    when 'iran'
      return 'IR'
    when 'north korea'
      return 'KP'
    when 'south korea'
      return 'KR'
    when 'moldova'
      return 'MD'
    when 'taiwan'
      return 'TW'
    when 'tanzania'
      return 'TZ'
    when 'holy see (vatican city state)'
      return 'VA'
    when 'venezuela'
      return 'VE'
    when 'vietnam'
      return 'VN'
    else
      raise ArgumentError, "Country not found: #{country}"
    end
  end
end

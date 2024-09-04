# frozen_string_literal: true

module AddressHelper
  def beautify_country(country)
    Rails.logger.info("Beautifying country: #{country}")
    iso_country = ISO3166::Country[country]
    translated_country = iso_country.translations[I18n.locale.to_s]
    Rails.logger.info("Country beautification: #{country} -> #{iso_country} -> #{translated_country}")
    raise StandardError if translated_country.nil? || translated_country == country

    translated_country
  rescue StandardError => e
    Rails.logger.error("Error updating user profile: #{e.message}")
    crumb = Sentry::Breadcrumb.new(
      message: 'Error beautifying country',
      level: 'error',
      category: 'user',
      data: { country:, iso_result: iso_country, translated_country:, error: e }
    )
    Sentry.add_breadcrumb(crumb)
    raise ArgumentError, "Country not found: #{country}"
  end

  class Formatter
    def self.format_address(address)
      "#{address[:street]}, #{address[:zipcode]}, #{address[:city]}, #{address[:country]}"
    end
  end
end

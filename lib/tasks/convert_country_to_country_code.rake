require_relative '../../app/helpers/address_helper'

class CountryCodeFixer
  include AddressHelper

  def run
    User.all.each do |user|
      current_country_code = user.country_code
      update_with_country = nil
      update_with_country = user.country if current_country_code == user.country || current_country_code.blank?

      if update_with_country
        user.update_attribute(:country_code, find_country_code(update_with_country))
        user.validate_country_code
      end
    end
  end
end

namespace :users do
  desc 'Convert country to country code'
  task convert_country_to_country_code: :environment do
    CountryCodeFixer.new.run
  end
end

# frozen_string_literal: true

module RegistrationConcern
  protected

  def couch_params
    params.require(:couch).permit(:capacity)
  end

  def couch_facility_params
    params.require(:couch_facility).permit(facility_ids: [])
  end

  def user_characteristic_params
    params.require(:user_characteristic).permit(characteristic_ids: [])
  end

  def create_couch
    @couch = params[:couch].present? ? Couch.new(couch_params) : Couch.new(capacity: 0)

    @couch.user = @user
    @couch.save

    disable_offers_if_travelling
    create_couch_facilities if params[:couch_facility].present?
  end

  def update_couch
    @couch.update(couch_params)
  end

  def disable_offers_if_travelling
    return unless params[:user][:travelling] == '1'

    @user.update(offers_couch: false, offers_co_work: false, offers_hang_out: false)
  end

  def create_couch_facilities
    @couch.couch_facilities.destroy_all
    if params[:couch_facility].nil? || params[:couch_facility][:facility_ids].nil?
      Rails.logger.info('No facilities selected for couch')
      return
    end

    couch_facility_params[:facility_ids].reject(&:empty?).each do |id|
      CouchFacility.create(couch_id: @couch.id, facility_id: id)
    end
  end

  def create_user_characteristics
    @user.user_characteristics.destroy_all
    chars_hash = params[:user_characteristic][:characteristic_ids].reject(&:empty?)
                                                                  .map { |id| { characteristic_id: id } }
    @user.user_characteristics.build(chars_hash)
  end

  def update_user_characteristics
    @user.user_characteristics.destroy_all
    chars_hash = params[:user_characteristic][:characteristic_ids].reject(&:empty?).map do |id|
      { characteristic_id: id }
    end
    @user.user_characteristics.build(chars_hash)
    @user.user_characteristics.each(&:save)
  end

  def find_invited_by
    return unless params[:invite_code].present?

    @invited_by = User.find_by(invite_code: params[:invite_code].strip.downcase)
    if @invited_by.nil?
      Sentry.capture_message("No user found with invite code: #{params[:invite_code]}", level: 'info')
      Rails.logger.warn("No user found with invite code: #{params[:invite_code]}")
      return nil
    end

    Rails.logger.info("Found user with invite code: #{params[:invite_code]} -> #{@invited_by.email}")
    @invited_by.id
  end

  def update_profile
    begin
      parsed_country = beautify_country
      @user.update(country: parsed_country)
      Rails.logger.info("Updated user profile with country: #{parsed_country}")
    rescue ArgumentError => e
      Sentry.capture_exception(e)
    end

    create_couch if @user.couch.nil?
  end

  def beautify_country
    country = params[:user][:country].strip
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
      data: { params:, country:, iso_result: iso_country, translated_country:, error: e }
    )
    Sentry.add_breadcrumb(crumb)
    raise ArgumentError, "Country not found: #{country}"
  end
end

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

    disable_offers_if_travelling(resource)
    create_couch_facilities if params[:couch_facility].present?
  end

  def update_couch
    @couch.update(couch_params)
  end

  def disable_offers_if_travelling(resource)
    return unless resource[:travelling] == '1'

    resource.update(offers_couch: false, offers_co_work: false, offers_hang_out: false)
  end

  def create_couch_facilities
    if params[:couch_facility].nil? || params[:couch_facility].empty?
      Rails.logger.info('couch_facility not present, skipping changes...')
    else
      @couch.couch_facilities.destroy_all

      facilities_to_create = couch_facility_params[:facility_ids].reject(&:empty?)

      facilities_to_create.each do |id|
        @couch.couch_facilities.create(facility_id: id)
      end
    end
  end

  def create_user_characteristics
    # Do not update if the user characteristics aren't set!
    if params[:user_characteristic].nil?
      Rails.logger.info('No characteristics selected for user')
      return
    end

    @user.user_characteristics.destroy_all
    chars_hash = params[:user_characteristic][:characteristic_ids].reject(&:empty?)
                                                                  .map { |id| { characteristic_id: id } }
    @user.user_characteristics.build(chars_hash)
  end

  def update_user_characteristics
    # Do not update if the user characteristics aren't set!
    if params[:user_characteristic].nil?
      Rails.logger.info('No characteristics selected for user')
      return
    end

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

  def ensure_couch_exists
    create_couch if @user.couch.nil?
  end
end

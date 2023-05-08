class Users::RegistrationsController < Devise::RegistrationsController
  # * used the create from Devise: https://github.com/heartcombo/devise/blob/main/app/controllers/devise/registrations_controller.rb
  def create
    build_resource(sign_up_params)
    create_user_characteristics
    resource.save

    if resource.persisted?
      update_profile
      create_couch
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def update
    @user.update(country: params[:user][:country], city: params[:user][:city])

    @couch = @user.couch
    create_couch_facilities

    create_user_characteristics
    super
    status_couch
  end

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
    if params[:couch].present?
      @couch = Couch.new(couch_params)
    else
      @couch = Couch.new(capacity: 0)
    end

    @couch.user = @user
    @couch.save

    status_couch

    create_couch_facilities if params[:couch_facility].present?
  end

  def update_couch
    @couch.update(couch_params)
  end

  def status_couch
    if params[:user][:travelling] == '1'
      @user.update(offers_couch: false, offers_co_work: false, offers_hang_out: false)
      set_couch_inactive
    elsif params[:user][:offers_couch] == '0'
     set_couch_inactive
    elsif params[:user][:offers_couch] == '1'
      set_couch_active
    end
  end

  def set_couch_inactive
    @couch.update(active: false)
  end

  def set_couch_active
    @couch.update(active: true)
  end

  def create_couch_facilities
    @couch.couch_facilities.destroy_all
    couch_facility_params[:facility_ids].reject(&:empty?).each do |id|
      CouchFacility.create(couch_id: @couch.id, facility_id: id)
    end
  end

  def create_user_characteristics
    @user.user_characteristics.destroy_all
    chars_hash = params[:user_characteristic][:characteristic_ids].reject(&:empty?).map { |id| { characteristic_id: id } }
    @user.user_characteristics.build(chars_hash)
    @user.user_characteristics.each(&:save)
  end

  def update_profile
    create_couch if @user.couch.nil?
    @invited_by = User.find_by(invite_code: params[:invite_code].downcase)
    @user.update(invited_by_id: @invited_by.id)
  end
end

class Users::InvitationsController < Devise::InvitationsController
  def update
    @minimum_password_length = User.password_length.min

    @user = accept_resource

    create_couch if @user.couch.nil?
    create_user_characteristics
    super
  end

  protected

  def couch_params
    params.require(:couch).permit(:capacity)
  end

  def couch_facility_params
    params.require(:couch_facility).permit(facility_ids: [])
  end

  def create_couch
    @couch = Couch.new(couch_params)
    @couch.user = @user
    @couch.save
    if offers_couch == "0"
			set_couch_inactive
		elsif offers_couch == "1"
			set_couch_active
		end
    create_couch_facilities
  end

  def offers_couch
    params[:user][:offers_couch]
  end

  def set_couch_inactive
    @couch.update(active: false)
  end

  def set_couch_active
    @couch.update(active: true)
  end

  def create_couch_facilities
    @couchfacilities = @couch.couch_facilities
    @couchfacilities.destroy_all
    delete_empty_string(couch_facility_params[:facility_ids])
    couch_facility_params[:facility_ids].each do |id|
      couchfacility = CouchFacility.create(couch_id: @couch, facility_id: id)
      @couchfacilities << couchfacility
    end
  end

  def create_user_characteristics
    @usercharacteristics = @user.user_characteristics
    @usercharacteristics.destroy_all
    delete_empty_string(params[:user_characteristic][:characteristic_ids])
    params[:user_characteristic][:characteristic_ids].each do |id|
      usercharacteristic = UserCharacteristic.create(user_id: @user.id, characteristic_id: id)
      @usercharacteristics << usercharacteristic
    end
    @usercharacteristics
  end

  def delete_empty_string(array)
    array.delete("")
  end
end

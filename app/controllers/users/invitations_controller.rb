class Users::InvitationsController < Devise::InvitationsController
	def update
    @minimum_password_length = User.password_length.min

		super
    @user.update(country: set_country, city: set_city)
    if @user.couch.nil?
      create_couch
    end

    @usercharacteristics = @user.user_characteristics
    if @usercharacteristics.empty?
      create_user_characteristics
    else
      update_user_characteristics
    end
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
  end

  def update_couch
    @couch.update(couch_params)
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

  def create_user_characteristics
    @usercharacteristics = []
    delete_empty_string(params[:user_characteristic][:characteristic_ids])
    params[:user_characteristic][:characteristic_ids].each do |id|
      usercharacteristic = UserCharacteristic.create(user_id: @user.id, characteristic_id: id)
      @usercharacteristics << usercharacteristic
    end
  end

  def update_user_characteristics
    create_new_characteristics
    delete_old_characteristics
  end

  def create_new_characteristics
    new_characteristics = params[:user_characteristic][:characteristic_ids].reject { |characteristic| @usercharacteristics.include?("#{characteristic}") }
    delete_empty_string(new_characteristics)
    new_characteristics.each do |id|
      usercharacteristic = UserCharacteristic.create(user_id: @user, characteristic_id: id)
      @usercharacteristics << usercharacteristic
    end
  end

  def delete_old_characteristics
    old_characteristics = @usercharacteristics.reject { |characteristic| params[:user_characteristic][:characteristic_ids].include?("#{characteristic[:characteristic_id]}") }
    delete_empty_string(old_characteristics)
    old_characteristics.each { |characteristic| @usercharacteristics.destroy(characteristic.id) }
  end

  def delete_empty_string(array)
    array.delete("")
  end

  def create_city(city, country)
    existing_city = City.find_by(name: city.capitalize)
    if existing_city.nil?
      City.create(name: city, country: country)
    else
      existing_city
    end
  end

  def set_country
    @country = params[:user][:country_id]
    existing_country = Country.find_by(name: @country.capitalize)
    if existing_country.nil?
      new_country = Country.create(name: @country)
    else
      existing_country
    end
  end

  def set_city
    @city = params[:user][:city_id]
    @country = set_country
    create_city(@city, @country)
  end
end

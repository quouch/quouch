# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def update
    super
    @couch = @user.couch
    @couchfacilities = @couch.couch_facilities if @couch
    if @couch.nil? && @couchfacilities.nil?
      create_couch
      create_couch_facilities
    elsif @couch.present? && @couchfacilities.nil?
      update_couch
      create_couch_facilities
    else
      update_couch
      update_couch_facilities
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
  end

  def update_couch
    @couch.update(couch_params)
  end

  def create_couch_facilities
    @couchfacilities = []
    delete_empty_facility(couch_facility_params[:facility_ids])
    couch_facility_params[:facility_ids].each do |id|
      couchfacility = CouchFacility.create(couch_id: @couch, facility_id: id)
      @couchfacilities << couchfacility
    end
  end

  def update_couch_facilities
    create_new_facilities
    delete_old_facilities
  end

  def create_new_facilities
    new_facilities = couch_facility_params[:facility_ids].reject { |facility| @couchfacilities.include?("#{facility}") }
    delete_empty_facility(new_facilities)
    new_facilities.each do |id|
      couchfacility = CouchFacility.create(couch_id: @couch, facility_id: id)
      @couchfacilities << couchfacility
    end
  end

  def delete_old_facilities
    old_facilities = @couchfacilities.reject { |facility| couch_facility_params[:facility_ids].include?("#{facility[:facility_id]}") }
    delete_empty_facility(old_facilities)
    old_facilities.each { |facility| @couchfacilities.destroy(facility.id) }
  end

  def delete_empty_facility(array)
    array.delete("")
  end
end

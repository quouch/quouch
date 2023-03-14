class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @couches = []
		if params[:query].present? && params[:characteristics].present?
			find_couches_by_characteristics
			couches = @couches.flatten
			find_couches
		elsif params[:characteristics].present? && params[:query].empty?
			find_couches_by_characteristics
		elsif params[:query].present?
			find_couches_by_location
		else
			@couches = Couch.where.not(user: current_user)
		end
  end

  private

	def find_couches
		if @city = City.find_by("name ILIKE ?", "%#{params[:query]}%")
			@couches = couches.select { |couch| couch.city == @city }
		elsif @country = Country.find_by("name ILIKE ?", "%#{params[:query]}%")
			@couches = couches.select { |couch| couch.country == @country }
		end
	end

	def find_couches_by_location
		if @city = City.find_by("name ILIKE ?", "%#{params[:query]}%")
			@users = User.where(city: @city)
		elsif @country = Country.find_by("name ILIKE ?", "%#{params[:query]}%")
			@users = User.where(country: @country)
		end

		couches = []
		@users.each do |user|
			if !user.couch.nil?
				couches << user.couch
			end
		end
		
		couches << couches.select { |couch| couch.active == true && couch.user != current_user }
		@couches = couches.flatten.uniq
	end

	def find_couches_by_characteristics
		couches = []
		params[:characteristics].each do |characteristic|
			user_characteristics = UserCharacteristic.where(characteristic_id: characteristic.strip)
			
			user_characteristics.each do |user_characteristic|
				user = User.find(user_characteristic.user.id)
				if !user.couch.nil?
					couches << user.couch
				end
			end
		end
		couches << couches.select { |couch| couch.active == true && couch.user != current_user }
		@couches = couches.flatten.uniq
	end
end

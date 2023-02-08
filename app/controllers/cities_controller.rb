class CitiesController < ApplicationController
	def show
		@city = City.find(params[:id])
		@city_id = params[:id]
		@hosts = User.where(city_id: @city_id)
	end
	
	def couches
		@city = City.find(params[:id])
		@users = User.where(city: @city)
		@couches = []

		@users.each do |user| 
			@couch = user.couch
			@couches << @couch
		end
	end
end

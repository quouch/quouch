class CitiesController < ApplicationController
  def index
    @cities = City.all
  end

	def show
		@city = City.find(params[:id])
		@city_id = params[:id]
		@hosts = User.where(city_id: @city_id)
	end
end

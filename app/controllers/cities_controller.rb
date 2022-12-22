class CitiesController < ApplicationController
  def index
    if params[:query].present?
			@cities = City.where("name ILIKE ?", "%#{params[:query]}%")
		else
			@cities = City.all
		end
  end

	def show
		@city = City.find(params[:id])
		@city_id = params[:id]
		@hosts = User.where(city_id: @city_id)
	end
end

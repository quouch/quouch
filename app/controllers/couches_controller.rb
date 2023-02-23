class CouchesController < ApplicationController
	def index
		if params[:query].present?
			if @city = City.find_by("name ILIKE ?", "%#{params[:query]}%")
				@users = User.where(city: @city)
			elsif @country = Country.find_by("name ILIKE ?", "%#{params[:query]}%")
				@users = User.where(country: @country)
			end

			@couches = []
			@users.each do |user| 
				@couch = user.couch
				@couches << @couch
			end
			
			@active_couches = @couches.uniq.select { |couch| couch.active == true && couch.user != current_user }
		else
			@couches = Couch.all
		end
	end

	def show
    @couch = Couch.find(params[:id])
		@host = User.find(@couch.user.id)
		@couch.user = @host
		@reviews = Review.where(couch_id: params[:id])
		@review_average = @reviews.average(:rating).to_f
		@chat = Chat.find_by(user_sender_id: current_user.id, user_receiver_id: @host.id)
  end
end

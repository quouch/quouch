class CouchesController < ApplicationController
	def index
		if params[:query].present?
			@city = City.find_by("name ILIKE ?", "%#{params[:query]}%")
			@users = User.where(city: @city)
			@couches = []

			@users.each do |user| 
				@couch = user.couch
				@couches << @couch
			end
		else
			@couches = Couch.all
		end
	end

	def show
    @couch = Couch.find(params[:id])
		@host = User.find(@couch.user.id)
		@couch.user = @host
		@reviews = Review.where(couch_id: params[:id])
		@chat = Chat.find_by(user_sender_id: current_user.id, user_receiver_id: @host.id)
  end
end

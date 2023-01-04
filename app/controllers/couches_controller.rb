class CouchesController < ApplicationController
	def index
		@couches = Couch.all
	end

	def show
    @couch = Couch.find(params[:id])
		@user = User.find(@couch.user.id)
		@couch.user = @user
		@reviews = Review.where(couch_id: params[:id])
		@chat = Chat.find_by(user_sender_id: current_user.id, user_receiver_id: @user.id)
  end
end

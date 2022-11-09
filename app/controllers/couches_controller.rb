class CouchesController < ApplicationController
	def index
		@couches = Couch.all
		@users = User.all
	end

	def show
    @couch = Couch.find(params[:id])
		@user = User.find(@couch.user.id)
		@couch.user = @user
  end
end

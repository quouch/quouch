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

	private
	
	def couches_params
		params.require(:couch).permit(:capacity)
	end
end

module Api
  module V1
    class UsersController < ApiController
      include Pagy::Backend

      def index
        @pagy, @users = pagy(User.all, items: params[:items])
        render json: {
          pagination: pagy_metadata(@pagy),
          items: UserSerializer.new(@users).serializable_hash[:data]
        }
      end

      def show
        user = User.find(params[:id])
        render json: UserSerializer.new(user).serializable_hash[:data]
      end
    end
  end
end

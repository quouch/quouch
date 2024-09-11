module Api
  module V1
    class UsersController < ApiController
      include Pagy::Backend

      def index
        @pagy, @users = pagy(User.all.includes([:photo_attachment, { photo_attachment: :blob }]), items: params[:items])

        options = pagy_metadata(@pagy)
        render json: UserSerializer.new(@users, options).serializable_hash
      end

      def show
        user = User.find(params[:id])
        render json: UserSerializer.new(user).serializable_hash
      end
    end
  end
end

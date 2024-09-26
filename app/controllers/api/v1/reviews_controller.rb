# frozen_string_literal: true

module Api
  module V1
    class ReviewsController < ApiController
      before_action :find_user

      def index
        render jsonapi: @user.couch.reviews
      end

      private

      def find_user
        user_id = params.require(:user_id)
        @user = User.find(user_id)
      end
    end
  end
end

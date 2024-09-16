module Api
  module V1
    class UsersController < ApiController
      def index
        jsonapi_paginate(User.all) do |paginated|
          render jsonapi: paginated
        end
      end

      def show
        user = User.find(params[:id])
        render jsonapi: user
      end
    end
  end
end

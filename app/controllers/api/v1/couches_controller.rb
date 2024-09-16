require_relative '../../concerns/couches_concern'

module Api
  module V1
    # CouchesController: This controller is responsible for handling the couches.
    class CouchesController < ApiController
      include CouchesConcern

      def index
        jsonapi_paginate(filter_couches) do |paginated|
          render jsonapi: paginated
        end
      end

      def show
        # fetch the couch and join the user information
        render jsonapi: Couch.includes(:user).find(params[:id])
      end
    end
  end
end

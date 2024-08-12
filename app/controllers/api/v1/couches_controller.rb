require_relative '../../concerns/couches_concern'

module Api
  module V1
    # CouchesController: This controller is responsible for handling the couches.
    class CouchesController < ApiController
      include Pagy::Backend
      include CouchesConcern

      def index
        # reuse code from CochesConcern
        super

        render json: {
          pagination: pagy_metadata(@pagy),
          items: @couches.map do |couch|
            CouchSerializer.new(couch).serializable_hash[:data][:attributes]
          end
        }
      end

      def show
        couch = Couch.find(params[:id])
        render json: CouchSerializer.new(couch).serializable_hash[:data][:attributes]
      end
    end
  end
end

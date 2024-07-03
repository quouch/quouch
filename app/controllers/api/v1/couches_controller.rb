require_relative '../../concerns/couches_concern'

module Api
  module V1
    # CouchesController: This controller is responsible for handling the couches.
    class CouchesController < ApiController
      include Pagy::Backend
      include CouchesConcern
    end
  end
end

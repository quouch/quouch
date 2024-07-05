# frozen_string_literal: true

module Api
  module V1
    # ApiController: This controller is responsible for handling the API requests.
    class ApiController < ActionController::Base
      before_action :check_basic_auth
      skip_before_action :verify_authenticity_token

      respond_to? :json

      private

      def check_basic_auth
        unless request.authorization.present?
          head :unauthorized
          return
        end

        authenticate_with_http_basic do |email, password|
          user = User.find_by(email: email.downcase)

          if user&.authenticate(password)
            @current_user = user
          else
            head :unauthorized
          end
        end
      end

      def pagy_metadata(pagy)
        {
          page: pagy.page,
          items: pagy.items,
          total: pagy.count,
          from: pagy.from,
          to: pagy.to,
          prev: pagy.prev,
          next: pagy.next,
          last: pagy.last
        }
      end

      attr_reader :current_user
    end
  end
end

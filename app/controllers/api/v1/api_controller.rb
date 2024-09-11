# frozen_string_literal: true

module Api
  module V1
    # ApiController: This controller is responsible for handling the API requests.
    class ApiController < ActionController::API
      include ApiHelper
      include ActionController::HttpAuthentication::Basic::ControllerMethods
      include ActionController::HttpAuthentication::Token::ControllerMethods
      include JwtTokenHelper

      before_action :check_basic_auth

      respond_to? :json

      rescue_from ActiveRecord::RecordNotFound do |e|
        render_error(status: :not_found, title: 'Record not found.', detail: e.message)
      end

      rescue_from JwtError do |e|
        render_error(status: :unauthorized, title: 'Invalid token.', detail: e.message)
      end

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

        authenticate_with_http_token do |token, _options|
          @current_user = find_user_by_jwt_token(token)
        end

        head :unauthorized unless @current_user
      end

      def pagy_metadata(pagy)
        puts pagy.to_json
        {
          meta: {
            total: pagy.count,
            page: pagy.page,
            items: pagy.items,
            from: pagy.from,
            to: pagy.to
          },
          links: {
            first: get_page_link(1),
            prev: get_page_link(pagy.prev),
            next: get_page_link(pagy.next),
            last: get_page_link(pagy.last),
            self: get_page_link(pagy.page)
          }
        }
      end

      def get_page_link(page)
        url_for(page:, only_path: false)
      end

      attr_reader :current_user
    end
  end
end

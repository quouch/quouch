# frozen_string_literal: true

module Api
  module V1
    class RequestsController < ApiController
      before_action :set_booking, except: %i[index create]
      before_action :check_ownership, only: %i[show update]

      def index
        render jsonapi: Booking.where(couch: current_user.couch)
      end

      def show
        render jsonapi: @booking
      end

      def update
        booking_attributes = update_params
        @booking.update!(booking_attributes)
        render jsonapi: @booking
      end

      private

      def update_params
        status = params.require(:status)
        { status: }
      end

      def set_booking
        @booking = Booking.find(params[:id])
      end

      def check_ownership
        booking = Booking.find(params[:id])
        return if current_user.couch.id.to_s == booking.couch.id.to_s

        raise JSONAPI::ForbiddenError,
              'You are not allowed to manage requests for this user.'
      end
    end
  end
end

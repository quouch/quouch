# frozen_string_literal: true

module Api
  module V1
    class BookingsController < ApiController
      include BookingsConcern

      def index
        render jsonapi: Booking.where(user: current_user)
      end

      def show
        render jsonapi: Booking.find(params[:id])
      end

      def create
        booking = prepare_booking_for_save
        booking.status = :pending

        booking.save!

        after_create_process(booking)
        render jsonapi: booking, status: :created
      end

      def update
        params.require(:data).require(:id)

        booking_attributes = booking_params
        booking = Booking.find(params[:id])
        booking.update!(booking_attributes)
        render jsonapi: booking
      end

      private

      def booking_params
        params.require(:data).require(%i[type attributes relationships])

        booking_params = jsonapi_deserialize(params,
                                             only: %i[request status start_date end_date number_travellers message
                                                      flexible user couch])
        user_id = booking_params['user_id']
        unless current_user.id.to_s == user_id.to_s
          raise JSONAPI::ForbiddenError,
                'You are not allowed to manage bookings for this user.'
        end

        booking_params
      end
    end
  end
end

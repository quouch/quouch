# frozen_string_literal: true

module Api
  module V1
    class BookingsController < ApiController
      include BookingsConcern

      before_action :set_booking, except: %i[index create]
      before_action :check_ownership, only: %i[show update]

      def index
        render jsonapi: Booking.where(user: current_user)
      end

      def show
        render jsonapi: @booking
      end

      def create
        booking = prepare_booking_for_save
        booking.status = :pending

        booking.save!

        post_create(booking)
        render jsonapi: booking, status: :created
      end

      def update
        params.require(:data).require(:id)

        booking_attributes = update_params
        if @booking.update!(booking_attributes)
          post_update(@booking)
          render jsonapi: @booking
        else
          render jsonapi_errors: @booking.errors, status: :unprocessable_entity
        end
      end

      private

      def check_ownership
        params.require(:id)

        booking = Booking.find(params[:id])
        return if current_user.id.to_s == booking.user.id.to_s

        raise JSONAPI::ForbiddenError,
              'You are not allowed to manage bookings for this user.'
      end

      def update_params
        booking_params = create_params

        user_id = booking_params['user_id']
        unless current_user.id.to_s == user_id.to_s
          raise JSONAPI::ForbiddenError,
                'You are not allowed to manage bookings for this user.'
        end

        # prevent invalid changes to status
        status = booking_params['status']
        if status.present? && !@booking.status_change_allowed?(status, current_user)
          raise JSONAPI::ForbiddenError, 'Invalid status change.'
        end

        booking_params
      end

      def create_params
        params.require(:data).require(%i[type attributes relationships])

        jsonapi_deserialize(params,
                            only: %i[request status start_date end_date number_travellers message flexible user couch])
      end
    end
  end
end

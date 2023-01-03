class BookingMailer < ApplicationMailer
	before_action :set_booking

	default from: 'dev.quouch@gmail.com'

	def new_request_email
	end

	def request_updated_email
	end

	def booking_confirmed_email
	end

	def booking_declined_email
	end

	def booking_cancelled_email
	end

	def booking_updated_email
	end

	def booking_completed_email
		# call add review email
	end

	private

	def set_booking
		@booking = params[:id]
	end
end

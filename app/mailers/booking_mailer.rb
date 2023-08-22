class BookingMailer < ApplicationMailer
	before_action :set_booking_details
	before_action :set_couch, only: %i[booking_completed_host_email booking_completed_guest_email]

	default from: 'nora@quouch-app.com'

	def new_request_email
		@url = request_booking_url(@booking)
		mail(to: @host.email, subject: "#{@guest.first_name.capitalize} sent you a request")
	end

	def request_updated_email
		@url = request_booking_url(@booking)
		mail(to: @host.email, subject: "Request from #{@guest.first_name.capitalize} has been updated")
	end

	def request_cancelled_email
		@url = request_booking_url(@booking)
		mail(to: @host.email, subject: "#{@guest.first_name.capitalize} cancelled the request")
	end

	def request_confirmed_email
		@url = booking_url(@booking)
		mail(to: @guest.email, subject: "Your request with #{@host.first_name.capitalize} has been confirmed")
	end

	def request_declined_email
		@url = root_url
		mail(to: @guest.email, subject: "Your request with #{@host.first_name.capitalize} has been declined")
	end

	def booking_cancelled_by_guest_email
		@url = request_booking_url(@booking)
		mail(to: @host.email, subject: "Your guest #{@guest.first_name.capitalize} cancelled the booking")
	end

	def booking_cancelled_by_host_email
		@url = root_url
		mail(to: @guest.email, subject: "Your host #{@host.first_name.capitalize} cancelled the booking")
	end

	def booking_updated_email
		@url = request_booking_url(@booking)
		mail(to: @host.email, subject: "Your guest #{@guest.first_name.capitalize} updated the booking")
	end

	def booking_completed_guest_email
		@url = new_couch_booking_review_url(@booking.couch, @booking)
		mail(to: @guest.email, subject: "You stayed with #{@host.first_name.capitalize} - review now")
	end

	def booking_completed_host_email
		@url = new_couch_booking_review_url(@booking.user.couch, @booking)
		mail(to: @host.email, subject: "#{@guest.first_name.capitalize} stayed with you - review now")
	end

		private

	def set_booking_details
		@booking = params[:booking]
		@host = @booking.couch.user
		@guest = @booking.user
	end

	def set_couch
		@booking = params[:booking]
		@couch = @booking.couch
		@url = new_couch_booking_review_url(@couch, @booking)
	end
end

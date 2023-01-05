class BookingMailer < ApplicationMailer
	before_action :set_booking_details
	before_action :set_couch, only: %i[booking_completed_host_email booking_completed_guest_email]

	default from: 'dev.quouch@gmail.com'

	def new_request_email
		mail(to: @host.email, subject: "#{@user.first_name.capitalize} would like to stay at your place")
	end

	def request_updated_email
		mail(to: @host.email, subject: "Request from #{@user.first_name.capitalize} has been updated")
	end

	def request_cancelled_email
		mail(to: @host.email, subject: "#{@user.first_name.capitalize} cancelled the request")
	end

	def request_confirmed_email
		mail(to: @user.email, subject: "Your request at #{@host.first_name.capitalize}'s place has been confirmed")
	end

	def booking_declined_email
		mail(to: @user.email, subject: "Your request at #{@host.first_name.capitalize}'s place has been declined")
	end

	def booking_cancelled_by_guest_email
		mail(to: @host.email, subject: "Your guest #{@user.first_name.capitalize} cancelled the booking")
	end

	def booking_cancelled_by_host_email
		mail(to: @user.email, subject: "Your host #{@host.first_name.capitalize} cancelled the booking")
	end

	def booking_updated_email
		mail(to: @host.email, subject: "Your guest #{@user.first_name.capitalize} updated the booking")
	end

	def booking_completed_guest_email
		mail(to: @user.email, subject: "You stayed at #{@host.first_name.capitalize}'s place - review now")
	end

	def booking_completed_host_email
		p @host
		mail(to: @host.email, subject: "#{@user.first_name.capitalize} stayed at your place - review now")
	end

	private

	def set_booking_details
		@booking = params[:booking]
		@user = @booking.user
		@host = @booking.couch.user
	end

	def set_couch
		@booking = params[:booking]
		@couch = @booking.couch
		@url = new_couch_booking_review_url(@couch, @booking)
	end
end

class ReviewMailer < ApplicationMailer
	before_action :set_booking_details
	default from: 'nora@quouch-app.com'

	def new_review_host_email
		mail(to: @host.email, subject: "Your guest #{@guest.first_name.capitalize} left you a review")
	end

	def new_review_guest_email
		mail(to: @guest.email, subject: "Your host #{@host.first_name.capitalize} left you a review")
	end

	def review_reminder_email
	end

	private

	def set_booking_details
		@booking = params[:booking]
		@guest = @booking.user
		@couch = @booking.couch
		@host = @couch.user
		@host_url = couch_url(@couch)
		@guest_url = couch_url(@booking.user.couch)
	end
end

class ReviewMailer < ApplicationMailer
	before_action :set_booking_details
	default from: 'dev.quouch@gmail.com'

	def new_review_host_email
		mail(to: @host.email, subject: "Your guest #{@user.first_name.capitalize} left you a review")
	end

	def new_review_guest_email
		mail(to: @user.email, subject: "Your host #{@host.first_name.capitalize} left you a review")
	end

	def review_reminder_email

	end

	private

	def set_booking_details
		@booking = params[:booking]
		@user = @booking.user
		@couch = @booking.couch
		@host = @couch.user
		@url = couch_url(@couch)
	end
end

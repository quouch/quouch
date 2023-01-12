# Preview all emails at http://localhost:3000/rails/mailers/booking
class BookingPreview < ActionMailer::Preview
	def request_updated_email
		BookingMailer.with(booking: @booking).request_updated_email
	end
end

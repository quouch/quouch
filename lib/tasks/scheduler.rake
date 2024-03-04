namespace :booking do
	desc 'Complete and delete past Bookings'

	task complete: :environment do
		Booking.complete
		# Booking.delete
	end
end

class StatisticsMailer < ApplicationMailer
	def send_stats
		# Collect your stats here
		@total_users = User.count
		@users_per_city = users_per_city
		@bookings_today = bookings_today

		mail(to: 'hello.quouch@gmail.com', subject: 'User Stats Report')
	end

		private

	def users_per_city
		result = User.all.group_by(&:city)
		result.transform_values(&:count)
	end

	def bookings_today
		result = Booking.where(booking_date: Date.today).group_by(&:request)
		result.transform_values(&:count)
	end
end

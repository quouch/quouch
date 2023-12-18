class StatisticsMailer < ApplicationMailer
	def send_stats
		# Collect your stats here
		@total_users = User.count
		@users_per_city = users_per_city
		@users_per_country = users_per_country
		@amount_reviews = Review.count
		@review_average = Review.average(:rating)
		@reviews_today = Review.where(created_at: Date.today).count
		@bookings_today = bookings_today
		@completed_bookings = Booking.where(status: 4).count
		@confirmed_bookings = Booking.where(status: 1).count
		@cancelled_bookings = Booking.where(status: -1).count

		mail(to: 'nora@quouch-app.com', subject: 'User Stats Report')
	end

		private

	def users_per_city
		users_by_city = User.all.group_by(&:city)
		users_count_by_city = users_by_city.transform_values(&:count)
		users_count_by_city.sort_by { |_, count| count }.reverse
	end

	def users_per_country
		users_by_country = User.all.group_by(&:country)
		users_count_by_country = users_by_country.transform_values(&:count)
		users_count_by_country.sort_by { |_, count| count }.reverse
	end

	def bookings_today
		result = Booking.where(booking_date: Date.today).group_by(&:request) if Booking.where(booking_date: Date.today)
		result.transform_values(&:count)
	end
end

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
    @total_subscriptions = Subscription.where.not(stripe_id: nil).count
	  @response_rate = message_response_rate
	  @booking_response_rate = request_response_rate
		@booking_confirmation_rate = request_confirmation_rate
		

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

	def message_response_rate
		# Calculate the response rate
		response_rate_query = <<-SQL
			SELECT ROUND((COUNT(DISTINCT m1.chat_id)::numeric / (SELECT COUNT(*) FROM chats)) * 100, 2) AS response_rate
			FROM messages AS m1
			JOIN messages AS m2 ON m1.chat_id = m2.chat_id AND m1.user_id != m2.user_id;
		SQL

		result = ActiveRecord::Base.connection.execute(response_rate_query)
		response_rate = result[0]['response_rate'].to_f
		format('%.0f%%', response_rate)
	end

	def request_response_rate
		non_pending_bookings_count = Booking.where.not(status: 0).count
		total_bookings_count = Booking.count
		percentage = (non_pending_bookings_count.to_f / total_bookings_count * 100).round(2)
		format('%.0f%%', percentage)
	end

	def request_confirmation_rate
		confirmed_bookings_count = Booking.where(status: 1).count
		total_bookings_count = Booking.count
		percentage = (confirmed_bookings_count.to_f / total_bookings_count * 100).round(2)
		format('%.0f%%', percentage)
	end
end

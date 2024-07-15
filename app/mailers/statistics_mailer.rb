class StatisticsMailer < ApplicationMailer
  def send_stats
    # Collect your stats here
    @total_users = User.count
    @users_per_city = users_per_city
    @users_per_country = users_per_country
    @amount_reviews = Review.count
    @review_average = Review.average(:rating)
    @reviews_today = Review.where(created_at: Date.today).count
    @bookings = Booking.count
    @bookings_today = bookings_today
    @completed_bookings = Booking.where(status: 4).count
    @confirmed_bookings = Booking.where(status: 1).count
    @cancelled_bookings = Booking.where(status: -1).count
    @total_subscriptions = Subscription.where.not(stripe_id: nil).count
    @response_rate = message_response_rate
    @booking_response_rate = request_response_rate
    @booking_confirmation_rate = request_confirmation_rate
    @booking_confirmation_rate_ten_requests = ten_requests_confirmation_rate
    @subscription_success_rate = subscription_success_rate
    @total_users_with_subscription_no_request ||= 0
    @requests_subscribers ||= 0
    @total_booking_requests_pending ||= 0
    @total_booking_requests_cancelled ||= 0
    @total_booking_requests_confirmed ||= 0
    @total_booking_requests_declined ||= 0
    @total_booking_requests_completed ||= 0

    mail(to: "hello@quouch-app.com", subject: "User Stats Report")
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
    response_rate_query = <<-SQL
			SELECT ROUND((COUNT(DISTINCT m1.chat_id)::numeric / (SELECT COUNT(*) FROM chats)) * 100, 2) AS response_rate
			FROM messages AS m1
			JOIN messages AS m2 ON m1.chat_id = m2.chat_id AND m1.user_id != m2.user_id;
    SQL

    result = ActiveRecord::Base.connection.execute(response_rate_query)
    response_rate = result[0]["response_rate"].to_f
    format("%.0f%%", response_rate)
  end

  def request_response_rate
    non_pending_bookings_count = Booking.where.not(status: 0).count
    total_bookings_count = Booking.count
    percentage = (non_pending_bookings_count.to_f / total_bookings_count * 100).round(2)
    format("%.0f%%", percentage)
  end

  def request_confirmation_rate
    confirmed_bookings_count = Booking.where(status: 1).count
    completed_bookings_count = Booking.where(status: 4).count
    successful_bookings_count = confirmed_bookings_count + completed_bookings_count
    total_bookings_count = Booking.count
    percentage = (successful_bookings_count.to_f / total_bookings_count * 100).round(2)
    format("%.0f%%", percentage)
  end

  def ten_requests_confirmation_rate
    response_rate = request_confirmation_rate.to_f / 100
    probability_not_confirmed = 1 - response_rate
    probability_at_least_one_confirmed = 1 - (probability_not_confirmed**10)
    percentage = probability_at_least_one_confirmed.to_f
    format("%.0f%%", percentage * 100)
  end

  def subscription_success_rate
    valid_subscriptions = Subscription.where.not(stripe_id: nil)
    users_with_valid_subscription = User.joins(:subscription).merge(valid_subscriptions)

    total_success_rate = 0
    @total_users_with_subscription_no_request = 0
    @total_users_with_subscription_request = 0
    @requests_subscribers = 0
    @total_booking_requests_pending = 0
    @total_booking_requests_confirmed = 0
    @total_booking_requests_declined = 0
    @total_booking_requests_completed = 0
    @total_booking_requests_cancelled = 0
    total_users_with_subscription = users_with_valid_subscription.count

    users_with_valid_subscription.each do |user|
      booking_requests_after_subscription_start = user.bookings.where("created_at > ?", user.subscription.created_at)
      total_booking_requests_after_subscription_start = booking_requests_after_subscription_start.count
      @confirmed_booking_requests_after_subscription_start = booking_requests_after_subscription_start.confirmed.count
      @completed_booking_requests_after_subscription_start = booking_requests_after_subscription_start.completed.count
      @pending_booking_requests_after_subscription_start = booking_requests_after_subscription_start.pending.count
      @declined_booking_requests_after_subscription_start = booking_requests_after_subscription_start.declined.count
      @cancelled_booking_requests_after_subscription_start = booking_requests_after_subscription_start.cancelled.count
      successful_booking_requests_after_subscription_start = @confirmed_booking_requests_after_subscription_start + @completed_booking_requests_after_subscription_start

      if total_booking_requests_after_subscription_start.positive?
        @total_users_with_subscription_request += 1
        @requests_subscribers += total_booking_requests_after_subscription_start
        @total_booking_requests_pending += @pending_booking_requests_after_subscription_start
        @total_booking_requests_confirmed += @confirmed_booking_requests_after_subscription_start
        @total_booking_requests_declined += @declined_booking_requests_after_subscription_start
        @total_booking_requests_completed += @completed_booking_requests_after_subscription_start
        @total_booking_requests_cancelled += @cancelled_booking_requests_after_subscription_start
        success_rate = (successful_booking_requests_after_subscription_start.to_f / total_booking_requests_after_subscription_start * 100)
        total_success_rate += success_rate
      else
        @total_users_with_subscription_no_request += 1
      end
    end

    average_success_rate = total_success_rate / total_users_with_subscription if total_users_with_subscription.positive?

    format("%.0f%%", average_success_rate)
  end
end

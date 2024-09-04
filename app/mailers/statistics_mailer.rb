class StatisticsMailer < ApplicationMailer
  def send_stats
    set_user_stats
    set_review_stats
    set_booking_stats
    set_subscription_stats

    mail(to: 'hello@quouch-app.com', subject: 'User Stats Report')
  end

  private

  def set_user_stats
    @total_users = User.count
    @users_per_city = group_and_count(User, :city)
    @users_per_country = group_and_count(User, :country)
  end

  def set_review_stats
    @amount_reviews = Review.count
    @review_average = Review.average(:rating)
    @reviews_today = Review.where(created_at: Date.today).count
  end

  def set_booking_stats
    @bookings = Booking.count
    @bookings_today = bookings_today
    set_booking_status_stats
    set_booking_response_rates
  end

  def set_booking_status_stats
    @pending_bookings = count_bookings_by_status(0)
    @completed_bookings = count_bookings_by_status(4)
    @confirmed_bookings = count_bookings_by_status(1)
    @cancelled_bookings = count_bookings_by_status(-1)
    @expired_bookings = count_bookings_by_status(-2)
  end

  def set_booking_response_rates
    @response_rate = message_response_rate
    @booking_response_rate = request_response_rate
    @booking_confirmation_rate = request_confirmation_rate
    @booking_confirmation_rate_ten_requests = ten_requests_confirmation_rate
  end

  def set_subscription_stats
    @total_subscriptions = Subscription.where.not(stripe_id: nil).count
    @subscription_success_rate = subscription_success_rate
    initialize_subscription_counters
  end

  def group_and_count(model, attribute)
    model.group(attribute).order('count_all DESC').count
  end

  def count_bookings_by_status(status)
    Booking.where(status:).count
  end

  def bookings_today
    Booking.where(booking_date: Date.today).group(:request).count
  end

  def message_response_rate
    response_rate_query = <<-SQL
      SELECT ROUND((COUNT(DISTINCT m1.chat_id)::numeric / (SELECT COUNT(*) FROM chats)) * 100, 2) AS response_rate
      FROM messages AS m1
      JOIN messages AS m2 ON m1.chat_id = m2.chat_id AND m1.user_id != m2.user_id;
    SQL

    result = ActiveRecord::Base.connection.execute(response_rate_query)
    format_percentage(result[0]['response_rate'].to_f)
  end

  def request_response_rate
    non_pending_bookings_count = Booking.where.not(status: 0).count
    expired_bookings_count = Booking.where(status: -2).count
    total_bookings_count = Booking.count

    calculate_percentage((non_pending_bookings_count - expired_bookings_count), total_bookings_count)
  end

  def request_confirmation_rate
    successful_bookings_count = count_bookings_by_status(1) + count_bookings_by_status(4)
    total_bookings_count = Booking.count
    calculate_percentage(successful_bookings_count, total_bookings_count)
  end

  def ten_requests_confirmation_rate
    response_rate = request_confirmation_rate.to_f / 100
    probability_not_confirmed = 1 - response_rate
    probability_at_least_one_confirmed = 1 - (probability_not_confirmed**10)
    format_percentage(probability_at_least_one_confirmed * 100)
  end

  def subscription_success_rate
    valid_subscriptions = Subscription.where.not(stripe_id: nil)
    users_with_valid_subscription = User.joins(:subscription).merge(valid_subscriptions)

    reset_subscription_counters

    total_success_rate = calculate_subscription_success_rate(users_with_valid_subscription)

    average_success_rate = calculate_average_success_rate(total_success_rate, users_with_valid_subscription.count)
    format_percentage(average_success_rate)
  end

  def calculate_subscription_success_rate(users_with_valid_subscription)
    total_success_rate = 0

    users_with_valid_subscription.each do |user|
      booking_requests = user.bookings.where('created_at > ?', user.subscription.created_at)
      total_requests = booking_requests.count
      success_rate = calculate_success_rate(booking_requests)

      update_subscription_counters(user, total_requests, booking_requests)

      total_success_rate += success_rate if total_requests.positive?
    end

    total_success_rate
  end

  def calculate_success_rate(booking_requests)
    confirmed = booking_requests.confirmed.count
    completed = booking_requests.completed.count
    successful = confirmed + completed
    total_requests = booking_requests.count

    successful.to_f / total_requests * 100 if total_requests.positive?
  end

  def update_subscription_counters(_user, total_requests, booking_requests)
    if total_requests.positive?
      @requests_subscribers += total_requests
      @total_booking_requests_pending += booking_requests.pending.count
      @total_booking_requests_confirmed += booking_requests.confirmed.count
      @total_booking_requests_declined += booking_requests.declined.count
      @total_booking_requests_completed += booking_requests.completed.count
      @total_booking_requests_cancelled += booking_requests.cancelled.count
      @total_booking_requests_expired += booking_requests.expired.count
    else
      @total_users_with_subscription_no_request += 1
    end
  end

  def calculate_average_success_rate(total_success_rate, total_users_with_subscription)
    return 0 if total_users_with_subscription.zero?

    total_success_rate / total_users_with_subscription
  end

  def format_percentage(value)
    format('%.0f%%', value)
  end

  def calculate_percentage(part, whole)
    format_percentage((part.to_f / whole) * 100)
  end

  def initialize_subscription_counters
    @total_users_with_subscription_no_request ||= 0
    @requests_subscribers ||= 0
    @total_booking_requests_pending ||= 0
    @total_booking_requests_cancelled ||= 0
    @total_booking_requests_confirmed ||= 0
    @total_booking_requests_declined ||= 0
    @total_booking_requests_completed ||= 0
    @initialize_subscription_counters ||= 0
  end

  def reset_subscription_counters
    @total_users_with_subscription_no_request = 0
    @requests_subscribers = 0
    @total_booking_requests_pending = 0
    @total_booking_requests_cancelled = 0
    @total_booking_requests_confirmed = 0
    @total_booking_requests_declined = 0
    @total_booking_requests_completed = 0
    @total_booking_requests_expired = 0
  end
end

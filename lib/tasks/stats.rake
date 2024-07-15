namespace :stats do
  desc "Send user statistics"

  task print: :environment do
    def subscription_success_rate
      valid_subscriptions = Subscription.where.not(stripe_id: nil)
      users_with_valid_subscription = User.joins(:subscription).merge(valid_subscriptions)

      total_success_rate = 0
      total_users_with_subscription = users_with_valid_subscription.count

      users_with_valid_subscription.each do |user|
        booking_requests_after_subscription_start = user.bookings.where("created_at > ?", user.subscription.created_at)
        total_booking_requests_after_subscription_start = booking_requests_after_subscription_start.count
        confirmed_booking_requests_after_subscription_start = booking_requests_after_subscription_start.confirmed.count

        if total_booking_requests_after_subscription_start.positive?
          success_rate = (confirmed_booking_requests_after_subscription_start.to_f / total_booking_requests_after_subscription_start * 100)
          total_success_rate += success_rate
        end
      end

      if total_users_with_subscription.positive?
        average_success_rate = total_success_rate / total_users_with_subscription
      end

      format("%.0f%%", average_success_rate)
    end

    subscription_success_rate
  end

  task send: :environment do
    StatisticsMailer.send_stats.deliver_now
  end
end

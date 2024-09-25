class BookingsJob < ApplicationJob
  queue_as :default

  # Retry on SMTP Timeout errors with a wait period and limited attempts
  retry_on Net::SMTPFatalError, Net::ReadTimeout, wait: ->(attempt) { 5.seconds * (2**attempt) }, attempts: 10

  def perform
    complete_bookings
    remind_bookings
  rescue StandardError => e
    Sentry.capture_exception(e)
    raise e
  end

  def complete_bookings
    completed_bookings = Booking.where('end_date <= ?', Date.today).where(status: 1)
    return if completed_bookings.empty?

    send_completed_emails(completed_bookings)
    update_status(completed_bookings, 4)
  rescue StandardError => e
    Sentry.capture_exception(e)
    raise e
  end

  def remind_bookings
    one_month_ago = Date.today - 1.month

    pending_future_fixed_bookings = Booking.where(status: 0)
                                           .where('start_date >= ?', Date.today)
                                           .where(flexible: false)

    pending_future_flexible_bookings = Booking.where(status: 0)
                                              .where(start_date: nil, flexible: true)
                                              .where(
                                                'booking_date >= ?', one_month_ago
                                              )

    pending_future_bookings = pending_future_fixed_bookings.or(pending_future_flexible_bookings)

    Sentry.capture_message("Found #{pending_future_bookings.size} pending future bookings")

    pending_past_bookings = Booking.where(status: 0).where('start_date < ?', Date.today)
                                   .or(Booking.where(status: 0).where(start_date: nil, flexible: true)
                                   .where('booking_date < ?', one_month_ago))

    pending_past_bookings.update_all(status: -2)
    return if pending_future_bookings.empty?

    send_reminder_emails(pending_future_bookings)
  rescue StandardError => e
    Sentry.capture_exception(e)
    raise e
  end

  def update_status(bookings, status)
    bookings.update_all(status:)
  end

  def send_completed_emails(bookings)
    bookings.each do |booking|
      BookingMailer.with(booking:).booking_completed_guest_email.deliver
      BookingMailer.with(booking:).booking_completed_host_email.deliver
    end
  end

  def send_reminder_emails(bookings)
    bookings.each do |booking|
      BookingMailer.with(booking:).pending_booking_reminder_email.deliver
    end
  end
end

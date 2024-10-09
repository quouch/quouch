require 'sib-api-v3-sdk'
class BookingsJob < ApplicationJob
  queue_as :default

  SibApiV3Sdk.configure do |config|
    config.api_key['api-key'] = Rails.application.credentials.dig(:brevo, :api_key)
  end

  def perform
    Rails.application.routes.default_url_options[:host] =
      Rails.application.config.action_mailer.default_url_options[:host]
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
    bookings.each do |booking|
      booking.update(status:)
      AmplitudeEventTracker.track_booking_event(booking, 'Booking Completed')
    end
  end

  def send_completed_emails(bookings)
    bookings.each do |booking|
      BookingMailer.with(booking:).booking_completed_guest_email.deliver
      BookingMailer.with(booking:).booking_completed_host_email.deliver
    end
  end

  def send_reminder_emails(bookings)
    api_instance = SibApiV3Sdk::TransactionalEmailsApi.new

    bookings.each do |booking|
      send_smtp_email = SibApiV3Sdk::SendSmtpEmail.new(
        templateId: 56,
        replyTo: { email: 'hello@quouch-app.com' },
        params: {
          guest_first_name: booking.user.first_name,
          host_first_name: booking.couch.user.first_name,
          message: booking.message,
          booking_url: Rails.application.routes.url_helpers.request_booking_url(booking)
        },
        to: [{ email: booking.couch.user.email }]
      )
      begin
        api_instance.send_transac_email(send_smtp_email)
      rescue SibApiV3Sdk::ApiError => e
        puts 'Exception when calling TransactionalEmailsApi->send_transac_email:'
        puts "Error message: #{e.message}"
        puts "HTTP status code: #{e.code}" if e.respond_to?(:code)
        puts "Response body: #{e.response_body}" if e.respond_to?(:response_body)
      end
    end
  end
end

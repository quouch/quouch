require 'sib-api-v3-sdk'
class BookingsJob < ApplicationJob
  queue_as :default

  @one_month_ago = Date.today - 1.month

  SibApiV3Sdk.configure do |config|
    config.api_key['api-key'] = Rails.application.credentials.dig(:brevo, :api_key)
  end

  def perform
    Rails.application.routes.default_url_options[:host] =
      Rails.application.config.action_mailer.default_url_options[:host]
    complete_bookings
    expire_past_bookings
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
    return unless Date.today.monday?

    return if pending_future_bookings.empty?

    send_reminder_emails(pending_future_bookings)
  rescue StandardError => e
    Sentry.capture_exception(e)
    raise e
  end

  def pending_future_bookings
    pending_future_fixed_bookings = Booking.where(status: 0)
                                           .where('start_date >= ?', Date.today)
                                           .where(flexible: false)

    pending_future_flexible_bookings = Booking.where(status: 0)
                                              .where(start_date: nil, flexible: true)
                                              .where(
                                                'booking_date >= ?', @one_month_ago
                                              )

    pending_future_fixed_bookings.or(pending_future_flexible_bookings)
  end

  def expire_past_bookings
    pending_past_bookings = Booking.where(status: 0).where('start_date < ?', Date.today)
                                   .or(Booking.where(status: 0).where(start_date: nil, flexible: true)
                                   .where('booking_date < ?', @one_month_ago))

    pending_past_bookings.update_all(status: -2)
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

    unique_hosts = bookings.map { |booking| booking.couch.user }.uniq

    unique_hosts.each do |host|
      send_smtp_email = SibApiV3Sdk::SendSmtpEmail.new(
        templateId: 56,
        replyTo: { email: 'hello@quouch-app.com' },
        params: {
          host_first_name: host.first_name
        },
        to: [{ email: host.email }]
      )
      begin
        api_instance.send_transac_email(send_smtp_email)
      rescue SibApiV3Sdk::ApiError => e
        Rails.logger.error 'Exception when calling TransactionalEmailsApi->send_transac_email:'
        Rails.logger.error "Error message: #{e.message}"
        Rails.logger.error "HTTP status code: #{e.code}" if e.respond_to?(:code)
        Rails.logger.error "Response body: #{e.response_body}" if e.respond_to?(:response_body)
      end
    end
  end
end

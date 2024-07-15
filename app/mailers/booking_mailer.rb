class BookingMailer < ApplicationMailer
  before_action :set_booking_details
  before_action :set_couch, only: %i[booking_completed_host_email booking_completed_guest_email]
  before_action :set_urls

  default from: "Quouch <hello@quouch-app.com>"

  def new_request_email
    @request_url = request_booking_url(@booking)
    mail(to: @host.email, subject: "New Quouch Request from #{@guest.first_name.capitalize}💜🧡")
  end

  def request_updated_email
    @request_url = request_booking_url(@booking)
    mail(to: @host.email, subject: "Request from #{@guest.first_name.capitalize} has been updated")
  end

  def request_cancelled_email
    @request_url = request_booking_url(@booking)
    mail(to: @host.email, subject: "#{@guest.first_name.capitalize} cancelled the request")
  end

  def request_confirmed_email
    @booking_url = booking_url(@booking)
    mail(to: @guest.email, subject: "Your request with #{@host.first_name.capitalize} has been confirmed 🎉")
  end

  def request_declined_email
    @request_url = request_booking_url(@booking)
    mail(to: @guest.email, subject: "Your request with #{@host.first_name.capitalize} has been declined")
  end

  def booking_cancelled_by_guest_email
    @request_url = request_booking_url(@booking)
    mail(to: @host.email, subject: "Your guest #{@guest.first_name.capitalize} cancelled the booking")
  end

  def booking_cancelled_by_host_email
    @booking_url = booking_url(@booking)
    @home_url = root_url
    mail(to: @guest.email, subject: "Your host #{@host.first_name.capitalize} cancelled the booking")
  end

  def booking_updated_email
    @request_url = request_booking_url(@booking)
    mail(to: @host.email, subject: "Your guest #{@guest.first_name.capitalize} updated the booking")
  end

  def booking_completed_guest_email
    @review_url = booking_url(@booking)
    mail(to: @guest.email, subject: "You stayed with #{@host.first_name.capitalize} - please leave review")
  end

  def booking_completed_host_email
    @review_url = request_booking_url(@booking)
    mail(to: @host.email, subject: "#{@guest.first_name.capitalize} stayed with you - please leave review")
  end

  def pending_booking_reminder_email
    @request_url = request_booking_url(@booking)
    mail(to: @host.email, subject: "Reminder: pending booking request from #{@guest.first_name.capitalize}")
  end

  private

  def set_urls
    @browse_couches = root_url
    @guidelines = "https://quouch-app.com/guidelines"
    @invite_code = "https://quouch-app.com/invite-friend"
    @feedback_form_guest = "https://forms.gle/mAiFEpxrw5PsbKD87"
    @feedback_form_host = "https://forms.gle/AwrdCDawwWJ1VNvL9"
    @feedback_form_app = "https://forms.gle/by6szdpGKtpfv6mD7"
  end

  def set_booking_details
    @booking = params[:booking]
    @host = @booking.couch.user
    @guest = @booking.user
  end

  def set_couch
    @booking = params[:booking]
    @couch = @booking.couch
  end
end

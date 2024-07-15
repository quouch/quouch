class ReviewMailer < ApplicationMailer
  before_action :set_booking_details
  default from: "Quouch <hello@quouch-app.com>"

  def new_review_host_email
    mail(to: @host.email, subject: "Your host left you a review 🎉")
  end

  def new_review_guest_email
    mail(to: @guest.email, subject: "Your guest left you a review 🎉")
  end

  private

  def set_booking_details
    @booking = params[:booking]
    @guest = @booking.user
    @couch = @booking.couch
    @host = @couch.user
    @host_profile = couch_url(@couch)
    @guest_profile = couch_url(@booking.user.couch)
    @guest_review = request_booking_url(@booking)
    @host_review = booking_url(@booking)
  end
end

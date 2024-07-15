class Booking < ApplicationRecord
  belongs_to :couch
  belongs_to :user
  has_many :reviews, dependent: :destroy

  validates :request, presence: {message: "Please select one"}
  validates :message, presence: true
  validate :matches_capacity?, if: -> { couch.capacity }
  validate :duplicate_booking?, on: :create
  validate :duplicate_request?, on: :create

  enum status: {pending: 0, confirmed: 1, declined: 2, pending_reconfirmation: 3, completed: 4, cancelled: -1}
  enum request: {host: 0, hangout: 1, cowork: 2}

  def matches_capacity?
    return false unless number_travellers > couch.capacity

    errors.add(:number_travellers, "Capacity of couch exceeded")
  end

  def duplicate_booking?
    return false unless Booking.where(couch:, start_date:, end_date:, status: 1).exists?

    errors.add(:start_date, "Sorry, couch is already booked!")
  end

  def duplicate_request?
    return false unless Booking.where(user:, couch:, start_date:, end_date:, status: 0 || 2).exists?

    errors.add(:start_date, "Duplicate request with host")
  end

  def self.complete
    completed_bookings = Booking.where(end_date: ...Date.today, status: 1)
    return if completed_bookings.empty?

    send_completed_emails(completed_bookings)
    update_status(completed_bookings)
  end

  def self.remind
    today = Date.today
    return unless (today.day % 3).zero?

    pending_bookings = Booking.where("start_date >= ?", Date.today).where(status: 0)
    return if pending_bookings.empty?

    send_reminder_emails(pending_bookings)
  end

  def self.delete
    pending_bookings = Booking.where(start_date: ...Date.today, status: 0)
    pending_bookings.destroy_all
  end

  def self.update_status(bookings)
    bookings.update_all(status: 4)
  end

  def self.send_completed_emails(bookings)
    bookings.each do |booking|
      BookingMailer.with(booking:).booking_completed_guest_email.deliver
      BookingMailer.with(booking:).booking_completed_host_email.deliver
    end
  end

  def self.send_reminder_emails(bookings)
    bookings.each do |booking|
      BookingMailer.with(booking:).pending_booking_reminder_email.deliver
    end
  end
end

class Booking < ApplicationRecord
  belongs_to :couch
  belongs_to :user
  has_many :reviews, dependent: :destroy

  validates :request, presence: { message: 'Please select one' }
  validates :message, presence: true
  validates :start_date, presence: true, on: %i[create update]
  validates :end_date, presence: true, on: %i[create update]
  validate :matches_capacity?, if: -> { couch.capacity }
  validate :duplicate_booking?, on: :create
  validate :duplicate_request?, on: :create

  enum status: { pending: 0, confirmed: 1, declined: 2, pending_reconfirmation: 3, completed: 4, cancelled: -1,
                 expired: -2 }
  enum request: { host: 0, hangout: 1, cowork: 2 }

  def matches_capacity?
    return false unless number_travellers > couch.capacity

    errors.add(:number_travellers, 'Capacity of couch exceeded')
  end

  def duplicate_booking?
    return false unless Booking.where(couch:, start_date:, end_date:, status: 1).exists?

    errors.add(:start_date, 'Sorry, couch is already booked!')
  end

  def duplicate_request?
    return false unless Booking.where(user:, couch:, start_date:, end_date:, status: 0 || 2).exists?

    errors.add(:start_date, 'Duplicated request with host')
  end

  def status_change_allowed?(new_status, current_user)
    # Convert to string before comparing, to avoid issues with symbols
    status_string = new_status.to_s

    return true if status_string == status.to_s

    status_allowed_for_host = %w[confirmed declined]
    status_allowed_for_guest = %w[cancelled]

    return status_allowed_for_guest.include?(status_string) if current_user.id == user_id
    return status_allowed_for_host.include?(status_string) if current_user.id == couch.user_id

    false
  end
end

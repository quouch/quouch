class User < ApplicationRecord # rubocop:disable Metrics/ClassLength
  # Include default devise modules. Others available are:
  # :lockable, :trackable and :omniauthable
  include PgSearch::Model
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable,
    :jwt_authenticatable, jwt_revocation_strategy: self

  has_one_attached :photo
  has_one :couch, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :couch
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy, as: :recipient
  has_many :chats_as_receiver, class_name: "Chat", foreign_key: :user_receiver_id, dependent: :destroy
  has_many :chats_as_sender, class_name: "Chat", foreign_key: :user_sender_id, dependent: :destroy

  has_many :user_characteristics, dependent: :destroy, autosave: true
  has_many :characteristics, through: :user_characteristics, dependent: :destroy
  has_one :subscription, dependent: :destroy

  validates :photo, presence: {message: "Please upload a picture"}, on: :create
  validates :first_name, presence: {message: "First name required"}, on: :create
  validates :last_name, presence: {message: "Last name required"}, on: :create
  validates :date_of_birth, presence: {message: "Please provide your age"}, on: :create
  validates :address, presence: {message: "Address required"}, on: :create
  validates :zipcode, presence: {message: "Zipcode required"}, on: :create
  validates :city, presence: {message: "City required"}, on: :create
  validates :country, presence: {message: "Country required"}, on: :create
  validates :summary, presence: {message: "Tell the community about you"},
    length: {minimum: 50, message: "Tell us more about you (minimum 50 characters)"}, on: :create
  validates_associated :characteristics, message: "Let others know what is important to you", on: :create
  validate :validate_user_characteristics, on: :create
  validate :validate_age, on: :create
  validate :validate_travelling, on: :create
  validate :at_least_one_option_checked?, on: :create

  after_validation :create_stripe_reference, on: :create

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  before_create :generate_invite_code

  pg_search_scope :search_city_or_country,
    against: %i[city country],
    using: {
      tsearch: {prefix: true}
    }

  after_destroy :cancel_stripe_subscription

  def calculated_age # rubocop:disable Metrics/AbcSize
    today = Date.today
    return unless date_of_birth

    calculation = if today.month > date_of_birth.month || (today.month == date_of_birth.month && today.day >= date_of_birth.day)
      0
    else
      1
    end
    today.year - date_of_birth.year - calculation
  end

  def chats
    Chat.includes(:messages).where("user_receiver_id = ? OR user_sender_id = ?", id, id)
  end

  def latest_message_chat
    Chat.joins(:messages)
      .where("chats.user_sender_id = :user_id OR chats.user_receiver_id = :user_id", user_id: id)
      .order("messages.created_at DESC")
      .first
  end

  def validate_age
    return unless calculated_age.present? && calculated_age < 18

    errors.add(:date_of_birth, "Sorry you are too young, please come back when you are 18!")
  end

  def at_least_one_option_checked?
    offers_couch || offers_co_work || offers_hang_out || travelling
  end

  def validate_travelling
    return if at_least_one_option_checked?

    errors.add(:travelling, "at least one option must be checked")
  end

  def generate_invite_code
    loop do
      new_invite_code = SecureRandom.hex(3)

      unless User.exists?(invite_code: new_invite_code)
        self.invite_code = new_invite_code
        break
      end
    end
  end

  def validate_user_characteristics
    errors.add(:user_characteristics, "Let others know what is important to you") if user_characteristics.empty?
  end

  def create_stripe_reference
    response = Stripe::Customer.create(email:)
    self.stripe_id = response.id
  rescue Stripe::StripeError => e
    handle_stripe_reference_creation_error("Error creating Stripe customer: #{e.message}")
  rescue => e
    handle_stripe_reference_creation_error("An unexpected error occurred during Stripe customer creation: #{e.message}")
  end

  def handle_stripe_reference_creation_error(error_message)
    flash[:error] = error_message
    redirect_to new_subscription_url
  end

  def cancel_stripe_subscription
    return unless subscription

    stripe_subscription = Stripe::Subscription.retrieve(subscription.stripe_id)
    stripe_subscription.cancel_at_period_end = true
    return unless stripe_subscription.save

    subscription.update!(end_of_period: Time.at(stripe_subscription.current_period_end).to_date)
  end
end

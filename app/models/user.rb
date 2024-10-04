class User < ApplicationRecord # rubocop:disable Metrics/ClassLength
  # Include default devise modules. Others available are:
  # :lockable, :trackable and :omniauthable
  include PgSearch::Model
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include InviteCodeHelper
  include AddressHelper

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
  has_many :chats_as_receiver, class_name: 'Chat', foreign_key: :user_receiver_id, dependent: :destroy
  has_many :chats_as_sender, class_name: 'Chat', foreign_key: :user_sender_id, dependent: :destroy

  has_many :user_characteristics, dependent: :destroy, autosave: true
  has_many :characteristics, through: :user_characteristics, dependent: :destroy
  has_one :subscription, dependent: :destroy

  validates :photo, presence: { message: 'Please upload a picture' }, on: %i[create update]
  validates :first_name, presence: { message: 'First name required' }, on: %i[create update]
  validates :last_name, presence: { message: 'Last name required' }, on: %i[create update]
  validates :date_of_birth, presence: { message: 'Please provide your age' }, on: %i[create update]
  validates :address, presence: { message: 'Address required' }, on: %i[create update]
  validates :zipcode, presence: { message: 'Zipcode required' }, on: %i[create update]
  validates :city, presence: { message: 'City required' }, on: %i[create update]
  validate :validate_country_code, on: %i[create update]
  validates :country, presence: { message: 'Country required' }, on: %i[create update]
  validates :summary, presence: { message: 'Tell the community about you' },
                      length: { minimum: 50, message: 'Tell us more about you (minimum 50 characters)' },
                      on: %i[create update]
  validates_associated :characteristics, message: 'Let others know what is important to you', on: %i[create update]
  validate :validate_user_characteristics, on: %i[create update]
  validate :validate_facilities, on: %i[update]
  validate :validate_age, on: %i[create update]
  validate :validate_travelling, on: %i[create update]
  validate :at_least_one_option_checked?, on: %i[create update]
  validates :invited_by_id, on: :create, presence: { message: 'Please provide a valid invite code' }

  after_validation :create_stripe_reference, on: :create

  geocoded_by :address
  after_validation :manual_geocode, if: :will_save_change_to_address?
  before_create :generate_invite_code

  pg_search_scope :search_city_or_country,
                  against: %i[city country],
                  using: {
                    tsearch: { prefix: true }
                  }

  after_destroy :cancel_stripe_subscription

  def calculated_age # rubocop:disable Metrics/AbcSize
    today = Date.today
    return unless date_of_birth

    if today.month > date_of_birth.month || (today.month == date_of_birth.month && today.day >= date_of_birth.day)
      calculation = 0
    else
      calculation = 1
    end
    today.year - date_of_birth.year - calculation
  end

  def chats
    Chat.includes(:messages).where('user_receiver_id = ? OR user_sender_id = ?', id, id)
  end

  def latest_message_chat
    Chat.joins(:messages)
        .where('chats.user_sender_id = :user_id OR chats.user_receiver_id = :user_id', user_id: id)
        .order('messages.created_at DESC')
        .first
  end

  def validate_age
    return unless calculated_age.present? && calculated_age < 18

    errors.add(:date_of_birth, 'Sorry you are too young, please come back when you are 18!')
  end

  def at_least_one_option_checked?
    offers_couch || offers_co_work || offers_hang_out || travelling
  end

  def validate_travelling
    return if at_least_one_option_checked?

    errors.add(:travelling, 'at least one option must be checked')
  end

  def generate_invite_code
    loop do
      new_invite_code = generate_random_code

      unless User.exists?(invite_code: new_invite_code)
        self.invite_code = new_invite_code
        break
      end
    end
  end

  def validate_user_characteristics
    errors.add(:user_characteristics, 'Let others know what is important to you') if user_characteristics.empty?
  end

  def validate_facilities
    return unless offers_couch
    return unless couch
    return if couch.facilities?

    errors.add(:couch_facilities, 'Please select at least one facility')
  end

  def create_stripe_reference
    response = Stripe::Customer.create(email:)
    self.stripe_id = response.id
  rescue StandardError => e
    Rails.logger.error("An unexpected error occurred during Stripe customer creation: #{e.message}")
    errors.add(:stripe_id,
               'Something went wrong when communicating with Stripe. Please try again later or contact the Quouch team!')
  end

  def cancel_stripe_subscription
    return unless subscription

    stripe_subscription = Stripe::Subscription.retrieve(subscription.stripe_id)
    stripe_subscription.cancel_at_period_end = true
    return unless stripe_subscription.save

    subscription.update!(end_of_period: Time.at(stripe_subscription.current_period_end).to_date)
  end

  def validate_country_code
    country_code = self.country_code

    raise ArgumentError if country_code.blank?

    country = beautify_country(country_code)
    raise ArgumentError if country.blank?

    self.country = country
  rescue ArgumentError
    errors.add(:country_code, 'Please provide a valid country code')
  end

  def manual_geocode
    Rails.logger.info("GeoCoding address: #{address}")
    raise ArgumentError, 'address cannot be blank' if address.blank?

    found_match = GeocoderService.search(address)

    self.latitude = found_match.latitude
    self.longitude = found_match.longitude
  rescue GeocoderError => e
    Rails.logger.error(e.message)
    errors.add(:address, 'Geocoding failed, please provide a valid address')
  rescue ArgumentError => e
    Rails.logger.error(e.message)
    errors.add(:address, e.message)
  rescue StandardError => e
    Rails.logger.error(e.message)
    Sentry.capture_exception(e, extra: { address: })
  end

  def reset_password(new_password, new_password_confirmation)
    if new_password.present?
      self.password = new_password
      self.password_confirmation = new_password_confirmation
      save(context: :password_update)
    else
      errors.add(:password, :blank)
      false
    end
  end

  def subscribed?
    subscription.present? && subscription.stripe_id_present?
  end

  def display_name
    return first_name.capitalize if first_name

    email
  end
end

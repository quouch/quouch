class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable, :trackable and :omniauthable, :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo
  has_one :couch, dependent: :destroy
  has_many :bookings
  has_many :reviews
  has_many :messages
  has_many :chat_users
  has_many :chats, through: :chat_users

  belongs_to :city, optional: true

  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :pronouns, presence: true, inclusion: { in: ['she/her', 'he/him', 'they/them'] }
  # validates :date_of_birth, presence: true
  # validate :validate_age
  # validates :summary, presence: true, length: { minimum: 100, too_short:
  #   "We want to know more about you - write at least 100 characters about yourself" }
  # validates :question_one, presence: true, length: { minimum: 100, too_short: "Write at least 100 characters" }
  # validates :question_two, presence: true, length: { minimum: 100, too_short: "Write at least 100 characters" }
  # validates :question_three, presence: true, length: { minimum: 100, too_short: "Write at least 100 characters" }
  # validates :question_four, presence: true, length: { minimum: 100, too_short: "Write at least 100 characters" }

  def calculated_age
    today = Date.today
    if today.month > date_of_birth.month || (today.month == date_of_birth.month && today.day >= date_of_birth.day)
      calculation = 0
    else
      calculation = 1
    end
    today.year - date_of_birth.year - calculation
  end

  def validate_age
    if calculated_age.present? && calculated_age > 18.years.ago.to_i
      errors.add(:birth_date, 'You should be over 18 years old.')
    end
  end

  def full_name
    return first_name + last_name
  end
end

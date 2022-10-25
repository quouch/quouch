class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one_attached :photo
  has_one :couch, dependent: :destroy
  has_many :bookings
  has_many :reviews
  has_many :messages
  has_many :chat_users
  has_many :chats, through: :chat_users

  belongs_to :city

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :pronouns, presence: true, inclusion: { in: ['she/her', 'he/him', 'they/them'] }
  validates :date_of_birth, presence: true
  validates :summary, presence: true, length: { minimum: 100, too_short:
    "We want to know more about you - write at least 100 characters about yourself" }
  validates :question_one, presence: true, length: { minimum: 100, too_short: "Write at least 100 characters" }
  validates :question_two, presence: true, length: { minimum: 100, too_short: "Write at least 100 characters" }
  validates :question_three, presence: true, length: { minimum: 100, too_short: "Write at least 100 characters" }
  validates :question_four, presence: true, length: { minimum: 100, too_short: "Write at least 100 characters" }
end

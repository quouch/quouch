class Chat < ApplicationRecord
  belongs_to :user_sender, class_name: "User"
  belongs_to :user_receiver, class_name: "User"
  has_many :messages, dependent: :destroy

  has_noticed_notifications model_name: "Notification"

  validates :user_sender_id, uniqueness: {scope: :user_receiver_id}

  def other_user(current_user)
    (user_sender_id == current_user.id) ? user_receiver : user_sender
  end
end

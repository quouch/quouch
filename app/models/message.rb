class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  after_create_commit do
    notify_recipient
  end

  def sender?(a_user)
    user.id == a_user.id
  end

  private

  def notify_recipient
    recipient = self.chat.user_receiver_id
    MessageNotification.with(message: self).deliver_later(recipient)
  end
end

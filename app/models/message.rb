class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  validates :content, presence: {message: "Message can't be empty"}

  after_create_commit do
    notify_recipient
  end

  def sender?(a_user)
    user.id.eql?(a_user.id)
  end

  private

  def find_recipient(message)
    @users = [User.find(message.chat.user_sender_id), User.find(message.chat.user_receiver_id)]
    @users.each do |user|
      next if user.eql?(message.user)

      @user = user
    end
    @user
  end

  def notify_recipient
    recipient = find_recipient(self)
    MessageNotification.with(message: self, chat:).deliver_later(recipient)
  end
end

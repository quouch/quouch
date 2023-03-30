class Chat < ApplicationRecord
	has_many :messages

	has_noticed_notifications model_name: 'Notification'

	validates :user_sender_id, uniqueness: { scope: :user_receiver_id }
end

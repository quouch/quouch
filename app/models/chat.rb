class Chat < ApplicationRecord
	has_many :messages

	validates :user_sender_id, uniqueness: { scope: :user_receiver_id }
end

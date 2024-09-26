# frozen_string_literal: true

class ChatSerializer < BaseSerializer
  belongs_to :user_sender, serializer: UserSerializer
  belongs_to :user_receiver, serializer: UserSerializer
  has_many :messages

  attributes :id, :user_sender_id, :user_receiver_id, :created_at, :updated_at
end

# frozen_string_literal: true

class MessageSerializer < BaseSerializer
  belongs_to :chat

  attributes :id, :chat_id, :created_at, :updated_at, :content

  # Rename `user` to `sender` for clarity!
  attribute :sender_id, &:user_id

  belongs_to :sender, serializer: UserSerializer, &:user
end

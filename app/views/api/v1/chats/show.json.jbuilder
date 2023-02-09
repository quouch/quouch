json.extract! @chat, :user_sender_id, :user_receiver_id, :messages
json.messages @chat.messages do |message|
  json.extract! message, :id, :content
end

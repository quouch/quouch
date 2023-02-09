json.array! @chats do |chat|
  json.extract! chat, :id, :user_sender_id, :user_receiver_id, :messages
end
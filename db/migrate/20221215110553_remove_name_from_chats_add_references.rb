class RemoveNameFromChatsAddReferences < ActiveRecord::Migration[7.0]
  def change
    remove_column :chats, :name
    add_reference :chats, :user_sender, foreign_key: { to_table: :users }
    add_reference :chats, :user_receiver, foreign_key: { to_table: :users }
  end
end

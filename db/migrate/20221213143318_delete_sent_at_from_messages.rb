class DeleteSentAtFromMessages < ActiveRecord::Migration[7.0]
  def change
    remove_column :messages, :sent_at
  end
end

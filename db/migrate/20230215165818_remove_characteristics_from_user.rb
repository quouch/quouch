class RemoveCharacteristicsFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :characteristics
  end
end

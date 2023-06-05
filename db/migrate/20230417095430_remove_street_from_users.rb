class RemoveStreetFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :street
  end
end

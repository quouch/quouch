class AddPassionToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :passion, :string
  end
end

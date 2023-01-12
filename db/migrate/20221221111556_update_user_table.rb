class UpdateUserTable < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :characteristics, :text, array: true
    add_column :users, :address, :string
  end
end

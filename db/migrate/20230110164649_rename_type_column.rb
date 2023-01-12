class RenameTypeColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :payments, :type, :operation
  end
end

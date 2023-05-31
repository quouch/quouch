class RemoveActiveFromCouches < ActiveRecord::Migration[7.0]
  def change
    remove_column :couches, :active, :boolean
  end
end

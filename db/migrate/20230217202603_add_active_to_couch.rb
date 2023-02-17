class AddActiveToCouch < ActiveRecord::Migration[7.0]
  def change
    add_column :couches, :active, :boolean, default: true
  end
end

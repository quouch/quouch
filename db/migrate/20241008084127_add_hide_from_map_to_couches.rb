class AddHideFromMapToCouches < ActiveRecord::Migration[7.0]
  def change
    add_column :couches, :hide_from_map, :boolean, default: false
  end
end

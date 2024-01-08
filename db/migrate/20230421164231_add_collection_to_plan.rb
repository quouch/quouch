class AddCollectionToPlan < ActiveRecord::Migration[7.0]
  def change
    add_column :plans, :collection, :string
  end
end

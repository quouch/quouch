class DropPlansTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :plans
  end
end

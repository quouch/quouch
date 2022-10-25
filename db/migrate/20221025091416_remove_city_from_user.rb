class RemoveCityFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :city_id, :bigint
  end
end

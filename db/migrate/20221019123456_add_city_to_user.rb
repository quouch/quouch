class AddCityToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :city, null: false, foreign_key: true
  end
end

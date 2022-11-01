class AddCityToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :city
  end
end

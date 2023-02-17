class AddCountryToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :country, foreign_key: true
  end
end

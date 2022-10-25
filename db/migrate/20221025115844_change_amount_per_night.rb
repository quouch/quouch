class ChangeAmountPerNight < ActiveRecord::Migration[7.0]
  def change
    rename_column :bookings, :price_per_night, :minimum_amount
  end
end

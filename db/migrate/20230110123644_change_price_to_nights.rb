class ChangePriceToNights < ActiveRecord::Migration[7.0]
  def change
    rename_column :bookings, :nights, :nights
  end
end

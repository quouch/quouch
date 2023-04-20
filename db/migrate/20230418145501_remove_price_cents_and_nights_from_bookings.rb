class RemovePriceCentsAndNightsFromBookings < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :price_cents
    remove_column :bookings, :nights
  end
end

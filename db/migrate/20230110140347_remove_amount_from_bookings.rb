class RemoveAmountFromBookings < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :amount_cents
  end
end

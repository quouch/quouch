class AddTravellersToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :number_travellers, :integer
  end
end

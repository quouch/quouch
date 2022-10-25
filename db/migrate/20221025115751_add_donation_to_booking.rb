class AddDonationToBooking < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :donation_amount, :float
  end
end

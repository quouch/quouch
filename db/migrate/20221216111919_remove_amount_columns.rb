class RemoveAmountColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :donation_amount
    remove_column :bookings, :total_amount
  end
end

class RemoveTransactionColumnsFromBookings < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :checkout_session_id
    remove_column :bookings, :payment_status
  end
end

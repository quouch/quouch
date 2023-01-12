class AddPaymentStatus < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :payment_status, :integer
    rename_column :bookings, :status, :booking_status
  end
end

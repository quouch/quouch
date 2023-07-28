class AddPaymentStatus < ActiveRecord::Migration[7.0]
  def change
    rename_column :bookings, :status, :booking_status
  end
end

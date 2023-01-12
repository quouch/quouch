class ChangeStatusInBookings < ActiveRecord::Migration[7.0]
  def change
    rename_column :bookings, :booking_status, :status
  end
end

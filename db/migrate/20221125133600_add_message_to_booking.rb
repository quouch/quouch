class AddMessageToBooking < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :message, :text
  end
end

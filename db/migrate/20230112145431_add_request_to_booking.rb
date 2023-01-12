class AddRequestToBooking < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :request, :integer
  end
end

class AddAmountToBookings < ActiveRecord::Migration[7.0]
  def change
    add_monetize :bookings, :amount, currency: { present: false }
  end
end

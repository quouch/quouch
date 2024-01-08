class DropPaymentsAndBookingPayments < ActiveRecord::Migration[7.0]
  def change
    drop_table :payments
    drop_table :booking_payments
  end
end

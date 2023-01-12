class AddBookingTransactions < ActiveRecord::Migration[7.0]
  def change
    add_reference :booking_transactions, :booking
    add_reference :booking_transactions, :transaction
  end
end

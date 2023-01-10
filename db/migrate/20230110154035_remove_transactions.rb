class RemoveTransactions < ActiveRecord::Migration[7.0]
  def change
    add_reference :booking_payments, :payment
    remove_reference :booking_payments, :transaction
  end
end

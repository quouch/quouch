class RenameTransactionsToPayments < ActiveRecord::Migration[7.0]
  def change
    rename_table :transactions, :payments
    rename_table :booking_transactions, :booking_payments
  end
end

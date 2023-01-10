class ChangeStatusInTransactions < ActiveRecord::Migration[7.0]
  def change
    rename_column :transactions, :payment_status, :status
  end
end

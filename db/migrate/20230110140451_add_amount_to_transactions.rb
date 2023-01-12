class AddAmountToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_monetize :transactions, :amount, currency: { present: false }
  end
end

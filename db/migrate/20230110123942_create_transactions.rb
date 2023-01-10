class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :checkout_session_id
      t.string :payment_intent
      t.integer :payment_status

      t.timestamps
    end
  end
end

class CreateBookingTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_transactions do |t|

      t.timestamps
    end
  end
end

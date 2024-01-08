class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.references :plan, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :active, default: true
      t.string :stripe_id

      t.timestamps
    end
  end
end

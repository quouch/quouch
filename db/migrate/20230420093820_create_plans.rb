class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :description
      t.integer :interval
      t.integer :price_cents
      t.string :stripe_price_id

      t.timestamps
    end
  end
end

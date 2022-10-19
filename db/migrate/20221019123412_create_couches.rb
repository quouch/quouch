class CreateCouches < ActiveRecord::Migration[7.0]
  def change
    create_table :couches do |t|
      t.integer :capacity
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateUserCharacteristics < ActiveRecord::Migration[7.0]
  def change
    create_table :user_characteristics do |t|
      t.references :user, null: false, foreign_key: true
      t.references :characteristic, null: false, foreign_key: true

      t.timestamps
    end
  end
end

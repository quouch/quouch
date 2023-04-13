class RemoveCountryFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_reference :users, :country, null: false, foreign_key: true
    remove_reference :users, :city

    drop_table :cities do |t|
      t.string :name
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end

    drop_table :countries do |t|
      t.string :name

      t.timestamps
    end
    add_column :users, :country, :string
    add_column :users, :city, :string
  end
end

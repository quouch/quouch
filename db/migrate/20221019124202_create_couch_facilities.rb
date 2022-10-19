class CreateCouchFacilities < ActiveRecord::Migration[7.0]
  def change
    create_table :couch_facilities do |t|
      t.references :couch, null: false, foreign_key: true
      t.references :facility, null: false, foreign_key: true

      t.timestamps
    end
  end
end

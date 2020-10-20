class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.integer :capacity, null: false
      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.decimal :longitude, precision: 10, scale: 6, null: false
      t.string  :street, null: false
      t.string  :country, null: false
      t.integer :street_number, null: false
      t.integer :zip_code, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

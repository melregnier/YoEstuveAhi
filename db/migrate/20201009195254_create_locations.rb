class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name
      t.integer :capacity
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitide, precision: 10, scale: 6
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

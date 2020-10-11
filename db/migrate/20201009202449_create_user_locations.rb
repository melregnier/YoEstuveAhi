class CreateUserLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_locations do |t|
      t.timestamp :check_in, null: false
      t.references :user, foreign_key: true
      t.references :location, foreign_key: true
    end
  end
end

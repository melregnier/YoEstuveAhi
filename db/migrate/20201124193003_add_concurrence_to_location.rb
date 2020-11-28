class AddConcurrenceToLocation < ActiveRecord::Migration[5.2]
  def up
    add_column :locations, :concurrence, :integer, null: false, default: 0
    add_column :locations, :external_id, :integer
    add_column :locations, :server_id, :integer, default: 0
    change_column_null :locations, :street, true
    change_column_null :locations, :country, true
    change_column_null :locations, :street_number, true
    change_column_null :locations, :zip_code, true

    Location.all.each do | location |
      location.update_attributes!(:external_id => location.id)
      location.update_attributes!(:concurrence => location.user_locations.count)
    end
  end
  
  def down
    remove_column :locations, :concurrence, :integer
    remove_column :locations, :external_id, :integer
    remove_column :locations, :server_id, :integer
    change_column_null :locations, :street, false
    change_column_null :locations, :country, false
    change_column_null :locations, :street_number, false
    change_column_null :locations, :zip_code, false
  end
end

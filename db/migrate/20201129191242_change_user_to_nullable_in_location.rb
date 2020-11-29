class ChangeUserToNullableInLocation < ActiveRecord::Migration[5.2]
  def change
    change_column_null :locations, :user_id, true
  end
end

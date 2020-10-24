class CreateUserNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :user_notifications do |t|
      t.string :message, null: false
      t.references :user, foreign_key: true
      t.timestamp :created_at
    end
  end
end

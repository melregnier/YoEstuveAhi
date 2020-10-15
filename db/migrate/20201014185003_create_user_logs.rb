class CreateUserLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :user_logs do |t|
      t.timestamp :created_at
      t.string :to_state
      t.references :user, foreign_key: true
    end
  end
end

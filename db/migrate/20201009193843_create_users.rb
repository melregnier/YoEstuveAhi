class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :document_type, null: false
      t.integer :document_number, null:false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.string :state, default: 'healthy'
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :document_type
      t.integer :document_number
      t.string :email
      t.string :password
      t.string :status, default: 'healthy'

      t.timestamps
    end
  end
end

class CreateCovidTests < ActiveRecord::Migration[5.2]
  def change
    create_table :covid_tests do |t|
      t.date :date, null: false
      t.boolean :result, null: false
      t.references :user, foreign_key: true
    end
  end
end

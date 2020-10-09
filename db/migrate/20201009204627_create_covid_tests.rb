class CreateCovidTests < ActiveRecord::Migration[5.2]
  def change
    create_table :covid_tests do |t|
      t.date :date
      t.boolean :result
      t.references :user, foreign_key: true
    end
  end
end

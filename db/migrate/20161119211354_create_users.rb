class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, foreign_key: true
      t.string :password, null: false
    end
  end
end

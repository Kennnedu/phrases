class CreateHistory < ActiveRecord::Migration[5.0]
  def change
    create_table :histories do |t|
      t.belongs_to :user, index: true
      t.belongs_to :phrase, index: true

      t.timestamps null: false
    end
  end
end

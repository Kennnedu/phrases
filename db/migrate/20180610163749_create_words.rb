class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.belongs_to :user, index: true, null: false
      t.belongs_to :phrase, index: true, null: false
      t.string :word, null: false
      t.string :previous_phrase, null: false

      t.timestamps null: false
    end
  end
end

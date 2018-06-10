class RemoveHistory < ActiveRecord::Migration[5.2]
  def change
    drop_table :histories
  end
end

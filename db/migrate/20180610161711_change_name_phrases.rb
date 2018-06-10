class ChangeNamePhrases < ActiveRecord::Migration[5.2]
  def change
    rename_column :phrases, :name, :current_state
  end
end

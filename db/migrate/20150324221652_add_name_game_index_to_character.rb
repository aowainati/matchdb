class AddNameGameIndexToCharacter < ActiveRecord::Migration
  def change
    add_index :characters, [:name, :game_id], unique:true
  end
end

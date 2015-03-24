class AddAliasesToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :aliases, :string, array: true
  end
end

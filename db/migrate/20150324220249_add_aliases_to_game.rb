class AddAliasesToGame < ActiveRecord::Migration
  def change
    add_column :games, :aliases, :string, array: true
  end
end

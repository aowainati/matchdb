class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :title
      t.text :desc
      t.references :event, index: true
      t.references :game, index: true
      t.json :data

      t.timestamps null: false
    end
    add_foreign_key :matches, :events
    add_foreign_key :matches, :games
  end
end

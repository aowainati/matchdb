class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.daterange :duration

      t.timestamps null: false
    end
  end
end

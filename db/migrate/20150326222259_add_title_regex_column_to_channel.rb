class AddTitleRegexColumnToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :title_regex, :text
  end
end

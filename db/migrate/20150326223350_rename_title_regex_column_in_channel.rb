class RenameTitleRegexColumnInChannel < ActiveRecord::Migration
  def change
    rename_column :channels, :title_regex, :title_regex_yaml
  end
end

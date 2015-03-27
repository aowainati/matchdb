class RenameDescToUrlInMatch < ActiveRecord::Migration
  def change
    rename_column :matches, :desc, :url
  end
end

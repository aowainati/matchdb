class RenameUrlToYoutubeIdInMatch < ActiveRecord::Migration
  def change
    rename_column :matches, :url, :youtube_id
  end
end

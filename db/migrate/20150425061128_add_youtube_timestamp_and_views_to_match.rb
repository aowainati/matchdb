class AddYoutubeTimestampAndViewsToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :youtube_views, :bigint
    add_column :matches, :youtube_timestamp, :datetime
  end
end

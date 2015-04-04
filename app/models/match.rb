class Match < ActiveRecord::Base
  belongs_to :event
  belongs_to :game
  belongs_to :channel

  validates :title, :youtube_id, :game, :data, presence: true

  def youtube_thumb
    "http://i.ytimg.com/vi_webp/%s/mqdefault.webp" % youtube_id
  end
end

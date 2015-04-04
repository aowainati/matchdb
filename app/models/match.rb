class Match < ActiveRecord::Base
  belongs_to :event
  belongs_to :game
  belongs_to :channel

  validates :title, :youtube_id, :game, :data, presence: true

  def youtube_thumb
    "https://i.ytimg.com/vi/%s/mqdefault.jpg" % youtube_id
  end

  def youtube_url
    "http://www.youtube.com/watch?v=%s" % youtube_id
  end
end

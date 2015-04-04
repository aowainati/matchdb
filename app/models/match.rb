class Match < ActiveRecord::Base
  belongs_to :event
  belongs_to :game
  belongs_to :channel

  validates :title, :youtube_id, :game, :data, presence: true
end

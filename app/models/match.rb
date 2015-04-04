class Match < ActiveRecord::Base
  belongs_to :event
  belongs_to :game
  belongs_to :channel

  # TODO : Rename 'url' to 'youtube-id'
  validates :title, :url, :game, :data, presence: true
end

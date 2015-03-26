class Match < ActiveRecord::Base
  belongs_to :event
  belongs_to :game
  belongs_to :channel

  # TODO: Rename 'desc' to 'match_url', and make unique
  validates :title, :desc, :game, :data, presence: true
end

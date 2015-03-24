class Match < ActiveRecord::Base
  belongs_to :event
  belongs_to :game

  validates :title, :desc, :event, :game, :data, presence: true
end

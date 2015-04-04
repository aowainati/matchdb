class Character < ActiveRecord::Base
  belongs_to :game

  validates :name, presence: true, length: { minimum: 1 }
  validates :game, :aliases, presence: true

  # TODO : Add sort parameters for this method
  # TODO : Add pagination for this method
  def matches
    Match.where(game: game).where("data->>'c1' IN (?) OR data->>'c2' IN (?)", aliases, aliases)
  end
end

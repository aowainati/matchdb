class Game < ActiveRecord::Base
  has_many :characters
  has_many :matches
  has_many :events, through: :matches
end

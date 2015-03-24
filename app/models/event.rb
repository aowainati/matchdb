class Event < ActiveRecord::Base
  has_many :matches
  has_many :games, through: :matches
end

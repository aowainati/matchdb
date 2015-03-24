class Character < ActiveRecord::Base
  belongs_to :game

  validates :name, presence: true, length: { minimum: 1 }
end

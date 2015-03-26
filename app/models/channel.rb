class Channel < ActiveRecord::Base
  has_many :matches

  validates :name, presence: true
end

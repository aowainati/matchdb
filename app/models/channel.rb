class Channel < ActiveRecord::Base
  has_many :matches

  validates :name, :title_regex_yaml, presence: true
  # TODO : Add custom validation here to ensure title_regex has the correct data: c1/2, p1/2, game, etc.

  def title_regex
    YAML::load(self.title_regex_yaml)
  end
end

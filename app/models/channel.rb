class Channel < ActiveRecord::Base
  has_many :matches

  validates :name, presence: true

  def title_regex
    YAML::load(self.title_regex_yaml)
  end
end

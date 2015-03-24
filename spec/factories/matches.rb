require 'json'

FactoryGirl.define do
  factory :match do |f|
    f.title "Match 1234"
    f.desc "This is a match and it's really great."
    f.event { build(:event) }
    f.game { build(:game) }
    f.data { [ [ [12, 1], [13, 2] ] ] } # TODO : Replace this with a Match datax object emitted to JSON
  end
end

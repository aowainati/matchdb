require 'json'

FactoryGirl.define do
  factory :match do |f|
    f.title "Match 1234"
    f.url "This is a match and it's really great."
    f.event { build(:event) }
    f.game { build(:game) }
    f.data {{ "P1" => "C1", "P2" => "C2" }} # TODO: Make value an array
  end
end

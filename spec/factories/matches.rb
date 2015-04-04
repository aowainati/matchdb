require 'json'

FactoryGirl.define do
  factory :match do |f|
    f.title "Match 1234"
    f.youtube_id "abcd1234"
    f.event { build(:event) }
    f.game { build(:game) }
    f.data {{ "p1" => "player1",
              "p2" => "player2",
              "c1" => "character1",
              "c2" => "character2" }}
  end
end

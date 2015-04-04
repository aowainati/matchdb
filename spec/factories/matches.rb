require 'json'

FactoryGirl.define do
  factory :match do |f|
    f.title "Match 1234"
    f.youtube_id "abcd1234"
    f.event { build(:event) }
    f.game { build(:game) }
    f.data {{ "P1" => "C1", "P2" => "C2" }} # TODO: Make value an array
  end
end

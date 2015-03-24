FactoryGirl.define do
  factory :character do |f|
    f.name "Skullomania"
    f.game { build(:game) }
  end
end

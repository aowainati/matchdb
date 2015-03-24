FactoryGirl.define do
  factory :event do |f|
    f.name "Super Awesome Event 17"
    f.duration { [15.days.ago..12.days.ago] }
  end
end

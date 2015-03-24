FactoryGirl.define do
  factory :event do |f|
    f.name "Super Awesome Event 17"
    f.duration { 15.days.ago.to_datetime..12.days.ago.to_datetime }
  end
end

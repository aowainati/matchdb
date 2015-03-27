FactoryGirl.define do
  factory :channel do |f|
    f.name "teamawesome"
    f.desc "Team Awesome Streaming Duders"
    f.title_regex_yaml "--- !ruby/regexp /(?<p1>[a-z0-9 ]+)\\((?<c1>[a-z0-9 ]+)\\)\\s+vs\\s+(?<p2>[a-z0-9 ]+)\\((?<c2>[a-z0-9\n  ]+)\\)\\s+(?<game>[a-z0-9]+)/i\n...\n"
  end
end

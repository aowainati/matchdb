require 'rails_helper'

RSpec.describe Character, :type => :model do
  it_behaves_like "it has a factory"

  it "is invalid without a name" do
    expect(build(:character, name: nil)).to_not be_valid
  end

  it "is invalid without a name of at least length 1" do
    expect(build(:character, name: "")).to_not be_valid
  end

  it "is invalid without a game" do
    expect(build(:character, game: nil)).to_not be_valid
  end
end

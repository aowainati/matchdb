shared_examples "it has a factory" do
  it "has a valid factory" do
    expect(create(described_class)).to be_valid
  end
end

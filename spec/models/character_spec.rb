require 'rails_helper'

RSpec.describe Character, :type => :model do
  it_behaves_like "it has a factory"

  context 'when a game exists' do
    before(:all) { create(:game) }
    after(:all) { Game.destroy_all } # TODO : Abstract this context out, re-used by scraper

    describe '#matches' do
      # TODO : Fill these in, you bastard
      it 'only returns matches belonging to the character'

      it 'can return matches where only the alias matches'
    end
  end
end

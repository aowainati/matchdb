# -*- coding: utf-8 -*-
require 'rails_helper'
require 'scraper'

RSpec.describe Scraper do
  before(:all) { create(:game) }
  after(:all) { Game.destroy_all }

  # TODO : Abstract this to a factory or fixture? Matches with default Channel factory
  let(:dummy_fragment) {
    Nokogiri::HTML(File.open("spec/test_data/channel_page.html"))
  }
  let(:next_page_json) {
    File.open("spec/test_data/channel_next_page.json")
  }
  let(:dummy_element) { Nokogiri::HTML.fragment("<a class=\"yt-uix-sessionlink yt-uix-tile-link  spf-link  yt-ui-ellipsis yt-ui-ellipsis-2\" dir=\"ltr\" title=\"xWAx Vortex ( Guile ) Vs BRONXPUERTOROCK ( Akuma )  CGF 1080p - 60fps \" aria-describedby=\"description-id-742665\" data-sessionlink=\"ei=0McVVdPKLOSv-APq0IC4Dg&amp;feature=c4-videos-u&amp;ved=CB8Qvxs\" href=\"/watch?v=3UH8yK-SVKg\">xWAx Vortex ( Guile ) Vs BRONXPUERTOROCK ( Akuma )  CGF 1080p - 60fps </a>").children.first } 
  let(:dummy_element_invalid) { Nokogiri::HTML.fragment("<a class=\"yt-uix-sessionlink yt-uix-tile-link  spf-link  yt-ui-ellipsis yt-ui-ellipsis-2\" dir=\"ltr\" title=\"This Title IS Invalid\" aria-describedby=\"description-id-742665\" data-sessionlink=\"ei=0McVVdPKLOSv-APq0IC4Dg&amp;feature=c4-videos-u&amp;ved=CB8Qvxs\" href=\"/watch?v=3UH8yK-SVKg\">This Title IS Invalid</a>").children.first }
  let(:game) { Game.first }
  let(:channel) { build(:channel) }
  let(:scraper) { Scraper.new(channel) }

  describe '#create_matches_from_fragment!' do
    it 'creates correct number of matches from fragment' do
      allow(Game).to receive(:where) { double("GameRelation", take: game) }
      scraper.create_matches_from_fragment!(dummy_fragment, "foo", iterations=1)
      expect(Match.count).to eq(30)
    end
    
    it 'recurses the correct number of iterations' do
      allow(scraper).to receive(:open) { double }
      allow(scraper).to receive(:fragment_from_json) { dummy_fragment }
      allow(scraper).to receive(:next_page_url_from_fragment) { "foo" }

      expect(scraper).to receive(:create_matches_from_fragment!).and_call_original.exactly(5).times
      scraper.create_matches_from_fragment!(dummy_fragment, "foo", iterations=5)
    end
  end

  describe '#elements_from_fragment' do
    it 'returns a collection of "a" elements' do
      elements = scraper.elements_from_fragment(dummy_fragment)
      expect(elements.count).to eq(30)
      elements.each do |e|
        expect(e.name).to eq("a")
      end
    end

    it 'returns a collection of "a" elements from an AJAX response' do
      elements = scraper.elements_from_fragment(scraper.fragment_from_json(next_page_json))
      expect(elements.count).to eq(30)
      elements.each do |e|
        expect(e.name).to eq("a")
      end
    end
  end

  describe '#next_page_url_from_fragment' do
    it 'returns a valid url of the form "browse_ajax?..."' do
      url = scraper.next_page_url_from_fragment(dummy_fragment)
      expect(url).to match(/browse_ajax\?/)
    end

    it 'returns a valid url of the form "browse_ajax?..." from an AJAX response' do
      url = scraper.next_page_url_from_fragment(scraper.fragment_from_json(next_page_json))
      expect(url).to match(/browse_ajax\?/)
    end
  end

  describe '#match_from_element_and_channel' do
    it 'constructs a match object from a valid element and channel' do
      match = scraper.match_from_element_and_channel(dummy_element)
      expect(match.title).to eq("xWAx Vortex ( Guile ) Vs BRONXPUERTOROCK ( Akuma )  CGF 1080p - 60fps ")
      expect(match.url).to eq("https://www.youtube.com/watch?v=3UH8yK-SVKg")
      expect(match.game).to eq(Game.first)
      expect(match.event).to be_nil # TODO : Add 'Event' capability later
      expect(match.channel).to eq(channel)
      expect(match.data).to eq({"xWAx Vortex" => "Guile", "BRONXPUERTOROCK" => "Akuma"})
    end

    it 'returns nil from an element with an invalid game' do
      allow(Game).to receive(:where) { double("GameRelation", take: nil) }
      match = scraper.match_from_element_and_channel(dummy_element)
      expect(match).to be_nil
    end

    it 'returns nil from an element with invalid title format' do
      match = scraper.match_from_element_and_channel(dummy_element_invalid)
      expect(match).to be_nil
    end
  end

end

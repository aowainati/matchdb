# -*- coding: utf-8 -*-
require 'rails_helper'
require 'scraper'

RSpec.describe Scraper do
  before(:each) { game = create(:game) }

  let(:dummy_element) { Nokogiri::XML.fragment("<a class=\"yt-uix-sessionlink yt-uix-tile-link  spf-link  yt-ui-ellipsis yt-ui-ellipsis-2\" dir=\"ltr\" title=\"xWAx Vortex ( Guile ) Vs BRONXPUERTOROCK ( Akuma )  CGF 1080p - 60fps \" aria-describedby=\"description-id-742665\" data-sessionlink=\"ei=0McVVdPKLOSv-APq0IC4Dg&amp;feature=c4-videos-u&amp;ved=CB8Qvxs\" href=\"/watch?v=3UH8yK-SVKg\">xWAx Vortex ( Guile ) Vs BRONXPUERTOROCK ( Akuma )  CGF 1080p - 60fps </a>").children.first } # TODO : Abstract this to a factory? Matches with default Channel factory
  let(:dummy_element_invalid) { Nokogiri::XML.fragment("<a class=\"yt-uix-sessionlink yt-uix-tile-link  spf-link  yt-ui-ellipsis yt-ui-ellipsis-2\" dir=\"ltr\" title=\"This Title IS Invalid\" aria-describedby=\"description-id-742665\" data-sessionlink=\"ei=0McVVdPKLOSv-APq0IC4Dg&amp;feature=c4-videos-u&amp;ved=CB8Qvxs\" href=\"/watch?v=3UH8yK-SVKg\">This Title IS Invalid</a>").children.first }
  let(:channel) { build(:channel) }
  let(:scraper) { Scraper.new }

  describe '#match_from_element_and_channel' do
    it 'constructs a match object from a valid element and channel' do
      match = scraper.match_from_element_and_channel(dummy_element, channel)
      expect(match.title).to eq("xWAx Vortex ( Guile ) Vs BRONXPUERTOROCK ( Akuma )  CGF 1080p - 60fps ")
      expect(match.url).to eq("https://www.youtube.com/watch?v=3UH8yK-SVKg")
      expect(match.game).to eq(Game.first)
      expect(match.event).to be_nil # TODO : Add 'Event' capability later
      expect(match.channel).to eq(channel)
      expect(match.data).to eq({"xWAx Vortex" => "Guile", "BRONXPUERTOROCK" => "Akuma"})
    end

    it 'returns nil from an element with invalid title format' do
      match = scraper.match_from_element_and_channel(dummy_element_invalid, channel)
      expect(match).to be_nil
    end
  end
end

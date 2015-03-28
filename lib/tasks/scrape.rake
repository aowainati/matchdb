require 'scraper'

namespace :scrape do
  desc "Scrapes the latest videos from all channels."
  task :run => :environment do
    Scraper.run
  end
end

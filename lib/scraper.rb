require 'open-uri'

class Scraper
  @@base_youtube_domain = "https://www.youtube.com"
  @@base_youtube_channel = @@base_youtube_domain + "/user/%s/videos"
  @@base_youtube_video = @@base_youtube_domain + "%s"

  def self.run
    # Fetch initial channel content
    Channel.all.each do |channel|
      Scraper.new(channel).scrape_channel!
    end
  end

  def initialize(channel)
    @channel = channel
  end

  def scrape_channel!
    url = @@base_youtube_channel % @channel.name
    initial_fragment = Nokogiri::HTML(open(url)) # TODO : Abstract this into a retriable form
    create_matches_from_fragment!(initial_fragment, next_page_url_from_fragment(initial_fragment))
  end

  def create_matches_from_fragment!(fragment, next_page_url, iterations=20)
    elements_from_fragment(fragment).each do |element|
      match = match_from_element_and_channel(element)
      if match
        match.save
        Rails.logger.info("[Scraper] Successfully made match object: #{match.inspect}") # TODO : Only if new object actually created
      end
#      match.save if match
    end

    if iterations > 1
      next_fragment = fragment_from_json(open(next_page_url))
      create_matches_from_fragment!(next_fragment,
                                    next_page_url_from_fragment(next_fragment),
                                    iterations=iterations-1)
    end
  end

  def fragment_from_json(json)
    obj = JSON::load(json)
    # Concatenate the two components because why not?
    Nokogiri::HTML(obj["content_html"] + obj["load_more_widget_html"])
  end

  def elements_from_fragment(fragment)
    fragment.css(".yt-lockup-title > a")
  end

  def next_page_url_from_fragment(fragment)
    @@base_youtube_domain + 
      fragment.css(".browse-items-load-more-button").first.attributes["data-uix-load-more-href"].value
  end

  def match_from_element_and_channel(element)
    attributes = element.attributes

    match_title = attributes["title"].content

    parsed_data = @channel.title_regex.match(match_title)

    match_obj = nil
    if parsed_data
      game = Game.where("? = ANY (aliases)", parsed_data["game"].strip).take

      # TODO : Make this more robust
      # Invariant: There will always be exactly 2 players
      #            Each player will have one or more characters
      #            Impossible to know exactly which chars played against which if multiple chars selected
      player_char_data = {
        parsed_data["p1"].strip => parsed_data["c1"].strip, # TODO: Make value an array
        parsed_data["p2"].strip => parsed_data["c2"].strip
      }

      # TODO : Construct player objects if necessary
      # TODO : Validate character data with character table

      if game
        match_obj = Match.find_or_initialize_by(title: match_title,
                                                url: @@base_youtube_video % attributes["href"].content,
                                                game: game,
                                                event: nil, # TODO
                                                channel: @channel)
        match_obj.data = player_char_data
        match_obj
      else
        Rails.logger.warn("[Scraper] Couldn't find game #{parsed_data['game']}")
        nil
      end
    else
      # TODO : MAKE THIS LOGGING LOUDER, E-MAIL NOTIFICATION?
      Rails.logger.warn("[Scraper] Video did not match regex format, data dump: #{match_title}")
      nil
    end
  end
end

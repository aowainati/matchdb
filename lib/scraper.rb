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
    Rails.logger.info("[Scraper] Beginning to scrape #{@channel.name} now!")
    url = @@base_youtube_channel % @channel.name
    initial_fragment = Nokogiri::HTML(open_url(url))
    create_matches_from_fragment!(initial_fragment, next_page_url_from_fragment(initial_fragment))
  end

  def create_matches_from_fragment!(fragment, next_page_url, iterations=75)
    if !next_page_url
      Rails.logger.info("[Scraper] All out of videos for channel #{@channel.name}, finishing scrape.")
      return
    end

    elements_from_fragment(fragment).each do |element|
      match = match_from_element(element)
      if match
        Rails.logger.info("[Scraper] Successfully made match object: #{match.inspect}") if !match.persisted?
        match.save
      end
    end

    if iterations > 1
      next_fragment = fragment_from_json(open_url(next_page_url))
      create_matches_from_fragment!(next_fragment,
                                    next_page_url_from_fragment(next_fragment),
                                    iterations=iterations-1)
    end
  end

  def open_url(url)
    with_retries(max_tries: 3) do |i|
      open(url)
    end
  end

  def fragment_from_json(json)
    obj = JSON::load(json)
    # Concatenate the two components because why not?
    Nokogiri::HTML(obj["content_html"] + obj["load_more_widget_html"])
  end

  def youtube_id_from_url(url)
    (/\?v=(?<id>.+)/).match(url)["id"]
  end

  def elements_from_fragment(fragment)
    fragment.css(".yt-lockup-content")
  end

  def a_tag_from_element(fragment)
    fragment.css(".yt-lockup-title > a")
  end

  def timestamp_from_element(element)
    Chronic.parse(element.css(".yt-lockup-meta-info > li")[1].content)
  end

  def views_from_element(element)
    element.css(".yt-lockup-meta-info > li")[0].content.split().first.delete(',').to_i
  end

  def next_page_url_from_fragment(fragment)
    load_more_button = fragment.css(".browse-items-load-more-button").first
    if load_more_button
      @@base_youtube_domain +
        load_more_button.attributes["data-uix-load-more-href"].value
    else
      nil
    end
  end

  def match_from_element(element)
    attributes = a_tag_from_element(element).first.attributes

    match_title = attributes["title"].content

    parsed_data = @channel.title_regex.match(match_title)

    match_obj = nil
    if parsed_data
      game = Game.where("? = ANY (aliases)", parsed_data["game"].strip).take

      # TODO : Make this more robust
      # TODO : Make this work for multiple characters
      # Invariant: There will always be exactly 2 players
      #            Each player will have one or more characters
      #            Impossible to know exactly which chars played against which if multiple chars selected
      player_char_data = {
        "p1" => parsed_data["p1"].strip,
        "p2" => parsed_data["p2"].strip,
        "c1" => parsed_data["c1"].strip,
        "c2" => parsed_data["c2"].strip
      }

      # TODO : Construct player objects if necessary
      # TODO : Validate character data with character table

      if game
        youtube_id = youtube_id_from_url(attributes["href"].content)
        match_obj = Match.find_or_initialize_by(youtube_id: youtube_id)
        match_obj.assign_attributes(title: match_title,
                                    youtube_timestamp: timestamp_from_element(element),
                                    youtube_views: views_from_element(element),
                                    game: game,
                                    event: nil, # TODO
                                    channel: @channel,
                                    data: player_char_data)
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

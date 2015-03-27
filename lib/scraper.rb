require 'open-uri'

class Scraper
  @@base_youtube_channel = "https://www.youtube.com/user/%s/videos"
  @@base_youtube_video = "https://www.youtube.com%s"

  def run
    # Fetch initial channel content
    channels = Channel.all

    channels.each do |channel|
      url = @@base_youtube_channel % channel.name
      initial_doc = Nokogiri::HTML(open(url))

      initial_doc.css(".yt-lockup-title > a").each do |element|
        match = match_from_element_and_channel(element, channel)
        match.save if match
      end

    end

  end

  def match_from_element_and_channel(element, channel)
    attributes = element.attributes

    match_title = attributes["title"].content

    parsed_data = channel.title_regex.match(match_title)

    match_obj = nil
    if parsed_data
      game = Game.where("? = ANY (aliases)", parsed_data["game"])

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
                                                game: game.take,
                                                event: nil, # TODO
                                                channel: channel)
        match_obj.data = player_char_data
        match_obj
      else
        nil
      end
    else
      # TODO : MAKE THIS LOGGING LOUDER, E-MAIL NOTIFICATION?
      Rails.logger.warn("[Scraper] Video did not match regex format, data dump: #{match_title}")
      nil
    end
  end
end

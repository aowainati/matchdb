# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Utility for converting Ruby arrays into Postgres arrays
def convert_arr_to_pg(arr)
  '{' + arr.join(",") + '}'
end

creation_logger = Proc.new do |thing|
  Rails.logger.info("[Scraper] Couldn't find #{thing} in DB, created a new one.")
end

GAMES_TO_ALIASES = {
  "Ultra Street Fighter 4" => ["Ultra Street Fighter 4","Ultra Street Fighter IV","USF4","USFIV"],
  "Ultimate Marvel vs. Capcom 3" => ["Ultimate Marvel vs. Capcom 3","UMVC3"],
  "Super Smash Brothers Melee" => ["Melee","SSBM"]
}

GAMES_TO_ALIASES.each do |g, a|
  Game.find_or_create_by(name: g, aliases: convert_arr_to_pg(a), &creation_logger)
end

GAMES_TO_CHARACTERS = {
  "USF4" => ["Abel",
             "Adon",
             "Akuma",
             "Balrog",
             "Blanka",
             "C.Viper",
             "Cammy",
             "Chun-Li",
             "Cody",
             "Dan",
             "Decapre",
             "Dee Jay",
             "Dhalsim",
             "Dudley",
             "E.Honda",
             "El Fuerte",
             "Elena",
             "Evil Ryu",
             "Fei Long",
             "Gen",
             "Gouken",
             "Guile",
             "Guy",
             "Hakan",
             "Hugo",
             "Ibuki",
             "Juri",
             "Ken",
             "M.Bison",
             "Makoto",
             "Oni",
             "Poison",
             "Rolento",
             "Rose",
             "Rufus",
             "Ryu",
             "Sagat",
             "Sakura",
             "Seth",
             "T.Hawk",
             "Vega",
             "Yang",
             "Yun",
             "Zangief"],
  "UMVC3" => ["Akuma",
              "Amaterasu",
              "Arthur",
              "C. Viper",
              "Chris",
              "Chun Li",
              "Dante",
              "Felicia",
              "Firebrand",
              "Frank West",
              "Haggar",
              "Hsien Ko",
              "Jill",
              "Morrigan",
              "Nemesis",
              "Phoenix Wright",
              "Ryu",
              "Spencer",
              "Strider",
              "Trish",
              "Tron Bonne",
              "Vergil",
              "Viewtiful Joe",
              "Wesker",
              "Zero",
              "Captain America",
              "Deadpool",
              "Doctor Doom",
              "Doctor Strange",
              "Dormammu",
              "Ghost Rider",
              "Hawkeye",
              "Hulk",
              "Iron Fist",
              "Iron Man",
              "Magneto",
              "M.O.D.O.K.",
              "Nova",
              "Phoenix",
              "Rocket Raccoon",
              "Sentinel",
              "She-Hulk",
              "Shuma-Gorath",
              "Spider-Man",
              "Storm",
              "Super-Skrull",
              "Taskmaster",
              "Thor",
              "Wolverine",
              "X-23"],
  "SSBM" => ["Bowser",
             "Captain Falcon",
             "Dr. Mario",
             "Donkey Kong",
             "Falco",
             "Fox",
             "Ganondorf",
             "Ice Climbers",
             "Jigglypuff",
             "Kirby",
             "Link",
             "Luigi",
             "Mario",
             "Marth",
             "Mewtwo",
             "Mr. Game and Watch",
             "Ness",
             "Peach",
             "Pichu",
             "Pikachu",
             "Roy",
             "Samus",
             "Sheik",
             "Yoshi",
             "Young Link",
             "Zelda"]
}

CHARACTER_ALIASES = {
  "USF4" => {
    "M.Bison" => ["Dictator", "M. Bison"],
    "Vega" => ["Claw"],
    "Balrog" => ["Boxer"]
  }
}

GAMES_TO_CHARACTERS.each do |game_name, char_list|
  game = Game.where("'#{game_name}' = ANY (aliases)").take
  char_list.each do |char_name|
    aliases = [char_name]

    game_aliases = CHARACTER_ALIASES[game_name]
    if game_aliases
      aliases.concat(game_aliases[char_name] || [])
    end

    Character.find_or_create_by(name: char_name, game: game, aliases: convert_arr_to_pg(aliases), &creation_logger)
  end
end

CHANNEL_NAME_TO_DESCRIPTION = {
  "YogaFlame24" => "YogaFlame24"
}

CHANNEL_NAME_TO_DESCRIPTION.each do |name, desc|
  Channel.find_or_create_by(name: name, desc: desc, &creation_logger)
end

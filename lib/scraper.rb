require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  @@scraped_props = []
  @@team_urls = []

  def self.get_page
    site = "http://streak.espn.com/en/?date=20170707"
    @doc = Nokogiri::HTML(open(site))
    prop_num = @doc.css("div.matchupDate").size
    away_teams = []
    home_teams = []

    @doc.css("div #games-content tr td.mg-column3.opponents").each_with_index do |x, i|

      #following addresses NilClass error if a prop has already started:
      team_url = site + "#{@doc.css("td a#matchupDiv.mg-check.mg-checkEmpty.requireLogin")[i].attr("href")}"
      if i.even?
        away_teams << x.text
      else
        home_teams << x.text
      end
      @@team_urls << team_url
    end

    i = 0
    while i < prop_num
      event = @doc.css("div.matchup-container div.gamequestion strong")[i].text
      start = @doc.css("div.matchupDate")[i].text
      sport = @doc.css("div.sport-description")[i].text
      prop_preview = @doc.css("div.matchupStatus a")[i].attr("href")
      prop = {
        event_title: event,
        start_time: start,
        sport: sport,
        away_team: away_teams[i],
        home_team: home_teams[i],
        prop_preview: prop_preview,
        away_team_url: "",
        home_team_url: ""
      }

        @@scraped_props << prop
    i+=1
    end
  end

  def self.all_props
    @@scraped_props
  end

  def self.all_team_urls
    @@team_urls
  end
end

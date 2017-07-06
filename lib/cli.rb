require 'pry'
require 'colorize'

class Cli

  def run
    Scraper.get_page
    Scraper.build_props
    props_hash = Scraper.all_props
    Prop.generate_props_by_hash(props_hash)
    self.welcome
  end

  def welcome
    puts "----------------------------------------------".colorize(:green)
    puts "     Welcome to the DailyStreak Front Page".colorize(:green)
    puts "----------------------------------------------".colorize(:green)
    puts "Here are the Streak props for today..."
    puts ""
    binding.pry
  end













end

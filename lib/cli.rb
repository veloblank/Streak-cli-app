class Cli
  @@user_selections = []

  def run
    Scraper.scrape_props
    welcome
    print_all_props
    menu
  end

  def welcome
    print "\e[2J\e[f"
    puts ""
    puts "----------------------------------------------".colorize(:green)
    puts "     Welcome to the DailyStreak Front Page".colorize(:green)
    puts "----------------------------------------------".colorize(:green)
    puts "Here are the #{Prop.all_props.count} Streak props for today..."
    puts ""
    puts ""
    puts ""
  end

  def print_all_props
    Prop.all_props.each do |prop|
      puts "#{prop.title}".colorize(:red)
      puts "#{prop.prop_id}. ".colorize(:green) + "#{prop.start}   " + "#{prop.sport}   " + "#{prop.away}   " + " vs. " + "   #{prop.home}"
      puts ""
    end
  end

  def print_prop(prop_array)
    prop_array.each do |prop|
      puts "#{prop.title}".colorize(:red)
      puts "#{prop.prop_id}. ".colorize(:green) + "#{prop.start}   " + "#{prop.sport}   " + "#{prop.away}   " + " vs. " + "   #{prop.home}"
      puts ""
    end
    menu
  end

  def menu
    input = ""
    puts "Type 'home' to return to the main prop list"
    puts "Type 'list' to see a list of your pending picks"
    puts "Use 'search by sport' to filter by sport"
    puts "Choose a number of a prop you want to see more about"
    puts "Or type 'exit'"
    input = gets.strip.downcase
    menu if input.to_i > Prop.all_props.size
    case input
    when "home"
      run
    when "exit"
      exit
    when 'list'
      user_selections
    when 'search by sport'
      puts "Input sport: "
      input = gets.strip
      events = Prop.props_by_sport(input)
      puts "==================#{events.length} #{input} Props=================="
      print_prop(events)
    else
      input = input.to_i
      prop = Prop.all_props.slice(input-1)
      puts ""
      puts "More info on:"
      puts "#{prop.title}".colorize(:red)
      puts "#{prop.prop_id}. ".colorize(:green) + "#{prop.start}   " + "#{prop.sport}   " + "#{prop.away}   " + " vs. " + "   #{prop.home}"
      puts prop.matchup_status.colorize(:red)
      puts ""
      puts "1. Read Matchup Preview/Check Score"
      puts ""
      puts "2. Insta-pick Away Team: " + "#{prop.away}".colorize(:green)
      puts "3. Insta-pick Home Team: " + "#{prop.home}".colorize(:green)
      puts ""
      puts "4. Save Away Team in Prop List"
      puts "5. Save Home Team in Prop List"
      puts ""
      prop_menu_input = ""
      while prop_menu_input != 'exit'
        puts "Press Enter to go back or type 'exit' to exit the program"
        prop_menu_input = gets.chomp
        case prop_menu_input
        when "1"
          Launchy.open("#{prop.prop_preview}")
          run
        when "2"
          Launchy.open("#{prop.away_team_url}")
          run
        when "3"
          Launchy.open("#{prop.home_team_url}")
          run
        when "4"
          puts "Choose time (hhmmss) to make pick:"
          choose_time = gets.strip
          user_prop_choice = {
            prop_id: prop.prop_id,
            title: prop.title,
            start:  prop.start,
            sport: prop.sport,
            selection: prop.away,
            prop_preview: prop.prop_preview,
            selection_url: prop.away_team_url,
            matchup_status: prop.matchup_status,
            automate_pick_time: choose_time
          }
          @@user_selections << user_prop_choice
          puts "Saved!"
        when "5"
          puts "Choose time (hhmmss) to make pick:"
          choose_time = gets.strip
          user_prop_choice = {
            prop_id: prop.prop_id,
            title: prop.title,
            start:  prop.start,
            sport: prop.sport,
            selection: prop.home,
            prop_preview: prop.prop_preview,
            selection_url: prop.home_team_url,
            matchup_status: prop.matchup_status,
            automate_pick_time: choose_time
          }
          @@user_selections << user_prop_choice
          puts "Saved!"
        else
          run
        end
      end
    end
  end

  def user_selections
    if @@user_selections.empty? == true
      puts ""
      puts "Your Prop List is empty.".colorize(:red)
      puts ""
      menu
    else
      sorted_list = @@user_selections.sort {|a,b| a[:automate_pick_time] <=> b[:automate_pick_time]}
      puts ""
      sorted_list.each do |pick|
        puts "#{pick[:prop_id]}. " + "#{pick[:start]} ".colorize(:red) + " #{pick[:selection]}".colorize(:red) + " Pick Time: ".colorize(:yellow) + "#{pick[:automate_pick_time]}".colorize(:yellow)
        puts""
      end
    menu
    end
  end
end

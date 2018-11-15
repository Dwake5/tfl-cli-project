class CommandLineInterface

  def run
   greet
   intro
   menu_setting
  end

  def greet
    hello = Artii::Base.new :font => 'slant'
    puts hello.asciify("Mind the Gap")
    55.times do print "\u{1F687} " end
    puts ""
  end

   def intro
     puts "Select a number from 1 - 9"
     puts "---------------------------"
     puts Rainbow("1|").blue.bright + " What stations are on a **Tube Line**?"
     puts Rainbow("2|").blue.bright + " What lines does a **Tube Station** belong to?"
     puts Rainbow("3|").blue.bright + " What **Tube Stations** have the most Lines?"
     puts Rainbow("4|").blue.bright + " What **Tube Stations** have the least Lines?"
     puts Rainbow("5|").blue.bright + " What **Tube Lines** have the most Stations?"
     puts Rainbow("6|").blue.bright + " What **Tube Lines** have  the least stations?"
     puts Rainbow("7|").blue.bright + " View Service Status for all Tube Lines"
     puts Rainbow("8|").blue.bright + " Clear Screen"
     puts Rainbow("9|").blue.bright + " To Exit"
  end

   def menu_setting
    input = " "
    while input
      input = gets.chomp
      case input
        when "1"
          puts "Please enter a line name:"
          line = gets.chomp
          line = line.split.map(&:capitalize).join(' ')
          find_stations(line)
        when "2"
          puts "Please enter a station name: "
          station = gets.chomp
          station = station.split.map(&:capitalize).join(' ')
          find_lines(station)
        when "3"
          most_lines
        when "4"
          least_lines
        when "5"
          most_stations
        when "6"
          least_stations
        when "7"
          disruptions
        when "8"
          puts `clear`
          intro
        when "9"
          goodbye = Artii::Base.new :font => 'slant'
          puts goodbye.asciify("Have a Safe Journey")
          break
          else
          puts "That option does not exist. Please select a number from 1 - \u{0039} "
      end
    end
   end

   def colour_lines(line_name)
      Rainbow(line_name).bg(Line.find_by(name: line_name).colour).white.blink.bright
   end

  def find_lines(station_name)
    lines = []
    search_results = []
    search_results = Station.where("name like ?", "#{station_name}%").map{|s| s.name}
    if search_results.length == 0
      puts "\u{1F689} SORRY! We could not find that station, please try again. \u{1F689} "
      station = gets.chomp
      station = station.split.map(&:capitalize).join(' ')
      find_lines(station)
    else
      puts "****************************"
      puts "WE FOUND THE FOLLOWING STATIONS:"
      puts "--------------------------------"
      puts "#{search_results.map{|r| r}.join("\n")}"
      puts ""
      puts "Here is the information about the first one in this list:"
      puts ""
      lines = Station.find_by(name: "#{search_results[0]}").lines
      puts "\u{1F689} #{search_results[0]} is on the following #{lines.length} line(s): \u{1F689} "
      lines.map{|l| puts colour_lines l.name.split.map(&:capitalize).join(' ')}
      30.times do print "\u{1F687} " end
      puts ""
      puts "\n **************************** \n\n\n"
      intro
    end

  end


  def find_stations(line_name)
    stops = []
    search_results = []
    search_results = Line.where("name like ?", "#{line_name}%").map{|l| l.name}
    if search_results.length == 0
      puts "\u{1F689} SORRY! We could not find that line, please try again. \u{1F689} "
      line = gets.chomp
      line = line.split.map(&:capitalize).join(' ')
      find_stations(line)
    else
      puts "****************************"
      Line.find_by(name: "#{search_results[0]}").stations
      stops = Line.find_by(name: "#{search_results[0]}").stations
      puts "\u{1F689}  #{colour_lines search_results[0]} line has the following #{stops.length} station(s): \u{1F689} "
      stops.map{|s| puts s.name.split.map(&:capitalize).join(' ')}
      puts "#{stops.length} station(s) on the #{colour_lines search_results[0]} line!"
      30.times do print "\u{1F687} " end
      puts ""
      puts "\n **************************** \n\n\n"
      intro
    end
  end

  def most_lines
    max_num = Station.all.group_by{|s| s.lines.count}.keys.max
    most_lines = Station.all.group_by{|s| s.lines.count}[max_num].map{|s| s.name}
    puts "****************************"
    puts "\u{1F689}  #{most_lines.sample(5).join(", ")} has #{max_num} lines. \u{1F689}  "
    30.times do print "\u{1F687} " end
    puts ""
    puts "\n **************************** \n\n\n"
    intro
  end

  def least_lines
    min_num = Station.all.group_by{|s| s.lines.count}.keys.min
    least_lines = Station.all.group_by{|s| s.lines.count}[min_num].map{|s| s.name}
    puts "****************************"
    puts "\u{1F689}  There are #{least_lines.count} stations with just ONE line. \u{1F689}  "
    puts "Here is a random list of 5 of them:"
    puts "\u{1F689}  #{least_lines.sample(5).join("\n \u{1F689}  ")}"
    30.times do print "\u{1F687} " end
    puts ""
    puts "\n **************************** \n\n\n"
    intro
  end

  def most_stations
    puts "\u{1F689}  #{colour_lines Line.find_by(id: Stop.group(:line_id).count.max_by{|k,v| v}[0]).name} line has the most stations. \u{1F689}  "
    30.times do print "\u{1F687} " end
    puts "\n\n\n"
    intro
  end

  def least_stations
    puts "****************************"
    puts "\u{1F689}  #{colour_lines Line.find_by(id: Stop.group(:line_id).count.min_by{|k,v| v}[0]).name} line has the least stations. \u{1F689}  "
    30.times do print "\u{1F687} " end
    puts ""
    puts "\n **************************** \n\n\n"
    intro
  end

  def get_tfl_line_ids
    # ["piccadilly", "northern", "bakerloo", "central", "circle", "district", "hammersmith-city", "jubilee", "metropolitan", "victoria", "waterloo-city"]
    Line.all.map{|l| l.tfl_id}
  end

  def get_all_tube_stations
    stops_hash = Hash.new{}
    get_tfl_line_ids.each do |l|
      url = "https://api.tfl.gov.uk/Line/#{l}/Route/Sequence/inbound?excludeCrowding=false&app_id=7f2f48f4&app_key=0e1550125ac29794e46fe13c38722cf8"
      response_string = RestClient.get(url)
      response_hash = JSON.parse(response_string)
      tube_station_names = []
      response_hash["stations"].each do |station|
        tube_station_names << station["name"]
        stops_hash["#{l}"] = tube_station_names
      end
    end
    # File.open("tfl.rb", 'w') { |file| file.write(stops_hash) }
  end

  def disruptions
    disruptions_hash = Hash.new{}
    url = "https://api.tfl.gov.uk/Line/Mode/tube/Status?detail=true&app_id=7f2f48f4&app_key=0e1550125ac29794e46fe13c38722cf8"
    response_string = RestClient.get(url)
    response_hash = JSON.parse(response_string)
  end

  def disruptions
    disruptions_hash =
        {
          "piccadilly" => [],
          "bakerloo" => [],
          "central" => [],
          "circle" => [],
          "district" => [],
          "hammersmith-city" => [],
          "jubilee" => [],
          "metropolitan" => [],
          "victoria" => [],
          "waterloo-city" => []
        }
    url = "https://api.tfl.gov.uk/Line/Mode/tube/Status?detail=true&app_id=7f2f48f4&app_key=0e1550125ac29794e46fe13c38722cf8"
    response_string = RestClient.get(url)
    response_hash = JSON.parse(response_string)
    stations_arr = []
    disruptions_hash.each do |line, stations|
      disruptions_hash[line] << response_hash.select{|l| l["id"]==line}
        .map{|tfl| tfl["lineStatuses"]}.flatten[0]["statusSeverityDescription"]
        disruptions_hash[line] << response_hash.select{|l| l["id"]==line}
          .map{|tfl| tfl["lineStatuses"]}.flatten[0]["statusSeverity"]
        end
    disruptions_hash.each do|line,dis|
      puts "************************************"
      print "#{colour_lines Line.find_by(tfl_id: line).name} line has "
      if dis[1] < 10 && dis[1] >= 5
        puts Rainbow("#{dis[0].upcase}").black.bg("dbba30").blink
      elsif dis[1] < 5
        puts Rainbow("#{dis[0].upcase}").red.bg("cdccd8").blink
      else puts "#{dis[0].upcase}"
      end
    end
    30.times do print "\u{1F687} " end
    puts ""
    puts "\n **************************** \n\n\n"
    intro
  end

end

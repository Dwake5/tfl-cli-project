class CommandLineInterface

  def run
   greet
   intro
   menu_setting
  end

  def greet
    hello = Artii::Base.new :font => 'slant'
    puts hello.asciify("Mind the Gap")
  end

   def intro
     puts "Select a number from 1 - 7"
     puts "---------------------------"
     puts Rainbow("1|").blue.bright + " What stations are on a line?"
     puts Rainbow("2|").blue.bright + " What lines does a station belong to?"
     puts Rainbow("3|").blue.bright + " Stations with the most lines"
     puts Rainbow("4|").blue.bright + " Stations with the least lines"
     puts Rainbow("5|").blue.bright + " Lines with the most stations"
     puts Rainbow("6|").blue.bright + " Lines with the least stations"
     puts Rainbow("7|").blue.bright + " To exit"
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
          goodbye = Artii::Base.new :font => 'slant'
          puts goodbye.asciify("Have a safe journey")
          break
          else
          puts "Please select a number from 1 - 5"
      end
    end
   end

   def colour_lines(line_name)
     line_colors = {
       Bakerloo: "B36305",
       Circle: "FFD300",
       Central: "E32017",
       District: "00782A",
       "Hammersmith & City": "F3A9BB",
       Jubilee: "A0A5A9",
       Metropolitan: "9B0056",
       Northern: "000000",
       Piccadilly: "003688",
       Victoria: "0098D4",
       "Waterloo & City": "95CDBA",
     }
      Rainbow(line_name.to_sym).bg(line_colors[line_name.to_sym]).white.blink.bright
   end

  def find_lines(station_name)
    lines = []
    search_results = []
    search_results = Station.where("name like ?", "#{station_name}%").map{|s| s.name}
    lines = Station.find_by(name: "#{search_results[0]}").lines
    puts "#{search_results[0]} is on the following #{lines.length} line(s):"
    lines.map{|l| puts colour_lines l.name.split.map(&:capitalize).join(' ')}
  end


  def find_stations(line_name)
    stops = []
    search_results = []
    search_results = Line.where("name like ?", "#{line_name}%").map{|l| l.name}
    Line.find_by(name: "#{search_results[0]}").stations
    stops = Line.find_by(name: "#{search_results[0]}").stations
    puts "#{colour_lines search_results[0]} line has the following #{stops.length} station(s):"
    stops.map{|s| puts s.name.split.map(&:capitalize).join(' ')}
    puts "#{stops.length} station(s) on the #{colour_lines search_results[0]} line!"
  end

  def most_lines
    max_num = Station.all.group_by{|s| s.lines.count}.keys.max
    most_lines = Station.all.group_by{|s| s.lines.count}[max_num].map{|s| s.name}
    puts "#{most_lines.sample(5).join(", ")} has #{max_num} lines"
  end

  def least_lines
    min_num = Station.all.group_by{|s| s.lines.count}.keys.min
    least_lines = Station.all.group_by{|s| s.lines.count}[min_num].map{|s| s.name}
    puts "There are #{least_lines.count} stations with just one line."
    puts "Here is a random list of 5 of them: "
    puts "#{least_lines.sample(5).join(", ")}"
  end

  def most_stations
    puts "#{colour_lines Line.find_by(id: Stop.group(:line_id).count.max_by{|k,v| v}[0]).name} line has the most stations."
  end

  def least_stations
    puts "#{colour_lines Line.find_by(id: Stop.group(:line_id).count.min_by{|k,v| v}[0]).name} line has the least stations."
  end

  def get_tfl_line_ids
    ["piccadilly", "northern", "bakerloo", "central", "circle", "district", "hammersmith-city", "jubilee", "metropolitan", "victoria", "waterloo-city"]
    # puts Line.all.map{|l| l.tfl_id}
    # TODO REPLACE WITH DATA FROM db
  end

  def get_all_tube_lines
    # Line.all.map{|l| l.name}
    # TODO REPLACE WITH DATA FROM db
    ["Piccadilly", "Northern", "Bakerloo", "Central", "Circle", "District", "Hammersmith & City", "Jubilee", "Metropolitan", "Victoria", "Waterloo & City"]
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
    #File.open("tfl.rb", 'w') { |file| file.write(stops_hash) }
  end

  def read_array
    lines = ["piccadilly", "northern", "bakerloo", "central", "circle", "district", "hammersmith-city", "jubilee", "metropolitan", "victoria", "waterloo-city"]
    lines.each do |l|
      l = File.readlines("#{l}.json")
    end
  end
end

class CommandLineInterface


  def run
   greet
   puts "**********************"
   puts "**********************"
   puts "Select a number from 1 - 4"
   puts "--------------------------"
   puts "1 | To find what stations are in a line"
   puts "2 | To find what line a station belongs to"
   puts "3 | To find out the station with the most lines"
   puts "4 | To find out the station with the least lines"
   input = gets.chomp
   case input
   when "1"
     puts "Please enter a line name:"
     line = gets.chomp
     find_stations(line)
   when "2"
     puts "Please enter a station name: "
     station = gets.chomp
     find_lines(station)
   when "3"
     puts "Here is a list of the line with the most stations: "
     most_stations
   when "4"
     puts "Here is a list of the line with the least stations: "
     least_stations
   else
     puts "Please select a number from 1 - 4"
   end
  end

  def greet
    puts "Mind the Gap"
  end

  def gets_user_input
    puts "Find out what Line a Station belongs to."
    puts "Find out what Stations are in a Line."
    puts "Please enter a station name:"
    station_name = gets.chomp
    station_name = station_name.split.map(&:capitalize).join(' ')
    puts "You are at #{station_name}"
    station_name
  end

  def find_lines(station_name)
    lines = []
    lines = Station.find_by(name: station_name).lines
    puts "#{station_name} is on the following #{lines.length} line(s):"
    lines.map{|l| puts " * " + l.name + " - " + l.colour.capitalize}
  end

  def find_stations(line_name)
    stations = []
    stations = Line.find_by(name: line_name).stations
    puts "#{line_name} line has the following #{stations.length} station(s):"
    stations.map{|s| puts " * " + s.name.capitalize}
  end

  def most_stations
    lines = []
    total_stations = []
    Line.all.map do |l|
        lines << Line.find(l.id).stations
        end
    total_stations = lines.map {|l| l.length}
    line = total_stations.index(total_stations.max) + 1
    puts "#{Line.find(line).name} has the most stations."
  end

  def least_stations
    lines = []
    total_stations = []
    Line.all.map do |l|
        lines << Line.find(l.id).stations
        end
    total_stations = lines.map {|l| l.length}
    line = total_stations.index(total_stations.min) + 1
    puts "#{Line.find(line).name} has the least stations."
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

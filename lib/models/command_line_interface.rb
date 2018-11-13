class CommandLineInterface
  def run
    greet
    puts "**********************"
    most_stations
    puts "**********************"
    least_stations
    puts "**********************"
    input = gets_user_input
    # find_stations(input)
    find_lines(input)

  end

  def greet
    puts "Mind the Gap"
  end

  def gets_user_input
    puts "Find out what Line a Station belongs to."
    puts "Find out what Stations are in a Line."
    puts "Please enter a station name:"
    station_name = gets.chomp
    station_name = station_name.capitalize
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

  def most_lines

    puts "#{} has the most lines."
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

end

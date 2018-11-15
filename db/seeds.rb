require_relative '../tfl.rb'
# require 'rest-client'
# require 'json'
require 'set'


Line.destroy_all
Station.destroy_all
Stop.destroy_all


Line.create(tfl_id: "piccadilly", name: "Piccadilly", colour: "003688")
Line.create(tfl_id: "northern", name: "Northern", colour: "000000")
Line.create(tfl_id: "bakerloo", name: "Bakerloo", colour: "B36305")
Line.create(tfl_id: "central", name: "Central", colour: "E32017")
Line.create(tfl_id: "circle", name: "Circle", colour: "FFD300")
Line.create(tfl_id: "district", name: "District", colour: "00782A")
Line.create(tfl_id: "hammersmith-city", name: "Hammersmith & City", colour: "F3A9BB")
Line.create(tfl_id: "jubilee", name: "Jubilee", colour: "A0A5A9")
Line.create(tfl_id: "metropolitan", name: "Metropolitan", colour: "9B0056")
Line.create(tfl_id: "victoria", name: "Victoria", colour: "0098D4")
Line.create(tfl_id: "waterloo-city", name: "Waterloo & City", colour: "95CDBA")



def populate_stations
  tfl_hash = TransportForLondon::TFL
  station_arr = []
  tfl_hash.each do|k,v|
    station_arr << v
  end
  station_arr = station_arr.flatten
  station_set = station_arr.to_set

  station_set.each do |station|
    Station.create(name: "#{station}")
  end
end

def populate_stops
  tfl_hash = TransportForLondon::TFL
  tfl_hash.each do|ln,stn|
    l_id = Line.find_by(tfl_id: ln).id
      stn.each do |s|
      s_id = Station.find_by(name: s).id
      Stop.create(station_id: s_id, line_id: l_id)
    end

  end
end
populate_stations

populate_stops

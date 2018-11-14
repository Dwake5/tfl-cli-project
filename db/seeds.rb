# require 'api_data.rb'
Line.destroy_all
Station.destroy_all
Stop.destroy_all

piccadilly = Line.create(tfl_id: "piccadilly", name: "Piccadilly", colour: "003688")
northern = Line.create(tfl_id: "northern", name: "Northern", colour: "000000")
central = Line.create(tfl_id: "bakerloo", name: "Bakerloo", colour: "B36305")
central = Line.create(tfl_id: "central", name: "Central", colour: "E32017")
central = Line.create(tfl_id: "circle", name: "Circle", colour: "FFD300")
central = Line.create(tfl_id: "district", name: "District", colour: "00782A")
central = Line.create(tfl_id: "hammersmith-city", name: "Hammersmith & City", colour: "F3A9BB")
central = Line.create(tfl_id: "jubilee", name: "Jubilee", colour: "A0A5A9")
central = Line.create(tfl_id: "metropolitan", name: "Metropolitan", colour: "9B0056")
central = Line.create(tfl_id: "victoria", name: "Victoria", colour: "0098D4")
central = Line.create(tfl_id: "waterloo-city", name: "Waterloo & City", colour: "95CDBA")

kx = Station.create(name: "King's Cross")
lsq = Station.create(name: "Leicester Square")
moorgate = Station.create(name: "Moorgate")
bank = Station.create(name: "Bank")
tcr = Station.create(name: "Tottenham Court Road")
angel = Station.create(name: "Angel")

Stop.create(line_id: piccadilly.id, station_id: kx.id)
Stop.create(line_id: piccadilly.id, station_id: lsq.id)

Stop.create(line_id: northern.id, station_id: lsq.id)
Stop.create(line_id: northern.id, station_id: kx.id)
Stop.create(line_id: northern.id, station_id: angel.id)
Stop.create(line_id: northern.id, station_id: bank.id)
Stop.create(line_id: northern.id, station_id: tcr.id)
Stop.create(line_id: northern.id, station_id: moorgate.id)

Stop.create(line_id: central.id, station_id: bank.id)
Stop.create(line_id: central.id, station_id: tcr.id)

Stop.create(line_id: 10, station_id: 7)
Stop.create(line_id: 10, station_id: 8)
Stop.create(line_id: 10, station_id: 9)
Stop.create(line_id: 10, station_id: 10)
Stop.create(line_id: 10, station_id: 11)
Stop.create(line_id: 10, station_id: 12)
Stop.create(line_id: 10, station_id: 13)
Stop.create(line_id: 10, station_id: 14)
Stop.create(line_id: 10, station_id: 15)
Stop.create(line_id: 10, station_id: 16)
Stop.create(line_id: 10, station_id: 17)
Stop.create(line_id: 10, station_id: 18)
Stop.create(line_id: 10, station_id: 19)
Stop.create(line_id: 10, station_id: 20)
Stop.create(line_id: 10, station_id: 21)
Stop.create(line_id: 10, station_id: 22)

Line.destroy_all
Station.destroy_all
Stop.destroy_all

piccadilly = Line.create(name: "Piccadilly", colour: "purple")
northern = Line.create(name: "Northern", colour: "black")
central = Line.create(name: "Central", colour: "red")

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

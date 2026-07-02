# Every event lives as data under db/events/: <slug>.yml + <slug>.gpx (+ cached
# <slug>.crew_route.json). Adding a race = adding those files and re-running db:seed.
Dir[Rails.root.join("db/events/*.yml").to_s].sort.each do |yml|
  race = Events::Import.new(yml).call
  puts "Seeded #{race.name}: #{race.aid_stations.count} aid stations, #{race.simplified_track.size} track pts" \
       "#{race.crew_route ? ", crew drive #{race.crew_route['distance_mi']} mi / #{race.crew_route['duration_min']} min" : " (crew route unavailable)"}."
end

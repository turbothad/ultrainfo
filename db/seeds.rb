published_races = Events::Import.new(Rails.root.join("db/events/active.yml")).call

published_races.each do |race|
  puts "Published #{race.name}: #{race.aid_stations.count} Station passes, #{race.simplified_track.size} course points" \
       "#{race.crew_route ? ", crew drive #{race.crew_route['distance_mi']} mi / #{race.crew_route['duration_min']} min" : " (no crew route)"}."
end

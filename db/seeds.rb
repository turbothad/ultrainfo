# Bighorn 100 seed.
# REAL: the course track + every aid-station coordinate come from the official GPX
#   (db/events/bighorn-100.gpx, imported via Gpx::Import).
# SOURCED: aid-station miles, crew/pacer/drop-bag flags, cutoffs and spot elevations from
#   https://bighorntrailrun.com/100-mile (fetched 2026-06-26).
# STILL [UNVERIFIED] (kept behind the placeholder banner): exact date, entry fee,
#   registration platform/status, and TOTAL elevation gain — confirm against the official PDFs.

Race.where(slug: "bighorn-100").destroy_all # idempotent reseed

gpx = Gpx::Import.new(Rails.root.join("db/events/bighorn-100.gpx"))
ends = gpx.endpoints

# Elevation profile from the official aid-station spot elevations (the GPX track carries no ele).
elevation = [
  [ 0, 4275 ], [ 1.25, 4240 ], [ 3.5, 5025 ], [ 8.5, 7450 ], [ 13.5, 7480 ], [ 19.5, 6600 ],
  [ 26.5, 6800 ], [ 30, 4590 ], [ 33.5, 5080 ], [ 40, 6920 ], [ 48, 8800 ], [ 56, 6920 ],
  [ 62.5, 5080 ], [ 66, 4590 ], [ 69.5, 6800 ], [ 76.5, 6600 ], [ 82.5, 7480 ], [ 87.5, 7450 ],
  [ 92.5, 5025 ], [ 94.8, 4240 ], [ 98, 4040 ], [ 100, 3970 ]
].map { |mile, ft| { "mile" => mile, "elevation_ft" => ft } }

race = Race.create!(
  name: "Bighorn 100",
  slug: "bighorn-100",
  year: 2026,
  state: "WY",
  distance_mi: 100,
  elevation_gain_ft: nil, # [UNVERIFIED] — not on the page; GPX track has no elevation
  elevation_loss_ft: nil,
  start_date: nil,        # [UNVERIFIED]
  start_time: "9:00 AM",
  cutoff_hours: 35,       # 9:00 AM start → 8:00 PM next-day cutoff
  official_url: "https://bighorntrailrun.com/100-mile",
  registration_url: "https://ultrasignup.com", # [UNVERIFIED platform/link]
  registration_status: :not_open,
  lottery: false,
  blurb: "100 miles out-and-back through Wyoming's Bighorn Mountains, Dayton up to the Jaws turnaround.",
  about: "The Bighorn Trail Run 100-miler runs from the Tongue River Canyon near Dayton, WY out to " \
         "the Jaws turnaround (mile 48, ~8,800 ft) and back. Start 9:00 AM; overall cutoff 8:00 PM the " \
         "next day. Course and aid-station coordinates are from the official GPX; logistics from the race " \
         "site. Total climb, date and entry still to be confirmed against the official guide.",
  start_venue: "Tongue Canyon Road, Dayton, WY",
  finish_venue: "Scott Park, Dayton, WY",
  start_lat: ends[:start][0], start_lng: ends[:start][1],
  finish_lat: ends[:finish][0], finish_lng: ends[:finish][1],
  simplified_track: gpx.track(600),
  elevation_series: elevation
)

# Aid stations: coords from the GPX waypoints (real); miles/flags/cutoffs from the race site.
# `match` = GPX waypoint name substring. mile = outbound mile (the out-and-back revisits some).
aid = [
  { match: "Start of BH",             name: "Start — Tongue Canyon Rd", mile: 0.0,   elev: 4275, crew: true,  pacer: true,  drop: false, food: true,  med: true,  cutoff: nil,                          park: "Trailhead lot fills early — arrive well before the 9:00 AM start." },
  { match: "Tongue River Trail Head", name: "Tongue River Trailhead",   mile: 1.25,  elev: 4240, crew: true,  pacer: false, drop: false, food: false, med: false, cutoff: "6:45 PM (mi 94.8 return)",    park: "Foot/bike crew access only (no vehicles); also mile 94.8 on the return." },
  { match: "Lower Sheep Creek",       name: "Lower Sheep Creek",        mile: 3.5,   elev: 5025, crew: false, pacer: false, drop: false, food: true,  med: false, cutoff: nil,                          park: "No crew access." },
  { match: "Upper Sheep Creek",       name: "Upper Sheep Creek",        mile: 8.5,   elev: 7450, crew: false, pacer: false, drop: false, food: true,  med: false, cutoff: "4:30 PM (mi 87.5 return)",    park: "No crew access." },
  { match: "Dry Fork Ridge",          name: "Dry Fork Ridge",           mile: 13.4,  elev: 7480, crew: true,  pacer: true,  drop: true,  food: true,  med: true,  cutoff: "3:00 PM",                    park: "Major crew hub — large meadow parking. Crew at mile 13.4 and 82.5." },
  { match: "Kearns Cow Camp",         name: "Kern's Cow Camp",          mile: 19.5,  elev: 6600, crew: false, pacer: false, drop: false, food: true,  med: false, cutoff: nil,                          park: "\"Bacon Station\" — runners only, no crew." },
  { match: "Bear Camp",               name: "Bear Camp",                mile: 26.5,  elev: 6800, crew: false, pacer: false, drop: false, food: true,  med: false, cutoff: nil,                          park: "No crew access." },
  { match: "Sally's Footbridge",      name: "Sally's Footbridge",       mile: 30.0,  elev: 4590, crew: true,  pacer: true,  drop: true,  food: true,  med: true,  cutoff: "8:30 PM out · 10:00 AM back", park: "Crew + pacer access at mile 30 and 66." },
  { match: "Cathedral Rock",          name: "Cathedral Rock",           mile: 33.5,  elev: 5080, crew: false, pacer: false, drop: false, food: true,  med: false, cutoff: nil,                          park: "No crew access." },
  { match: "Spring Marsh",            name: "Spring Marsh",             mile: 40.0,  elev: 6920, crew: false, pacer: false, drop: false, food: true,  med: false, cutoff: nil,                          park: "No crew access." },
  { match: "Jaws Trail Head",         name: "Jaws (Turnaround)",        mile: 48.0,  elev: 8800, crew: true,  pacer: true,  drop: true,  food: true,  med: true,  cutoff: "4:00 AM",                    park: "Turnaround and high point — drop bags, crew, and pacer pickup." },
  { match: "Home Stretch",            name: "Home Stretch",             mile: 98.0,  elev: 4040, crew: true,  pacer: false, drop: false, food: true,  med: false, cutoff: nil,                          park: "Foot/bike access only." },
  { match: "End of BH",               name: "Finish — Scott Park",      mile: 100.0, elev: 3970, crew: true,  pacer: true,  drop: false, food: true,  med: true,  cutoff: "8:00 PM",                    park: "Finish line in Dayton — public parking nearby." }
]

aid.each_with_index do |s, i|
  wpt = gpx.waypoint(s[:match])
  warn "  ! no GPX waypoint matched #{s[:match].inspect}" if wpt.nil?
  race.aid_stations.create!(
    name: s[:name], sequence: i + 1, mile: s[:mile], elevation_ft: s[:elev], cutoff: s[:cutoff],
    crew_accessible: s[:crew], pacer_access: s[:pacer], drop_bag: s[:drop],
    has_water: true, has_food: s[:food], has_medical: s[:med],
    parking_notes: s[:park], lat: wpt&.dig(:lat), lng: wpt&.dig(:lng)
  )
end

puts "Seeded #{race.name}: #{race.aid_stations.count} aid stations, " \
     "#{race.simplified_track.size} track pts (course + coords REAL from GPX)."

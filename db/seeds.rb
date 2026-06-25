# ponytail: Every Bighorn 100 value below is PLACEHOLDER — structurally realistic so the
# app's features (crew map, role views, elevation profile) are visible on real-shaped data,
# but NOT verified against the official participant guide. Miles, cutoffs, crew-access flags,
# and coordinates are approximate/invented. Replace with sourced data before anyone trusts
# them (a banner in the UI says the same — see races/_placeholder_banner). Safety-relevant
# facts must come from the official guide, not from here.

Race.where(slug: "bighorn-100").destroy_all # idempotent reseed

DIST    = 100.4
START   = [ 44.8755, -107.2620 ].freeze # Dayton, WY area
TURN    = [ 44.6600, -107.5050 ].freeze # "Jaws" turnaround, up in the Bighorns
LOW_FT  = 4_000
HIGH_FT = 9_100

# Synthetic out-and-back track: interpolate start -> turnaround, then retrace.
out_pts = (0..20).map do |i|
  t = i / 20.0
  wig = Math.sin(t * Math::PI * 5) * 0.012 # wiggle so it reads like trail, not a ruler line
  [ (START[0] + (TURN[0] - START[0]) * t + wig).round(6),
   (START[1] + (TURN[1] - START[1]) * t + wig * 0.6).round(6) ]
end
track = out_pts + out_pts[0..-2].reverse

# Elevation profile: climb to the mile-48 turnaround, then descend home.
elevation = (0..40).map do |i|
  mile = (DIST * i / 40.0).round(1)
  frac = mile <= DIST / 2 ? mile / (DIST / 2) : (DIST - mile) / (DIST / 2)
  { "mile" => mile, "elevation_ft" => (LOW_FT + (HIGH_FT - LOW_FT) * frac + Math.sin(mile) * 250).round }
end

race = Race.create!(
  name: "Bighorn 100",
  slug: "bighorn-100",
  year: 2026,
  state: "WY",
  distance_mi: DIST,
  elevation_gain_ft: 18_000,
  elevation_loss_ft: 18_000,
  start_date: Date.new(2026, 6, 19),
  end_date: Date.new(2026, 6, 20),
  start_time: "11:00 AM MT",
  cutoff_hours: 35,
  official_url: "https://bighorntrailrun.com",
  registration_url: "https://ultrasignup.com",
  registration_status: :closed,
  lottery: false,
  blurb: "100 miles out-and-back through Wyoming's Bighorn Mountains.",
  about: "The Bighorn Trail Run's 100-miler climbs from the Tongue River Canyon near Dayton, " \
         "Wyoming up to the Jaws turnaround and back, with roughly 18,000 ft of climbing on " \
         "high-country singletrack. (Placeholder description — replace with sourced copy.)",
  start_venue: "Tongue River Canyon, Dayton, WY",
  finish_venue: "Scott Park, Dayton, WY",
  start_lat: START[0], start_lng: START[1],
  finish_lat: START[0], finish_lng: START[1],
  simplified_track: track,
  elevation_series: elevation
)

# Representative aid stations along the out-and-back. crew/drop/pacer flags are PLACEHOLDER.
stations = [
  { name: "Tongue River Canyon (Start)", mile: 0.0,   crew: true,  pacer: false, drop: false, food: true,  med: true,  park: "Trailhead lot fills early — arrive well before the start." },
  { name: "Dry Fork",                    mile: 13.4,  crew: true,  pacer: false, drop: true,  food: true,  med: true,  park: "Large meadow parking; the main crew hub on the way out." },
  { name: "Cow Camp",                    mile: 19.6,  crew: false, pacer: false, drop: false, food: true,  med: false, park: "No crew access — runners only." },
  { name: "Sally's Footbridge",          mile: 30.0,  crew: true,  pacer: true,  drop: true,  food: true,  med: true,  park: "Limited roadside parking; pacers may join here." },
  { name: "Jaws (Turnaround)",           mile: 48.0,  crew: true,  pacer: true,  drop: true,  food: true,  med: true,  park: "High point and turnaround — drop bags, crew, and pacer pickup." },
  { name: "Sally's Footbridge (return)", mile: 66.0,  crew: true,  pacer: true,  drop: true,  food: true,  med: true,  park: "Same access as outbound." },
  { name: "Dry Fork (return)",           mile: 82.5,  crew: true,  pacer: true,  drop: true,  food: true,  med: true,  park: "Last major crew point before the finish." },
  { name: "Scott Park (Finish)",         mile: 100.4, crew: true,  pacer: false, drop: false, food: true,  med: true,  park: "Finish line in Dayton — public parking nearby." }
]

n = track.length
stations.each_with_index do |s, i|
  frac = [ s[:mile] / DIST, 1.0 ].min
  pt = track[(frac * (n - 1)).round]
  nearest_ft = elevation.min_by { |e| (e["mile"] - s[:mile]).abs }["elevation_ft"]
  race.aid_stations.create!(
    name: s[:name], sequence: i + 1, mile: s[:mile], elevation_ft: nearest_ft,
    cutoff: nil, # placeholder: real per-station cutoffs come from the official guide
    crew_accessible: s[:crew], pacer_access: s[:pacer], drop_bag: s[:drop],
    has_water: true, has_food: s[:food], has_medical: s[:med],
    parking_notes: s[:park], lat: pt[0], lng: pt[1]
  )
end

puts "Seeded #{race.name} (#{race.aid_stations.count} aid stations) — PLACEHOLDER data."

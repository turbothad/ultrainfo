# Coldwater Rumble 100 (2027) source audit

Verified on 2026-08-13. This audit uses only Aravaipa Running material: the
official race page, the 2027 UltraSignup listing, the 2026 Runner Guide PDF,
and the CalTopo course map those surfaces link — plus USGS 3DEP spot
elevations. It records what those sources actually establish; it does not
treat an organizer label as proof that a fact is current or internally
consistent.

## Bottom line

The record is publishable with a source warning. The official race page and
2027 UltraSignup listing support the January 16, 2027 date, the 7:00 AM
100-Mile start, the Red-Red-Blue-Blue-Blue loop structure, the 32-hour limit
with the full cutoff pattern, 8,687 ft of gain, open registration closing
January 11, 2027, and crew/pacer basics. The 2026 Runner Guide supplies the
official mile frame and detailed rules, flagged as prior-edition material.

Recorded discrepancies:

1. **Course length.** The race is billed as the 100 Mile, but the 2027 page's
   key stats say 101.3 miles, the guide's cutoff table 101.2 (18:59 min/mile
   framing), and the organizer's CalTopo "100 Mile" line measures 101.0. The
   record keeps the guide's cutoff frame — red loops clear at 20.1, blue
   loops at 47.1/74.1/101.2 — and `distance_mi` stays the billed 100.
2. **Red-loop station miles.** The guide publishes no red-loop station miles;
   Gila Aid (2.8/12.9) and the mid-red HQ pass (10.1) carry map-measured
   values, with the second red loop anchored to the guide's 20.1.
3. **Station spelling.** The guide's cutoff table and the race page write
   "Pedersen"; the guide maps and CalTopo write "Pederson". The record uses
   Pedersen and notes the map spelling in the GPX waypoint name.
4. **Guide edition.** The Runner Guide is the 2026 edition (packet pickup
   dated January 17–18, 2026). The 2027 race page independently states the
   same cutoff pattern, structure, start time, and crew/pacer rules, so
   current facts rest on current surfaces; the guide contributes the mile
   anchors, menu, site layout, and rule detail, all flagged.
5. **Elevation.** The organizer publishes total gain (8,687 ft) and max
   elevation (1,449 ft) but no profile, and the CalTopo line is 2-D.
   `elevation_loss_ft` stays null (gain only is published); the profile is
   USGS 3DEP spot elevations at the organizer's station markers (HQ 1,035 ft,
   Gila 1,113 ft, Rainbow Valley 1,385 ft, Pedersen 1,153 ft, Horse Thief
   929 ft).
6. **Water potability.** Every station serves from the published menu; no
   source certifies potability. `potable_water` stays null.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Coldwater Rumble official race page | https://aravaiparunning.com/coldwater/ | Supports Saturday, January 16, 2027; Estrella Mountain Regional Park, Goodyear, AZ (14805 West Vineyard Avenue main entrance); distances; 100M start 7:00 AM; 32-hour limit with final Blue Loop by 6:30 AM, Horse Thief by 12:30 PM, soft cutoffs Rainbow Valley 9:15 AM and Pedersen 10:00 AM; two 10-mile red loops + three 27-mile blue loops; desert-surface course description; 8,687 ft total gain, max elevation 1,449 ft; crew at start/finish and Horse Thief (no structures); pacers after mile 47 at Rumble HQ or Horse Thief; registration open, closing January 11, 2027 11:59 PM MT; links to the CalTopo map, 2026 Runner Guide, live tracking, and UltraSignup. |
| S2 | 2027 UltraSignup listing | https://ultrasignup.com/register.aspx?did=138367 | Registration surface for the 2027 race; `registration_url` and (post-race) `results_url` point here. |
| S3 | Coldwater Rumble Runner Guide (2026 edition) | https://www.aravaiparunning.com/avr/wp-content/uploads/CWR26-Runner-Guide.pdf | Official mile frame and rules: start times by distance; "Rumble HQ" at the Estrella Competitive Track ("DO NOT NAVIGATE TO ESTRELLA MOUNTAIN REGIONAL PARK", enter from Indian Springs onto Old Baseline); 100 Mile = Red, Red, Blue, Blue, Blue; cutoff table — clear Red Loops by 1:30 PM (20.1), begin final Blue Loop by 6:30 AM Sunday (74.1), leave Horse Thief by 12:30 PM Sunday (93.3), soft cutoffs Rainbow Valley 9:15 AM (82.7) and Pedersen 10:00 AM (85.1), final 101.2 miles at 18:59 min/mile; crews at HQ (canopies inside the HQ loop, runners through every lap, ~0.2-mile neutral zone) and Horse Thief (no structures, no camping); one pacer at a time, human on foot, no muling, no bib, welcome to aid offerings, enter/exit only at HQ or Horse Thief after mile 47.1; drop bags to HQ Friday or race morning with designated Horse Thief and start/finish spots; site layout with medical tent, warming tent, timing, restrooms, crew zone, runner parking, satellite crew/spectator lots; station menu chart (Main Aid, Gila, Rainbow Valley, Pederson, Horse Thief); driving directions to Horse Thief via the main park entrance and Casey Abbott Drive. 2026-edition material. |
| S4 | Organizer CalTopo course map | https://caltopo.com/m/UUDUK23 | Geometry authority: "100 Mile" line of 7,104 points measuring 101.03 miles (14 ft closure at Rumble HQ) and markers for Start/Finish (33.365200, -112.319550), Gila Aid (33.349700, -112.309440), Rainbow Valley Aid (33.307070, -112.359210), Pederson Aid (33.318430, -112.392480), Horse Thief Aid (33.381980, -112.369440). Marker approach miles (Gila 2.8/12.8; Rainbow Valley ~28.6/55.6/82.6; Pederson 31.0/58.0/85.0; Horse Thief 39.1/66.1/93.1) corroborate the guide frame within ~0.2 mi. `db/events/coldwater-rumble-100.gpx` copies the line's coordinates exactly. |
| S5 | Aravaipa live tracking | https://live.aravaiparunning.com/#/ | Live tracking surface named by the race page; supports the follow story. |
| S6 | USGS 3DEP Elevation Point Query Service | https://epqs.nationalmap.gov/v1/json | Spot elevations at the organizer's station markers (queried 2026-08-13): HQ 1,035 ft, Gila 1,113 ft, Rainbow Valley 1,385 ft, Pedersen 1,153 ft, Horse Thief 929 ft. Used because the organizer publishes totals, not a profile. |

## Claim-level decisions

- **Name.** "Coldwater Rumble 100" for the 100-mile Race within the Coldwater
  Rumble weekend (S1 lists six distances).
- **Registration status.** `open` — S1 shows registration open with a
  January 11, 2027 close.
- **Lottery.** `false` — direct first-come UltraSignup registration.
- **Cutoffs.** Six both-form cutoffs from the 7:00 AM MST start: 20.1 =
  1:30 PM Saturday (390 min, hard); 74.1 = 6:30 AM Sunday (1,410, hard);
  82.7 = 9:15 AM (1,575, soft); 85.1 = 10:00 AM (1,620, soft); 93.3 =
  12:30 PM (1,770, hard); 101.2 = 3:00 PM (1,920, final). Soft cutoffs carry
  the guide's RD-discretion wording in their source notes.
- **Station passes.** 17: Start, Gila and HQ on each Red Loop, then Rainbow
  Valley, Pedersen, Horse Thief, and HQ on each Blue Loop, with the final HQ
  pass recorded as the Finish.
- **Crew.** `true` at HQ passes and Horse Thief (S1/S3), `false` at Gila,
  Rainbow Valley, and Pedersen (crews are welcomed at exactly two points).
- **Pacers.** Guarantee-based booleans: `true` at HQ and Horse Thief passes
  from mile 47.1 onward, `false` at every earlier pass and at Rainbow Valley
  and Pedersen (no entry/exit there even when accompanied).
- **Drop bags.** `true` at HQ and Horse Thief passes (S3's two designated
  destinations), `false` at Gila, Rainbow Valley, and Pedersen, `null` at
  the Start.
- **Medical.** `true` at HQ passes (S3's site layout marks a medical tent),
  `null` at backcountry stations (no published medical service).
- **Elevation series.** S6 station spot elevations at each pass's guide-frame
  mile — the flat-profile approach reviewed for prior records, here over a
  456-ft spot range.
- **Follow.** Live tracking on S5; results appear on the UltraSignup listing
  (S2) after the race.

## Stale-source traps

- The Runner Guide is CWR26; its packet-pickup dates (January 17–18, 2026)
  and NOAA forecast are last year's. Do not copy 2026 schedule times where
  the 2027 page is silent beyond the stated start times and cutoffs.
- run100s' row (32h, 4400'/4400') reflects an older venue/course era; its
  climb figures contradict the organizer's 8,687 ft and were not copied.
- The 2026 guide links separate CalTopo maps and Strava routes per distance;
  this record's geometry must come from the race page's map (UUDUK23), whose
  only line is "100 Mile", and Strava mirrors must not be used.
- "Pederson" on maps vs "Pedersen" in the cutoff table: keep the cutoff-table
  spelling and note the variant.

# Southern Tour Ultra (2027) source audit

Verified on 2026-08-13. This audit uses only the organizer's official RunSignup
race site (southerntourultra.com redirects there), the organizer-published
Google My Maps course maps linked from that site's Course page, and USGS 3DEP
spot-elevation queries. It records what those sources actually establish; it
does not treat an organizer label as proof that a fact is current or
internally consistent.

## Bottom line

The record is publishable with a source warning. The official pages support the
2027 date, the 100-mile format (10 laps of a 10-mile loop), the 12:00 PM Friday
start, the 32-hour limit with a 29-hour soft cutoff, both stations' aid
inventories, pacer and muling rules, parking/camping logistics, and open
RunSignup registration. They do **not** support a vert figure, potable-water
certification, per-station medical or drop-bag service, or crew access at the
mid-loop station. The organizer's own course map contradicts the nominal loop
frame in two places.

Recorded discrepancies:

1. **Loop length.** The organizer bills 10-mile loops (100 miles in 10 laps);
   the organizer's own My Maps line measures 10.20 miles, making ten laps about
   102 miles. The record keeps the advertised 100-mile frame and notes the
   measurement.
2. **Mid-loop station mile.** The organizer places Station 1 "at mile 5"; along
   the map's line in the direction of travel (established by the map's own
   course-direction chevrons) the station placemark sits at ~6.1 miles. The
   record keeps the organizer's per-loop mile 5 frame and notes the
   measurement.
3. **Loop structure caveat.** The Individual Events page marks the loop count
   "subject to change based on conditions". The FAQ, Course page, and My Maps
   all agree on a single repeated 10-mile loop, so the record uses that
   structure and carries the organizer's caveat in `source_notes`.
4. **Elevation.** The My Maps export stores no elevations and the organizer
   publishes no vert figure ("primarily flat"). `elevation_gain_ft` and
   `elevation_loss_ft` stay null. Pass spot elevations and the profile use
   USGS 3DEP point queries at the on-course track points nearest each mapped
   station (event field 22 ft, mid-loop station 18 ft; raw placemark points,
   which sit slightly off the track, query at 23 ft and 10 ft). Loop samples
   run 11–29 ft.
5. **Water potability.** Water is listed at both stations; nothing certifies
   potability. `potable_water` stays null at every pass.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Race site home (RunSignup) | https://runsignup.com/Race/NC/Wilmington/SouthernTourUltra | Supports the January 15–16, 2027 date, distances, and registration deadline (January 9, 2027, 11:59 PM ET). https://www.southerntourultra.com redirects here. Its own Sign Up and Results links carry raceId 36713, the id in `registration_url` and `results_url`. |
| S2 | Individual Events page | https://runsignup.com/Race/SouthernTourUltra/Page/IndividualEvents | Primary 100-mile source: 12:00 PM Friday start, 11:30 AM meeting, 32-hour limit, 29-hour soft cutoff (final lap by 5:00 PM Saturday with a headlamp, complete by 8:00 PM), 10 laps of a 10-mile course "subject to change based on conditions", pass through the "checkpoint" (the event-field station) every lap, pacer/muling rules, both stations' aid inventories, buckle policy. |
| S3 | Schedule page | https://runsignup.com/Race/SouthernTourUltra/Page/Schedule | Supports Friday gate/packet times for 100-milers (gates open 10:00 am Friday "for 100 mile participants only"), the "Southern Tour Race Site" venue name, Saturday gates at Scott's Hill Loop Road, the 5:00 PM Saturday course sweep, the 8:00 PM Saturday course close, and shuttle times. |
| S4 | FAQ page | https://runsignup.com/Race/SouthernTourUltra/Page/FrequentlyAskedQuestions | Supports loop structure (two aid stations per loop at mile 5 and mile 10), pacer timing, station menus (adds Ramen and fruit at Station 1), and finisher recognition. |
| S5 | Course page | https://runsignup.com/Race/SouthernTourUltra/Page/Course | Course narrative (private property along the Atlantic Intracoastal Waterway; packed sand, single track, bush-hogged routes; the organizer's claim that "George Washington's historic Southern Tour once traversed this very property" — no year given) and links to S6 and the site-layout map. |
| S6 | Organizer Google My Maps "10 mile course" (KML export) | https://www.google.com/maps/d/kml?mid=1TXRiHGQ6AkgURW1N5CQgnLt362qD5ILo&forcekml=1 | Geometry authority: 896-point loop line (measures 10.20 mi), START/FINISH/AID/CHECKPOINT placemark (34.330738, -77.739602), AID STATION placemark (34.324688, -77.729747). `db/events/southern-tour-ultra.gpx` is converted from this export; direction of travel follows the map's course-direction chevrons. |
| S7 | Camping, Parking and Rules page | https://runsignup.com/Race/SouthernTourUltra/Page/CampingParkingandRules | Supports parking passes/QR system, ~450-car limit, entry "via the Scott's Hill Loop Gate", the 4-wheel-drive recommendation for field parking, Poplar Grove overflow (1.5 mi) with Saturday shuttles 5:30 am–7:00 pm, camping rules, and portable restrooms/handwashing at the venue. Together with S3 this sources the "Southern Tour Race Site, Scott's Hill Loop Road" venue line. |
| S8 | USGS 3DEP Elevation Point Query Service | https://epqs.nationalmap.gov/v1/json | Spot elevations at mapped points (queried 2026-08-13): event-field station placemark 23 ft, mid-loop station placemark 10 ft, loop samples 11–29 ft. Not an organizer source; used only because the organizer publishes no elevation data. |

## Claim-level decisions

- **Name.** "Southern Tour Ultra" (S1 site title). run100s lists it as "Southern
  Tour"; the organizer's own name wins.
- **Organizer contact.** The site offers no standalone organizer domain beyond
  RunSignup; southerntourultra.com is the official entry point.
- **Registration status.** `open` — S1 shows registration open with a January 9,
  2027 deadline at verification time.
- **Lottery.** `false` — direct first-come RunSignup registration; no reviewed
  source mentions a lottery or waitlist.
- **Cutoffs.** Overall 32 hours (S2, S3, S4 all agree: finish by 8:00 PM
  Saturday). The 29-hour rule is published as a *soft* cutoff and is recorded on
  the mile-90 pass with the organizer's own wording.
- **Pacers.** After 50 miles or 11:59 PM Friday, whichever comes first; join
  anywhere on course; one at a time; no bicycles; muling allowed (S2). The FAQ's
  older "after 11:59 PM" phrasing is superseded by S2's fuller rule.
- **Crew.** Personal crew area at the main aid station; personal aid may be
  placed near the camping area by the event-field station (S2). No source publishes crew
  access at the mid-loop station, and all parking/access instructions point to
  the event field, so mid-loop passes record `crew: false` with a note.
- **Drop bags.** No drop-bag service is published anywhere; `drop` stays null
  with the personal-aid note on event-field passes.
- **Medical.** No source describes medical service at any station; `med` stays
  null everywhere.
- **Station passes.** 21 passes: Start, then Station 1 (per-loop mile 5) and the
  event-field station (per-loop mile 10) for each of ten loops, with the
  final event-field pass recorded as the Finish. Coordinates come from the S6
  placemarks via GPX waypoints.
- **Elevation series.** USGS 3DEP spot elevations at the on-course points
  nearest each mapped station, listed at each pass's nominal mile — the same
  spot-elevation profile approach as the Bighorn record. This is terrain
  context, not organizer data, and is flagged in `source_notes`.
- **Other distances.** The 50-mile, 50K, relay, and shorter Saturday races
  share the venue; this record covers only the 100-mile individual race.

## Stale-source traps

- eagle-endurance.com (this race is unrelated to it, but nearby January
  ultra listings on run100s still point there) now serves spam content.
- run100s.com's table row for this race predates the current listing; its
  32-hour cutoff matches, but its "Southern Tour" name and any operational
  details must not be copied without checking the RunSignup pages above.
- The Palmetto Ultras-style pattern of unlinked "Runner Guide" text does not
  apply here; all Southern Tour operational pages are public RunSignup pages.

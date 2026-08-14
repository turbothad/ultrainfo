# Warbird 100 (2027) source audit

Verified on 2026-08-13. This audit uses only Trail Sick material: the
Warbird 100 page on trailsick.com, its linked PDFs (aid station details,
race info, crew and pacer guide), the official course GPX download, the
organizer CalTopo map, and the 2027 UltraSignup listing. It records what
those sources actually establish; it does not treat an organizer label as
proof that a fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The 2027 UltraSignup
listing pins the dates (March 19–20, 2027) and the 7:00 AM Friday start
with open registration; the aid station details PDF supplies a complete
sixteen-row table with leave-by clocks, drop/crew/pacer flags, and
coordinates for the crewed stations; the race info PDF supplies the
35-hour frame, rules, menu, gear, cutoff policy, and a station-by-station
course description; and the official GPX carries the full loop with
elevations. The course is one large ~102-mile backcountry loop on the
Redbird Crest Trail system.

Recorded discrepancies and decisions:

1. **Four distance frames.** The aid table ends at 102.2 (governs pass
   miles); the race info PDF's prose bills "a 103 mile ultra marathon";
   its CalTopo profile screenshot says 102.29 miles; the official GPX
   GPS-measures 102.19 (23-foot closure). `distance_mi` is 102.2.
2. **Sugar Creek AM/PM misprint.** The table prints "10:30 PM" at mile
   80.9 between the 7:00 AM (71.4) and 12:55 PM (87.5) rows, inside a
   35-hour race that ends 6:00 PM Saturday. Recorded as 10:30 AM (1,650
   minutes) with a pass-specific source note.
3. **Finish coordinate typo.** The table's finish row prints
   "37.14141, -8342894" — the longitude is missing its decimal point;
   the GPX start/finish sits at 37.14148, -83.42890.
4. **Two mile frames in one PDF.** The race info PDF's drop-bag list
   quotes miles 17/32.40/38.70/48.49/52.79/61.11/71.94/81.48/92.56 while
   its own aid table says 17.0/32.6/39.2/48.9/53.4/60.7/71.4/80.9/91.8;
   the stations named are identical and the table governs.
5. **Stale schedule dates.** The PDFs still carry the 2026 edition's
   schedule (Thursday March 12 check-in, Friday March 13 start, Saturday
   March 14 cutoff — 2026 dates); the 2027 listing gives Friday March 19
   at 7:00 AM ("Start Times: 100M Fri 7:00 AM") and the same 35-hour /
   6:00 PM Saturday pattern. March 19–20, 2027 sits after the March 14
   spring-forward, so no DST crossing.
6. **Cutoff policy nuance.** "Cut-off times at crewed aid stations are
   non-negotiable" — runners must check out before the clock; at remote stations past
   cutoff, volunteers may encourage a runner to move to the next crewed
   station rather than extract them. Recorded in the cutoff notes.
7. **Elevation figures.** The race info PDF's CalTopo profile shows
   +15,676' / −15,676' over 102.29 miles — recorded as gain/loss. The
   raw GPX sums lower unsmoothed; the profile also shows the 840–2,068 ft
   range and the course description names the 2,062-foot high point near
   mile 44.
8. **Station coordinates.** The table publishes coordinates only for
   Bowens Creek, Bear Creek, Peabody, Sugar Creek, and the finish; those
   sit 17–178 feet from the GPX line (parking/trailhead spots — up to
   about 650 feet from the point at the exact table mile) and are used
   as published. Other stations sit on the GPX at their table mile.
9. **Medical.** No station-level service is guaranteed: volunteers
   "provide care based on their level of certification (first-aid,
   wilderness first-aid, CPR, EMT, etc.)". `med` stays null everywhere.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Warbird 100 page | https://www.trailsick.com/warbird-100 | Hub linking the map, GPX files, PDFs, Strava routes, lodging, eligibility policy, and registration. |
| S2 | UltraSignup 2027 listing | https://ultrasignup.com/register.aspx?did=139346 | "Warbird 100 - March 19 - 20, 2027"; "The Warbird 100 battle will begin on Friday March 19th at 7am"; Start Times table (100M Fri 7:00 AM); Hyden, KY; open registration ($325, rising after October 30; closes March 15); 2026 results. |
| S3 | Aid station details PDF | https://www.trailsick.com/s/Warbird-100-Aid-Station-Details.pdf | The sixteen-row table: total mileage, mileage to next, drop bags, crew, pacers, coordinates, leave-by cutoffs; crew-accessible (Bear Creek, Peabody, Sugar Creek) and pacer drop-off (Bowens Creek) legends; the Sugar Creek and finish-longitude misprints. |
| S4 | Race info PDF | https://www.trailsick.com/s/Warbird-100-Race-Info-Final.pdf | 35-hour cutoff basis and policy; 2026-dated schedule pattern (7:00 AM start, 6:00 PM cutoff, drop bags due 6:15 PM the night before); runner/pacer/crew rules; menu; mandatory gear (1L capacity, space blanket, headlamp — allowed to wait at Bowens Creek); drop-bag list and guidelines; CalTopo profile (+15,676'/−15,676', 102.29 mi, 840–2,068 ft); Ultrapacer link; detailed course description (Redbird Crest Trail, river crossing and shoe change after Bear Creek, dogs on the road section before Single Track, 2,062' high point near mile 44); medical policy; dropout rules. |
| S5 | Crew and pacer guide PDF | https://www.trailsick.com/s/Warbird-100-Crew-and-Pacer-Guide-Final.pdf | Crew rules (crewed stations only, 300-yard radius, two vehicles per runner, no station supplies for crews); pacer rules (one at a time, join at Bowens Creek then trade at Bear Creek/Peabody/Sugar Creek, no muling, inform captains, 18+ recommended); driving directions and cell-coverage guide (none at Bowens/Bear Creek; spotty at Peabody/Sugar Creek). |
| S6 | Official course GPX | https://www.trailsick.com/s/Warbird-100.gpx | Geometry and elevation authority ("Warbird 100 Final"): 6,814 points with elevations, 102.19 GPS miles, 23-foot closure, start/finish 37.14148,-83.42890. `db/events/warbird-100.gpx` copies the points exactly and adds sixteen station waypoints. |
| S7 | Organizer CalTopo map | https://caltopo.com/m/7GMMGDC | Interactive course map linked from the race info PDF. |

## Claim-level decisions

- **Name.** "Warbird 100" (S1/S2).
- **Registration status.** `open` — S2 sells all three distances.
- **Lottery.** `false` — direct registration.
- **Cutoffs.** Leave-by clocks at all fifteen stations after Coke Syrup
  (whose cutoff column reads NA), from Sawdust Pile 12:05 PM (305) to
  the finish 6:00 PM (2,100). `cutoff_hours` 35.
- **Station passes.** 17: the Start, the table's fifteen mid-race
  stations, and the Finish. One big loop, so mid passes are unlabeled
  per the domain vocabulary.
- **Crew.** `true` at Bear Creek, Peabody, Sugar Creek, and the
  start/finish passes; `false` elsewhere, with Bowens Creek's
  pacer-drop-off exception noted.
- **Pacers.** `true` at Bowens Creek, Bear Creek, Peabody, and Sugar
  Creek; `false` elsewhere.
- **Drop bags.** `true` at the nine listed stations; `false` at the
  rest; `null` at the Start.
- **Medical.** `null` everywhere (decision 9).
- **Elevation series.** The official GPX's elevations per nominal table
  mile; station spots are the GPX values at each station's mile.
- **Follow.** No live tracking published; results on UltraSignup (the
  listing page carries the results tab).

## Stale-source traps

- The PDFs' schedule pages carry the 2026 edition's dates; the 2027
  listing governs (March 19–20, 7:00 AM). Re-check for re-issued 2027
  PDFs closer to race day.
- The GPX is named "Warbird 100 Final" without a year; the course
  description says the route was scouted New Year's Eve 2024/2025 —
  re-check geometry before race week.
- The aid table's Sugar Creek 10:30 PM and finish longitude -8342894
  misprints may be corrected in a future PDF revision.
- The pepper-spray recommendation is self-conflicting: the gear list
  says "for the Bear Creek Aid Station drop bags" while the crew guide
  and course description point to Deer Lick before the dog section.
- run100s' 35-hour figure matches; its climb column was blank, and the
  organizer profile's +15,676' now fills it.

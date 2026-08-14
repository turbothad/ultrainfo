# The Drift 100 (2027) source audit

Verified on 2026-08-13. This audit uses only thedrift100.com material and the
organizer's UltraSignup listings: the site home, the 100-mile course page
(aid table, cutoffs, menus, evacuation, qualification), the FAQ, the
mandatory gear page, the timeline page, and the official course GPX/KML
downloads. It records what those sources actually establish; it does not
treat an organizer label as proof that a fact is current or internally
consistent.

## Bottom line

The record is publishable with a source warning. The site masthead and the
UltraSignup 2027 registration page pin the race to March 12–14, 2027 (the 100
starts Friday 9:00 AM); the course page carries the full aid table with
leave-by cutoffs, menus, and bathroom flags; the FAQ bans pacers and all
outside assistance; and the course page links official GPX/KML downloads
whose waypoints mark the start, the four stations, and the finish.
Registration opens October 1, 2026 on UltraSignup.

Recorded discrepancies and decisions:

1. **Three distance frames.** The aid table's cumulative column ends at 101
   (governs pass miles), the course page blurb bills "103 miles of winter
   wonderland," and the official GPX GPS-measures 103.1. `distance_mi` is
   101 to match the pass frame; the conflict is recorded.
2. **Elapsed-hours column vs its own clocks.** From the Friday 9:00 AM
   start, Warm Springs' "Saturday 8 pm / 33 hours" clock is 35 elapsed
   hours, and the second Strawberry pass's "Sunday 4 am / 41 hours" clock
   is 42 true elapsed hours (the race weekend crosses the March 14, 2027
   spring-forward). The posted leave-by clocks govern; pass rows record
   clock-derived elapsed minutes. The finish pair "Sunday 5 pm / 55 hours"
   is self-consistent only because of the DST change — 55 is recorded as
   `cutoff_hours`.
3. **Stale surfaces on the live site.** The TIMELINE page still carries the
   2025 race's weekday-date pairs ("Friday March 14th 9:00 AM: The
   Drift 100 starts"), and the home page still says registration opens
   11/01/24. The 2027 masthead ("March 12-14, 2027") and the UltraSignup
   2027 page ("The Drift 100 - March 12, 2027") govern the date; the 9:00
   AM start is consistent across the aid table and the timeline.
4. **Crew.** The FAQ: a racer's entourage "may cheer you on out on the course," but
   "having non-racers pace, follow or otherwise assist you will result in
   disqualification. Outside assistance is not allowed." Crew is false at
   every pass; racers may help each other.
5. **Start and finish aid.** The aid table's menu column reads "NA" at the
   start and is empty at the finish, and the course page counts four
   manned, heated stations (miles ~25/50/67/83) — both terminal passes
   record food false with the table quoted.
6. **Geometry.** The "GPX Download" Drive file is a CalTopo export: a
   2,510-point 2D line (no elevations) plus waypoints for the start, the
   four stations, the finish, and a Green Creek Safety Shelter (omitted
   from the bundle GPX as a non-station). Elevations come from USGS 3DEP
   spot queries — station spots at the waypoint coordinates and a
   per-nominal-table-mile profile along the line (GPS miles scaled 103.08→101).
7. **The 48-hour leftovers.** The course page's own Section 1 narrative
   still tells racers "Remember you have 48 hours" — matching run100s'
   stale 48 — but the aid table's leave-by clocks and the timeline's
   Sunday 5:00 PM close say 55; the table governs and 48 was not copied.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | The Drift site home | https://www.thedrift100.com/ | Masthead "Run. Fat bike. Ski. March 12-14, 2027"; race lineup (100/28/13); blurb "103 miles ... over 9,000 ft elevation loss/gain"; self-sufficiency framing ("no drop bags, pacers, or cell service"); stale "REGISTRATION OPENS 11/01/24" block. |
| S2 | 100-mile course page | https://www.thedrift100.com/100-mile-course/ | Primary source: point-to-point Green River TH → Kendall Valley Lodge; the aid table (miles 0/24.9/50/67.3/83.5/101 with leave-by clocks, elapsed hours, menus, bathroom flags); four manned heated stations near 25/50/67/83, check-in/out required, no sleeping, small stations, shared use of Strawberry and Sheridan; allergy food container to Warm Springs (hot food only); evacuation by snowmachine with the $200 fee (racers turning around at or south of the Strawberry safety shelter on the way in may self-return); the Trackleaders tracking-device requirement; qualification requirement; the stale "Gear check ... Thursday March 12th" and 6 pm prerace-meeting sentences; Bridger-Teton and Shoshone National Forest permits; course-file links (CalTopo, map/profile PDFs, KML/GPX Drive downloads); "route is subject to slight modification prior to race day". |
| S3 | FAQ | https://www.thedrift100.com/faq/ | No dogs, pacers, or personal snow machines ("Nope, nope and nope"); outside assistance banned (racer-to-racer help allowed); an entourage may cheer; strict cutoffs with no exceptions, the first-station miss returning to the start (a racer dropping before or at the first station may leave under their own power) and later misses evacuated for the drop-out fee; largely no cell coverage; conditions and gear rationale; RDs may refuse under-prepared racers without refund. |
| S4 | Mandatory gear list | https://www.thedrift100.com/the-gear/ | Per-race mandatory gear (blinkie light, 0°F-rated sleeping bag, tent or true bivy, stove with at least 4 oz of fuel, and more); gear checked Thursday; racers must start and finish with all gear. |
| S5 | Timeline page | https://www.thedrift100.com/schedule/ | Thursday gear check at the Sublette County Library (Lovett Room) and prerace meeting; "9:00 AM: The Drift 100 starts"; Sunday 5:00 PM all courses close; start may move back one hour near zero temperatures; driving directions to the trailhead and lodge. Weekday-date pairs are the 2025 race's (stale). |
| S6 | Official course GPX download | https://drive.google.com/file/d/15pjbQ-uvs6j8rOZO3dhF-HLRqoIjV-gf/view | Geometry authority (linked "GPX Download" on S2): CalTopo export, 2,510 track points, no elevations, GPS length 103.08 miles; waypoints Start (43.222924,-110.009509), Strawberry (43.461809,-109.972126), Sheridan (43.625906,-110.022268), Warm Springs (43.572048,-109.813274), Green Creek Safety Shelter (omitted), Finish Kendall Valley Lodge (43.223588,-110.021717). `db/events/the-drift-100.gpx` copies the track points exactly and the five station-relevant waypoints. |
| S7 | Organizer CalTopo course map | https://caltopo.com/m/N564 | Interactive companion linked from S2. |
| S8 | UltraSignup 2027 registration page | https://ultrasignup.com/register.aspx?eid=15694 | "The Drift 100 - March 12, 2027"; divisions 100 Mile Ski / 100 Mile Bike / 100 Mile Run; "Registration Opens Thu. Oct 1, 2026 @ 12:00 AM MT". The 2026 page (did=131889) carries results and the "See the 2027 event" chain. |

## Claim-level decisions

- **Name.** "The Drift 100" — the site's name for the 100-mile race
  (S1/S2); run, fat bike, and ski divisions share the course and cutoffs.
- **Registration status.** `not_open` — opens October 1, 2026 (S8).
- **Lottery.** `false` — direct registration, but qualification is required
  and Race Directors approve entries (S2/S3); recorded in notes.
- **Cutoffs.** Leave-by clocks from the aid table: 24.9 = 10:00 PM (780);
  50 = 1:00 PM (1,680); 67.3 = 8:00 PM (2,100, table prints 33 hours);
  83.5 = 4:00 AM (2,520 across the DST change, table prints 41); finish
  101 = 5:00 PM (3,300). `cutoff_hours` 55.
- **Station passes.** 6: the Start, Strawberry twice (24.9 and 83.5 — the
  course's upper loop), Sheridan (50), Warm Springs (67.3), and the
  Finish. Point-to-point with a top loop, so mid passes are unlabeled per
  the domain vocabulary.
- **Crew.** `false` everywhere (decision 4).
- **Pacers.** `false` everywhere — explicit FAQ ban.
- **Drop bags.** `false` everywhere (Start `null`) — "no drop bags,
  outside assistance or gear drops"; the Warm Springs allergy container is
  noted on that pass, not recorded as a drop bag.
- **Medical.** `null` everywhere — no published medical service;
  snowmachine evacuation for racers who miss cutoffs after the first
  station (a first-station miss returns to the start).
- **Elevation series.** USGS 3DEP spot elevations per nominal table mile
  along the official line (which is 2D); station spots at waypoint
  coordinates. Organizer gain figure "over 9,000 ft" recorded as 9,000.
- **Follow.** Trackleaders tracking — every 100-mile racer must
  carry a tracking device (rentals encouraged; personal SPOT or InReach
  allowed). Results on UltraSignup (S8's chain).

## Stale-source traps

- The TIMELINE page's weekday-date pairs are the 2025 race's; re-check
  it (and the emailed schedule) closer to race day.
- The home page's "REGISTRATION OPENS 11/01/24 @ MIDNIGHT MST" block is
  two seasons old; UltraSignup says October 1, 2026 for 2027.
- The course page says the route may be modified before race day and a
  course GPX with aid stations "will be emailed closer to race day" —
  re-check geometry against S6/S7 near the race.
- run100s' 48-hour cutoff matches a sentence still in the course page's
  Section 1 narrative ("Remember you have 48 hours"); the aid table's
  55-hour frame governs.
- The start may be pushed back one hour if temperatures are around zero
  (S5) — the recorded 9:00 AM start is the scheduled one.
- The course page's "Gear check will take place Thursday March 12th"
  pairing is the 2026 race's (March 12, 2027 is race Friday), and its 6
  pm prerace-meeting time conflicts with the timeline's 5:30 pm.

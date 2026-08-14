# Hell Hole Hundred (2027) source audit

Verified on 2026-08-14. This audit uses only Palmetto Ultras material:
the UltraSignup 2027 listing (reached from the palmettoultras.com race
card), the Hell Hole Runner Guide (the Canva working document the site
links), and the two loop GPX files the guide serves from Google Drive.
It records what those sources actually establish; it does not treat an
organizer label as proof that a fact is current or internally
consistent.

## Bottom line

The record is publishable with a source warning. The 2027 UltraSignup
listing is fully 2027-frame: the 100 starts Friday, June 4, 2027 at
7:00 PM from the Jericho Horse Trail trailhead in the Francis Marion
National Forest (Bethera, SC), under a 33-hour cutoff with published
final-loop gates, open registration closing May 31, 2027. The Runner
Guide's loop table composes the 100 as one 18.3-mile loop followed by
five 16.3-mile loops (99.8 miles), names the three stations with full
coordinates, and links loop GPX files whose lengths and station
crossings corroborate the frame.

Recorded discrepancies and decisions:

1. **run100s is stale.** Its 30-hour cutoff has no counterpart: the
   2027 listing and the guide both say 33 hours for the 100.
2. **Frame.** The guide's loop-count table governs: the 100M column
   runs 18.3 then 16.3 ×5, summing to 99.8 miles (the race is billed
   as 100 miles; the GPX sequence GPS-measures 99.71). Station miles
   chain the guide's per-loop aid positions (about 7 and 13 on the
   18-mile loop; about 7 and 11.44 on the 16-mile loop) onto that
   frame.
3. **Geometry corroboration.** The 16-mile loop GPX GPS-measures
   16.36 miles with station crossings at 6.74 (Irishtown, published
   ~7) and 11.25 (Yellowjacket, published 11.44), returning to the
   hub at 16.30 exactly; the 18-mile loop GPX measures 17.91. The
   published figures govern pass miles; the GPX files are the
   geometry and elevation authority (elevations in meters, 13-43
   feet — coastal swamp flat).
4. **Cutoffs.** The 2027 listing itself publishes the ladder: 33
   hours total plus final-loop gates — start the final loop by 12:00
   AM (the hub at 83.5), Irishtown by 1:45 AM (90.5), Yellowjacket
   by 2:55 AM (94.94) — all Sunday clocks from the Friday 7:00 PM
   start (1,740 / 1,845 / 1,915 minutes; the finish 1,980).
5. **Guide vintage.** The Runner Guide is a working document still
   carrying 2026 prints (packet-pickup dates of June 5-6, "hats for
   2026"); the 2027 listing carries the 2027 starts and cutoffs,
   which match the guide's structural content (the Warbird pattern).
   The listing's "NEW for 2027" 10k note confirms active 2027
   maintenance.
6. **Stations and support.** Three stations — the start/finish hub
   (33.201813, -79.767844), Irishtown Road (33.12649, -79.77589),
   and Yellowjacket Road (33.160930, -79.756077) — all fully
   stocked (Skratch Lemon Lime, water, sodas, ultra snacks; meals at
   the hub), each with a porta potty, cupless. Crew may access
   runners at all three (tight fire roads; the guide discourages
   Irishtown crewing unless necessary). Pacers join 100-milers any
   time after loop 3 (the hub at 50.9) at any station, one at a
   time with a shared bib and waiver; no muling. Gear/drop bags at
   the hub only ("There are no drop bags at Irishtown and
   Yellowjacket"); 100-milers may pitch a staked canopy at the hub.
7. **Climb figures.** The guide's map pages print 125 feet of gain
   for the 16-mile loop and 141 for the 18-mile loop; the 100M
   arithmetic gives 766 feet, recorded with the prints documented.
   No loss figure is published (loops return to their start).
8. **Medical.** "We have basic medical supplies" is a race-wide
   statement with no station-level column; `med` stays null
   everywhere. A headlamp is required at night; no light, no
   continuing.

## Source register

All URLs below were opened or downloaded on 2026-08-14.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | UltraSignup 2027 listing | https://ultrasignup.com/register.aspx?did=140267 | 2027 frame: June 4-6, 2027; the 100 at 7:00 PM Friday; 33 hours with the final-loop gates (12:00 AM / 1:45 AM / 2:55 AM); three stations described; pacer and crew rules; trailhead coordinates; open, closes May 31, 2027; no refunds, pregnancy/postpartum deferral; results tabs 2020-2026. Reached from the palmettoultras.com race card. |
| S2 | Hell Hole Runner Guide (Canva working document) | https://www.canva.com/design/DAGAQjh7Kbs/qav6EeuSSOQXNeylU4c8vg/view | The loop-count table (100M: 18.3 + 16.3 ×5); per-loop aid positions (~7/13 and ~7/11.44); station coordinates; gear-drop, canopy, pacer, crew, and safety rules; the loop GPX links; 2026-vintage prints (decision 5). |
| S3 | 16-mile loop GPX (guide link, Google Drive) | https://drive.google.com/file/d/1n1ocoH4nQvtSAnYX5YPaTx_y8ts5t35s/view | Geometry and elevation authority for loops 2-6: 612 track points with elevations, 16.36 GPS miles, hub-to-hub. |
| S4 | 18-mile loop GPX (guide link, Google Drive) | https://drive.google.com/file/d/1z29EsKsmIIs8EGlMyrH-SieB5h3pFPqy/view | Geometry and elevation authority for loop 1: 643 track points with elevations, 17.91 GPS miles, hub-to-hub. `db/events/hell-hole-100.gpx` concatenates S4 once and S3 five times. |
| S5 | palmettoultras.com home | https://www.palmettoultras.com/ | The Hell Hole race card (JUNE 4-6, linked to the 2027 listing) and the HELL HOLE RUNNER GUIDE link; club background (Palmetto Ultras took over Eagle Endurance's races in 2024). |

## Claim-level decisions

- **Name.** "Hell Hole Hundred" (S1).
- **Registration status.** `open` (S1; closes May 31, 2027).
  **Lottery.** `false` — direct registration.
- **Cutoffs.** Four: the hub at 83.5 by 12:00 AM (1,740), Irishtown
  90.5 by 1:45 AM (1,845), Yellowjacket 94.94 by 2:55 AM (1,915),
  and the finish at 33 hours — 4:00 AM Sunday, June 6 (1,980).
  `cutoff_hours` 33.
- **Station passes.** 19: the Start, seventeen mid-race passes over
  three locations (loop 1: Irishtown 7.0, Yellowjacket 13.0, hub
  18.3; loops 2-6 add 16.3 each: Irishtown 25.3/41.6/57.9/74.2/90.5,
  Yellowjacket 29.74/46.04/62.34/78.64/94.94, hub
  34.6/50.9/67.2/83.5), and the Finish at 99.8.
- **Crew.** `true` everywhere — crew may access runners at all three
  stations, and the hub is the crew base with canopies.
- **Pacers.** `true` from the hub at 50.9 (after loop 3) through
  Yellowjacket 94.94; `false` before and at the Finish.
- **Drop bags.** `true` at the hub passes (18.3, 34.6, 50.9, 67.2,
  83.5); `null` at the Start; `false` elsewhere (no bags at
  Irishtown or Yellowjacket; the Finish is the gear-drop's home).
- **Medical.** `null` everywhere (decision 8).
- **Elevation series.** The concatenated loop GPX elevations per
  nominal mile (16-43 ft); station spots at each pass's mile.
- **Follow.** No live tracking published; results on UltraSignup.

## Stale-source traps

- The Runner Guide is a 2026-vintage working document ("I RECOMMEND
  SAVING THE LINK AND PERIODICALLY CHECKING FOR UPDATES"); re-check
  it as 2027 approaches for loop or station changes.
- The guide's packet-pickup dates and swag notes are 2026's; the
  2027 listing's packet section says times are TBD.
- The AllTrails maps require an account for GPX export; the Drive
  links are the open geometry surface.
- run100s' 30-hour cutoff is superseded (33 hours).

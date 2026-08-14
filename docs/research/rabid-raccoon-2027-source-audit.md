# Rabid Raccoon 100 (2027) source audit

Verified on 2026-08-14. This audit uses only Wolf Creek Race
Management material: the Rabid Raccoon 100 RunSignup site (home,
Race Info, Course Maps, Aid Stations, Crew Access, and FAQs pages)
and the organizer plotaroute course map the Course Maps page links.
Elevations come from USGS 3DEP point queries because the plotaroute
data carries no altitudes. It records what those sources actually
establish; it does not treat an organizer label as proof that a fact
is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The RunSignup site
is 2027-frame where it counts: the home page banners the 6th annual
running June 4-6, 2027 in Beaver County, PA, and the 100-mile
registration card is open ($250) with the June 5, 4:00 AM - June 6,
4:00 PM window (36 hours). The course is eight 12.5-mile loops at
Brady's Run Park from The Rec Center, with Four Seasons hit twice
per loop, one unmanned water stop, and the organizer plotaroute
route (100.25 GPS miles, circular) carrying markers for all three
station locations plus the start/finish.

Recorded discrepancies and decisions:

1. **run100s is stale on climb.** Its 16,900-foot figure has no
   counterpart: the organizer plotaroute route publishes 4,596 m of
   ascent (15,080 ft), the only total on any surface, and it is
   recorded with the conversion documented.
2. **Frame.** 100 miles over eight 12.5-mile loops (the FAQs'
   "12.5 mile loop" and the loop counts on the registration cards);
   the plotaroute line GPS-measures 100.25 (its published Distance
   field converts to 100.36).
3. **In-loop station miles are line-derived.** No chart of
   within-loop miles exists; the plotaroute line's scaled crossings
   place Four Seasons at 1.96 and 8.64, the water stop at 6.19, and
   The Rec Center at 12.5 per loop, and passes chain those onto the
   loop bases. The organizer's only printed mid-course mile — Four
   Seasons at MILE 95.5 in the cutoff schedule — sits 0.64 below
   the line's scaled 96.14 for that pass; the printed 95.5 governs
   it, with a pass note.
4. **Cutoffs.** Leave-by and firm: "Cut-off times are departure
   times, NOT arrival times. If you're not out of the station by
   the cut-off, your race is over." Two clocks: Four Seasons 2:00
   PM Sunday at mile 95.5 (2,040 minutes from the 4:00 AM Saturday
   start) and The Rec Center 4:00 PM Sunday at the finish (2,160 —
   the 36-hour total).
5. **Stations.** Two locations plus a water stop, all marked on the
   organizer route: The Rec Center (start/finish/main, marker
   40.7318808, -80.3364301; the venue is Brady's Run Park
   Recreation Facility, 121 Brady's Run Road, Beaver Falls, PA) and
   Four Seasons (40.7241231, -80.361832; the crew page's Google pin
   resolves to the Four Season Pavilion), plus the Water Station
   Only marker (40.7267511, -80.3426536). Stations stock first aid
   kits, water, Gatorade, soda, pizza, PB&J, bagels, cookies,
   bananas, granola bars, and candy; the 100 gets 23 staffed
   station passes (two on loop one's card since The Rec Center is
   the start).
6. **Crew.** Both staffed stations are crew-accessible with parking
   (Bradys Run Road closes during the race, so crews drive around
   between them); reserved indoor spots at The Rec Center go first
   come.
7. **Pacers.** No pacer provisions are published on any surface
   (the 5K ad's "Pacer? Crew Member?" is marketing); pacer flags
   are false everywhere with notes.
8. **Drop bags.** At each staffed station (Four Seasons and The Rec
   Center), labeled with number and name, returned to the start
   after stations shut; runners or crew may drive to retrieve
   early.
9. **Medical.** Stations carry first aid kits — recorded as a note,
   with `med` null everywhere (no station-level medical staffing is
   published).
10. **Mixed page vintages.** The FAQs still print 2026 clocks
    ("100 Mile: 4:00 AM on 5/30", the 2026 transfer deadline, and a
    2025 pre-race email date) while the home and Race Info cards
    are 2027-frame; the cards govern dates and the FAQs supply the
    standing rules (the Warbird pattern).
11. **Elevation.** The plotaroute data carries no altitudes, so the
    series and station spots use USGS 3DEP point samples along the
    scaled line.

## Source register

All URLs below were opened or downloaded on 2026-08-14.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Rabid Raccoon 100 RunSignup site (home and Race Info) | https://runsignup.com/Race/PA/Hookstown/RabidRaccoon100 | 2027 frame: June 4-6, 2027, 6th annual; the 100-mile card (8 loops, $250, June 5 4:00 AM - June 6 4:00 PM, ages 18+, open registration); the other distances' cards. |
| S2 | Aid Stations page | https://runsignup.com/Race/RabidRaccoon100/Page/Aid-Stations | Three stations per loop for the 100 (two on loop one), 23 staffed passes total, the unmanned water stop, and the stocking list. |
| S3 | Crew Access page | https://runsignup.com/Race/RabidRaccoon100/Page/Crew-Access | Both stations crew-accessible; the Four Seasons and Rec Center Google pins (Four Season Pavilion 40.7241617, -80.3617523; Brady's Run Park Recreation Facility 40.7314906, -80.3369397); Bradys Run Road closure; reserved indoor spots. |
| S4 | FAQs page | https://runsignup.com/Race/RabidRaccoon100/Page/FA-Qs | The 36-hour total; the firm leave-by cutoff language with the Four Seasons 2:00 PM (mile 95.5) and Rec Center 4:00 PM clocks; drop-bag rules; the 12.5-mile loop description with the creek crossing; course markings; Western States qualification; 2026-frame prints (decision 10). |
| S5 | Organizer plotaroute course map (100 Mile) | https://www.plotaroute.com/route/2675516 | Geometry authority: the full eight-loop route (6,936 points, 100.25 GPS miles, circular, ascent 4,596 m) with the Rec Center, Four Seasons, Water Station Only, and Start/Finish markers. `db/events/rabid-raccoon-100.gpx` copies the line exactly and the station markers. |
| S6 | USGS 3DEP point elevation service | https://epqs.nationalmap.gov/v1/json | Elevation authority for the series and station spots (the plotaroute data carries no altitudes). |

## Claim-level decisions

- **Name.** "Rabid Raccoon 100" (S1).
- **Registration status.** `open` (S1). **Lottery.** `false` —
  direct registration.
- **Cutoffs.** Two leave-by clocks (decision 4): Four Seasons 95.5
  at 2:00 PM Sunday (2,040) and the finish at 4:00 PM Sunday
  (2,160). `cutoff_hours` 36.
- **Station passes.** 33: the Start at The Rec Center, thirty-one
  mid-race passes over three locations (per loop: Four Seasons at
  base+1.96, the water stop at base+6.19, Four Seasons at
  base+8.64 — loop eight's second pass pinned at the printed 95.5 —
  and The Rec Center at each loop end), and the Finish at 100.0.
- **Crew.** `true` at every Four Seasons and Rec Center pass
  including the Start and Finish; `false` at the water stop.
- **Pacers.** `false` everywhere (decision 7).
- **Drop bags.** `true` at every staffed mid-race pass (Four
  Seasons ×16, The Rec Center ×7); `null` at the Start; `false` at
  the water stop and the Finish (bags return to the start after
  stations shut).
- **Medical.** `null` everywhere (decision 9).
- **Elevation series.** USGS 3DEP per nominal mile; station spots
  at the marker coordinates.
- **Follow.** Live text notifications are offered through the
  site's Live Text Notifications page; results post on RunSignup.

## Stale-source traps

- The FAQs' clocks and deadlines are 2026-frame (decision 10);
  re-check them as 2027 approaches.
- The aid-station food list is "released in an email closer to the
  race date."
- The plotaroute route was last updated July 5, 2024; re-check for
  a course revision before the 2027 running.
- run100s' 16,900-foot climb has no counterpart (the route's
  4,596 m / 15,080 ft is the only published total).

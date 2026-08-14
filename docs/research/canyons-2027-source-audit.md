# Canyons 100M (2027) source audit

Verified on 2026-08-14. This audit uses only canyons.utmb.world material:
the 100M race page, the registration page, the Crew & Spectators page,
and the aid station chart PDF and course GPX the race page links. It
records what those sources actually establish; it does not treat an
organizer label as proof that a fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The 2027 100M page pins
Friday, April 23, 2027 at 12:00 from the China Wall trailhead with a
35-hour maximum and a downtown Auburn finish; the registration page says
2027 registration is open ($498.53 plus fees, closing April 18, 2027);
the linked aid chart (revision 4/22/26) carries all twenty pass rows with
arrive-by cutoffs and drop/crew/pacer flags whose clocks map exactly onto
the noon-start 35-hour frame; and the linked official GPX carries the
course with elevations and fifteen station waypoints.

Recorded discrepancies and decisions:

1. **run100s is stale.** Its 32-hour cutoff and 17,000-foot climb have
   no counterpart as recorded: the page says 35 hours, and the gain
   figures are decision 2's set.
2. **Four gain figures on the organizer's own surfaces.** The page
   overview says approximately 17,000 feet; the header says 5,550 m
   (18,208 ft); the course description says "Approximately 18,000 feet
   of vert, 22,000 of descent"; the chart's cumulative columns reach
   18,043 and 21,479. The description's rounded pair (18,000/22,000)
   is recorded and the rest documented.
3. **2026-revision documents on the 2027 page.** The chart is stamped
   Revision 4/22/26 and the GPX is named "2026 ... Course Alternate";
   both are the documents the 2027 page links today (the Warbird
   pattern), and the Crew & Spectators page states 2026 information
   stands until roughly 6-8 weeks before the 2027 race. The chart
   warns the course is subject to change under permitting.
4. **Frame.** The chart's cumulative column ends at 100.3 (governs
   pass miles); the page header says 161 km; the GPX GPS-measures
   98.60 miles.
5. **Cutoff style.** The chart publishes arrive-by clocks ("Cut-Off
   Time") at eight stations plus the finish; from the 12:00 PM start
   they convert to 390/465/570/900/1050/1200/1440/1650/2100 minutes,
   internally consistent with the 35-hour maximum (11:00 PM Saturday).
6. **No-aid and limited rows.** The Swinging Bridge row is labeled
   N/A (a turnaround, recorded food and water false with direction
   Turnaround); the two No Hands rows are hydration stations and the
   two Coffer Dam rows water-only (food false).
7. **Pacers and crew.** The chart marks pacers only at the two Cool
   passes (61.3, 73.5) and crew at Michigan Bluff, Foresthill, Drivers
   Flat, and both Cool passes; the finish row carries no flags (the
   public downtown finish is noted). Drop bags at Foresthill and both
   Cool passes.
8. **Medical.** No station-level medical column exists; registration
   includes race-wide medical assistance. `med` stays null everywhere.

## Source register

All URLs below were opened or downloaded on 2026-08-14.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Canyons 100M race page | https://canyons.utmb.world/races/100M | Start Friday 23rd April 2027, China Wall Trailhead, 12:00; Max Allowed Race Time 35 Hours; 161 km / 5,550 m+ header; Running Stones 4 and Finals Access; the course description (Devil's Thumb, Swinging Bridge, Michigan Bluff, Foresthill, Cal Street, Rucky Chucky, K2, Cool, No Hands Bridge, Ann Trason's White Bridge) with "Approximately 18,000 feet of vert, 22,000 of descent"; the chart and GPX links; "Course maps subject to" change note. |
| S2 | Registration page | https://canyons.utmb.world/runners/registration | "2027 REGISTRATION NOW OPEN"; race dates April 22-25, 2027 with the 100M on April 23; $498.53 (+$53.46 fees); UTMB Community charity bibs; inclusions (aid access, timing, medical assistance, cup, buckle, post-race food); non-refundable with any-reason deferral through March 24, 2027; closes April 18, 2027; 18+ for the 100M. |
| S3 | 100 Mile Aid Station Chart PDF | https://res.cloudinary.com/utmb-world/image/upload/v1776896940/canyons/2026/Aid%20Station%20Charts/2026_The_Canyons_Endurance_Runs_by_UTMB_100_mile_Aid_Station_Chart_Imperial_8312cc28c5.pdf.pdf | The twenty-row pass table (miles, per-segment and cumulative gain/loss, arrive-by cutoffs, drop/crew/pacer flags); revision 4/22/26; the CalTopo-derivation and course-change footnotes. |
| S4 | Official 100M course GPX | https://res.cloudinary.com/utmb-world/raw/upload/v1776808245/canyons/2026/GPX%20Files/2026_Canyons_Endurance_Runs_by_UTMB_100_mile_Course_Alternate_3b179d0806.gpx | Geometry and elevation authority: 6,636 track points with elevations (551-5,016 ft at chart-mile resolution) and fifteen station waypoints (shared waypoints for the repeated Deadwood, Cool, Browns Bar, No Hands, and Coffer Dam stations). `db/events/canyons-100.gpx` copies points and waypoints exactly. |
| S5 | Crew & Spectators page | https://canyons.utmb.world/crew | "2026 Crew & Spectator Info Below ... We will update to the 2027 ... approximately 6-8 weeks from the 2027 race weekend"; shuttle and parking guides. |
| S6 | Site home | https://canyons.utmb.world/ | Event window April 22-25, 2027; UTMB World Series framing; UTMB Live link. |

## Claim-level decisions

- **Name.** "Canyons 100M" — the 100-mile race of The Canyons Endurance
  Runs by UTMB.
- **Registration status.** `open` (S2). **Lottery.** `false` — direct
  registration with Running Stones earned, not drawn.
- **Cutoffs.** Nine arrive-by clocks (decision 5). `cutoff_hours` 35.
- **Station passes.** 20 chart rows: the Start, thirteen aid stations,
  two hydration and two water-only passes, the Swinging Bridge
  Turnaround, and the Finish.
- **Crew.** `true` at Michigan Bluff, Foresthill, Drivers Flat, and
  both Cool passes; `false` elsewhere per the chart's crew column.
- **Pacers.** `true` at the two Cool passes only.
- **Drop bags.** `true` at Foresthill and both Cool passes; `null` at
  the Start; `false` elsewhere.
- **Medical.** `null` everywhere (decision 8).
- **Elevation series.** The official GPX's elevations per nominal chart
  mile (551-5,016 ft; the course drops from the 5,016-foot China Wall
  start toward the American River canyons); station spots at each
  pass's chart mile.
- **Follow.** UTMB Live tracking; results on the site's results page.

## Stale-source traps

- The chart and GPX are 2026-revision files; the Crew & Spectators
  page promises 2027 updates 6-8 weeks out — re-check all three then.
- The GPX file name says "Course Alternate"; the chart warns the
  course may change under permitting.
- The organizer's four gain figures disagree (decision 2).
- run100s' 32-hour cutoff is superseded by the page's 35 hours.

# San Diego 100 (2027) source audit

Verified on 2026-08-14. This audit uses only sandiego100.com material:
the home, Event Info, 2027 Course, Registration, and 2027 Racebook
pages, the aid station chart and official course GPX the course page
links, the 2026 Racebook PDF the racebook page serves while "the 2027
racebook isn't quite ready", and the UltraSignup 2027 and 2026
listings. It records what those sources actually establish; it does
not treat an organizer label as proof that a fact is current or
internally consistent.

## Bottom line

The record is publishable with a source warning. The site is
2027-frame: the race starts Friday, April 30, 2027 at 6:00
AM from Lake Cuyamaca (15027 Highway 79, Julian, CA) and ends Saturday,
May 1 at 2:00 PM under a 32-hour maximum with intermediate leave-by
cutoffs; the UltraSignup listing confirms the date, the 6:00 AM start,
and the January 1, 2027 registration opening; the course page presents
"the final table of aid stations (with cut-offs) for the 2027 event"
(sixteen rows over fourteen locations) and links the official course
GPX (10,019 route points with elevations, 100.12 GPS miles).

Recorded discrepancies and decisions:

1. **The home banner contradicts every other surface.** "SD100 2027
   Registration is OPEN!" sits above paragraphs saying registration
   opens January 1, 2027 at 12:01 AM; the Event Info and Registration
   pages agree on January 1, and the UltraSignup listing says
   "Registration Opens Fri. Jan 1, 2027 @ 12:00 AM PT". `not_open`
   governs and the banner is documented.
2. **The Hammer's Hideaway cutoff prints 10:15 AM on the 2027 chart —
   an impossible clock.** At mile 51.8, 10:15 AM Saturday (28h15m)
   would postdate the next cutoff (Penny Pines 1, mile 59.2, 1:00 AM
   Saturday). The chart's own ladder (Sweetwater 7:00 PM → Penny
   Pines 1 1:00 AM) and the 2026 Racebook's chart print (10:15 PM)
   both give 10:15 PM Friday — 16h15m, pace-consistent with every
   neighboring row. 10:15 PM / 975 minutes governs with a
   pass-specific note (the Sugar Creek pattern: a chart's own
   internal evidence outranks its typo).
3. **Four climb figures.** The 2027 Event Info page says "just over
   13,000 feet of climbing/descent each"; the 2026 Racebook says
   approximately 15,000 each and its FAQ says runners report
   13,000-15,500; the Garmin course from the official GPX shows
   12,607/12,604. The current Event Info figure (13,000/13,000)
   is recorded and the rest documented, including a fifth figure: the
   UltraSignup listing's body text still says approximately 15,600
   feet of climbing. run100s' 13,165/13,180 has no first-party
   counterpart.
4. **Station-count phrasing.** Event Info says "16 well-stocked aid
   stations, with drop bags available at 8"; the chart carries
   fourteen mid-race rows (two of them unmanned water-only) over
   twelve mid-race locations plus the start/finish. The chart's rows
   govern the pass table; the counts are documented.
5. **Water-only naming.** The chart's second water-only row is "Pine
   Creek Road (water only)" at 49.5; the Racebook's rules and
   walk-through call the same row Big Oak ("you hit the water
   station at Big Oak followed by a fun 2 downhill miles ... to
   Hammer's Hideaway"). The chart name governs; the alias is noted.
   Runners cannot withdraw from the race at water-only stations.
6. **Crew-list miles.** The Racebook's crew station list prints
   Pioneer Mail at 84.3 and Sunrise at 91.5 against the chart's 84.6
   and 91.6; the chart governs.
7. **Drop-bag set.** The chart marks drop bags at Cuyamaca Peak,
   Sweetwater, Hammer's Hideaway, Penny Pines 1, Red Tail Roost,
   Penny Pines 2, Pioneer Mail, Sunrise (the Racebook's eight
   "designated drop bag aid stations"), and the Finish row (bags
   return to Lake Cuyamaca about an hour after each station closes).
8. **Crew set.** Designated crew stations: Lake Cuyamaca
   (start/finish), Green Valley, Sweetwater, Meadows, Red Tail Roost,
   Pioneer Mail, and Sunrise. Penny Pines lost crew access in 2024.
   Crews need an SD 100 parking pass; meeting a runner anywhere else
   risks penalties or disqualification.
9. **Pacers.** One at a time from Sweetwater (41.4), switching only
   at Meadows, Red Tail Roost, Pioneer Mail, and Sunrise; no muling;
   Solo Division runners take no crew or pacers. Friends may run in
   from the lakeside picnic tables (about a half mile out) to the
   finish.
10. **Medical.** A medical director, medical care volunteers, and
    CPR/wilderness-first-aid-trained people "at the various aid
    stations" — no per-station medical column exists, so `med` stays
    null everywhere. No pain relievers at any station.
11. **Ordinal and listing-text conflicts.** The home page calls 2027
    the 25th annual running; the Event Info page prints "This is the
    26th Annual Event." The UltraSignup listing's body text also
    carries a 200-runner first phase to April 15 and a $100 donation
    against the site's 300-runner cap, April 1 close, and $105 —
    the site's own pages govern and the ordinal is left out of the
    record.
12. **Elevation.** The official GPX carries elevations (3,639-6,479
    ft); the series samples it per nominal chart mile (GPS 100.12
    scaled to the chart's 100.6) and every chart GPS coordinate sits
    within 0.013 mile of the route line.

## Source register

All URLs below were opened or downloaded on 2026-08-14.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Site home | https://sandiego100.com/ | 2027 frame: the 25th annual race begins Friday, April 30, 2027 at 0600; registration opens January 1 first-come first-served (cap 300, waitlist); qualification (a sub-13-hour 50-mile or a 100k/100-mile finish January 1, 2025-April 1, 2027); the 6-hour volunteer requirement or $105 TrailFit donation; the one-hour early start for runners over 60; cupless; the contradictory "Registration is OPEN!" banner (decision 1). |
| S2 | Event Info page | https://sandiego100.com/sample-page/ | April 30 6:00 AM to May 1 2:00 PM, 32 hours; "16 well-stocked aid stations, with drop bags available at 8"; "just over 13,000 feet of climbing/descent each"; 85% single track; Lake Cuyamaca venue; crews limited to one vehicle; the Solo Division; pacers for the second half for supported runners. |
| S3 | 2027 Course page | https://sandiego100.com/course/ | "The final table of aid stations (with cut-offs) for the 2027 event"; the maps PDF, official GPX, Garmin course, and turn-by-turn links; course-marking cautions. |
| S4 | 2027 aid station chart | https://www.predsci.com/~pete/sd100/2025-sd-100-miles-chart.png | The sixteen-row pass table: miles, GPS coordinates, open times, cutoff clocks, drop/crew/pacer columns; the 10:15 AM misprint (decision 2). The file name says 2025; the course page presents it as the final 2027 table. |
| S5 | Official course GPX | https://www.predsci.com/~pete/sd100/san-diego-100-mile-endurance-run.gpx | Geometry and elevation authority: a GaiaGPS route of 10,019 points with elevations (3,639-6,479 ft), 100.12 GPS miles. `db/events/san-diego-100.gpx` converts the route points to track points exactly and adds fourteen station waypoints from the chart's GPS column. |
| S6 | 2026 Racebook PDF | https://www.predsci.com/~pete/sd100/SD100-Participant-Guide-2026.pdf | Served by the 2027 Racebook page while the 2027 book "isn't quite ready": drop-bag rules (16x12x6, 5:30 AM deposit, returns), pacer rules (Sweetwater start, four switch points), crew rules (parking passes, designated stations), Solo Division, cutoff enforcement ("the runner must leave the aid station at or before the mandatory cutoff time"), aid menus, Geo Tracks GPS tracking with ultralive.net times, and its own chart print (10:15 PM at Hammer's). |
| S7 | UltraSignup 2027 listing | https://ultrasignup.com/register.aspx?did=139173 | "San Diego 100 - April 30, 2027"; "Friday, Apr 30, 2027 @ 6:00 AM"; "Registration Opens Fri. Jan 1, 2027 @ 12:00 AM PT". Reached via eid=203, the home page's registration link. Its body text lags the site (approximately 15,600 feet, a 200-runner first phase, a $100 donation) — decision 11. |
| S8 | UltraSignup 2026 listing | https://ultrasignup.com/register.aspx?did=116822 | 2026 results (the home page's results pointer). |

## Claim-level decisions

- **Name.** "San Diego 100" — the San Diego 100 Mile Endurance Run
  (house short form).
- **Registration status.** `not_open` — opens January 1, 2027
  (decision 1). **Lottery.** `false` — first-come, first-served with
  a qualification standard and a waitlist after 300.
- **Cutoffs.** Thirteen leave-by clocks: Trout Pond 10:00 AM (240),
  Cuyamaca Peak 12:45 PM (405), Green Valley 3:30 PM (570),
  Sweetwater 7:00 PM (780), Hammer's Hideaway 10:15 PM (975; decision
  2), Penny Pines 1 1:00 AM (1,140), Meadows 2:45 AM (1,245), Red
  Tail Roost 4:45 AM (1,365), Per's Cabin 6:15 AM (1,455), Penny
  Pines 2 7:45 AM (1,545), Pioneer Mail 9:00 AM (1,620), Sunrise
  11:15 AM (1,755), finish 2:00 PM (1,920). `cutoff_hours` 32.
- **Station passes.** 16 chart rows over fourteen locations: the
  Start, twelve full-service passes, two unmanned water-only passes
  (Blue Ribbon 35.6, Pine Creek Road 49.5 — food false), and the
  Finish. Penny Pines 1 and 2 share one coordinate, as do the Start
  and Finish. No Turnaround rows exist on this loop.
- **Crew.** `true` at the Start, Green Valley, Sweetwater, Meadows,
  Red Tail Roost, Pioneer Mail, Sunrise, and the Finish (decision 8);
  `false` elsewhere.
- **Pacers.** `true` at Sweetwater, Meadows, Red Tail Roost, Pioneer
  Mail, and Sunrise (decision 9); `false` elsewhere.
- **Drop bags.** `true` at Cuyamaca Peak, Sweetwater, Hammer's
  Hideaway, Penny Pines 1, Red Tail Roost, Penny Pines 2, Pioneer
  Mail, Sunrise, and the Finish (decision 7); `null` at the Start;
  `false` elsewhere.
- **Medical.** `null` everywhere (decision 10).
- **Elevation series.** The official GPX's elevations per nominal
  chart mile (decision 12); station spots at each pass's chart mile.
- **Follow.** Geo Tracks GPS pods (link emailed pre-race) with
  station times on ultralive.net; the live-cast link posts on the
  sandiego100.com home page. Results on UltraSignup.

## Stale-source traps

- The 2027 Racebook "isn't quite ready" — the 2026 book carries the
  rules recorded here; re-check when the 2027 book posts.
- The chart PNG's file name says 2025 and its Hammer's cell prints
  10:15 AM (decision 2); re-check whether the organizer republishes.
- The home banner's "Registration is OPEN!" is contradicted by every
  other surface until January 1, 2027 (decision 1).
- The climb figures disagree across surfaces (decision 3).
- run100s' 13,165/13,180 climb figures have no first-party
  counterpart ("just over 13,000" each governs).

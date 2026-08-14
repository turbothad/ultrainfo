# The Pistol Ultra 100 (2027) source audit

Verified on 2026-08-13. This audit uses only the race's RunSignup-hosted
site (pistolultra.com): the home page, the Events listing, and the Course
Route, Runners-Info, Schedule, FAQ, and Pacers pages, plus the official
Imperial course GPX the course page links. It records what those sources
actually establish; it does not treat an organizer label as proof that a
fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The site is fully live
for March 13–14, 2027 (year 14): the Events listing sells the 100 Mile
(Saturday 8:00 AM EST start, 5:00 PM EDT Sunday end, 67 spots left at
verification), the Course Route page defines the 10-mile Imperial loop
with its three stations and links the official GPX, the FAQ publishes the
32-hour time limit and venue logistics, and the Pacers page publishes a
complete three-type pacer system. The 100 Mile runs ten Imperial loops.

Recorded discrepancies and decisions:

1. **Three finish-time surfaces.** The FAQ's time-limit table gives the
   50K/100K/100 Mile 32 hours and says "The course will officially close
   at 32 hours"; the Events listing ends the 100 Mile at 5:00 PM EDT
   Sunday — exactly 32 true elapsed hours from the 8:00 AM EST Saturday
   start across the March 14, 2027 spring-forward; the Schedule page's
   "4:00 PM Course Closes – All Races End" line instead matches the
   Sunday 10/20-mile races' 8-hour window. The FAQ and listing govern:
   `cutoff_hours` 32, finish clock 5:00 PM.
2. **run100s' 30-hour cutoff** has no counterpart on the current site
   (the FAQ says 32) and was not copied.
3. **Crew at stations.** The Course Route page: "Aid stations and warming
   areas are exclusively for registered runners, their active pacers, and
   race volunteers/support staff. Spectators and non-participating
   individuals must courteously avoid these areas." Woody's and Lucky's
   record crew false. The start/finish hub records crew true: the FAQ's
   designated runner canopy area sits there and Runners-Info says "Set up
   your own support crew area along the course."
4. **Woody's stocking.** The course page describes AS1 and AS3 as "fully
   stocked" but gives Woody's no descriptor; its food/water true rest on
   Runners-Info's blanket "Fully-Stocked Aid Stations" claim, noted in
   the shared station source note.
5. **No drop bags.** No page publishes a drop-bag service; the published
   self-support mechanism is the canopy area (one 10'×10' per runner,
   setup from noon Friday, no generators/outlets/stakes/camping tents).
   Drop is null everywhere with the canopy summary in metadata.
6. **Geometry.** The official Imperial GPX ("The Pistol - Imperial 100 M
   50M 20M 10M") carries 722 points with elevations; the loop
   GPS-measures 10.17 miles (3-foot closure) against the billed 10-mile
   frame, which governs pass miles. Station waypoints sit at each
   station's first loop mile; Woody's second pass (8.1) runs 317 feet
   from the first and Lucky's second (6.1) runs 525 feet from the first
   across the out-and-back greenway. The GPX's lone FINISH waypoint is
   omitted as redundant.
7. **Pacers from the gun.** The bicycle-pacer rule ("only one foot pacer
   is allowed per runner" during Saturday daylight) establishes that foot
   pacing is permitted from the start; every pass records pacer true
   with the day/night rules in notes.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Site home | https://www.pistolultra.com/ | "The Pistol, March 13 - 14, 2027, Alcoa, TN"; USATF Certified Course; awards (Double Barrel, Sheriff's Star, sub-24 and sub-12 recognition). |
| S2 | Events listing | https://www.pistolultra.com/Race/Events/TN/Alcoa/ThePistolCreekRun | 100 Mile: Saturday March 13 – Sunday March 14, 2027, start 8:00 AM EST, end 5:00 PM EDT, 67 spots left, $293.50 rising through race day; registration windows opened July 11, 2026; all other distances' schedules. |
| S3 | Course Route page | https://www.pistolultra.com/Race/ThePistolCreekRun/Page/Course-Route | The 10-mile Imperial loop (orange; 100 Mile = 10 loops, 50M/20M/10M shares) and 10.35-mile Metric loop (green; 100K/50K); stations: Long Run Store (start/finish at Springbrook Pool, fully stocked, warming areas), Woody's Near Famous (~1.9 and ~8.1), Lucky's (~4 and ~6.1, fully stocked); the aid-station exclusivity rule; official GPX/plotaroute/Strava links; course markings. |
| S4 | Runners Info page | https://www.pistolultra.com/Race/ThePistolCreekRun/Page/Runners-Info | Year 14; "up to 32 hours for the big ones"; Fully-Stocked Aid Stations; lit course; Springbrook Pool start/finish along Pistol Creek; "Set up your own support crew area along the course"; no pets. |
| S5 | Schedule page | https://www.pistolultra.com/Race/ThePistolCreekRun/Page/Schedule-Packet-Pickup | Friday packet pickup 2:00–6:00 PM at the Hilton Knoxville Airport; Saturday late pickup 6:30–7:30 AM; 7:55 AM 50K start; 8:00 AM 100K & 100 Mile start; Sunday "4:00 PM Course Closes – All Races End" (the 10/20-mile window; see decision 1). |
| S6 | FAQ | https://www.pistolultra.com/Race/ThePistolCreekRun/Page/FAQ | Time limits (100 Mile 32 hours; course closes at 32 hours; staff/medical may pull a runner who cannot finish the current or final lap); Springbrook Pool, 636 Vose Road; restrooms and porta-potties; the canopy area rules; parking by distance (100M at Springbrook); buckles; no alcohol; "registration will open this summer" (already open per S2). |
| S7 | Pacers page | https://www.pistolultra.com/Race/ThePistolCreekRun/Page/Pacers | Personal pacers (free registration, waiver, one numbered bib per runner, transferable, no limit on count); bicycle pacers (banned Saturday daylight, one per runner Saturday night and Sunday, lights required); official volunteer pacers at the main aid station in hourly shifts 9:00 PM Saturday–10:00 AM Sunday; equal station access for bibbed pacers; no muling. |
| S8 | Official Imperial GPX download | https://drive.google.com/file/d/16ONPOuUtiPtydGeoc-NZzjH_yP481cvR/view | Geometry and elevation authority ("The Pistol - Imperial 100 M 50M 20M 10M", linked from S3): 722 track points with elevations, loop 10.17 GPS miles, 3-foot closure, start/finish 35.793574,-83.977175. `db/events/pistol-ultra-100.gpx` copies the points exactly and adds three station waypoints. |

## Claim-level decisions

- **Name.** "The Pistol Ultra 100" — the site brands the weekend "The
  Pistol" / "The Pistol Ultra Run"; the 100 Mile is its flagship.
- **Registration status.** `open` — S2 sells all distances with live
  spot counts (opened July 11, 2026; the FAQ's "will open this summer"
  sentence predates the opening).
- **Lottery.** `false` — direct registration.
- **Cutoffs.** Finish only: 100 = 5:00 PM (1,920). `cutoff_hours` 32.
- **Station passes.** 51: the Start plus five passes on each of ten
  loops (Woody's +1.9, Lucky's +4, Lucky's +6.1, Woody's +8.1, Long Run
  Store +10), the last recorded as the Finish, with "Loop N" directions.
- **Crew.** `true` at the eleven Springbrook passes; `false` at all
  forty Woody's/Lucky's passes (decision 3).
- **Pacers.** `true` at every pass (decision 7).
- **Drop bags.** `null` everywhere — no published service; the canopy
  area is the self-support mechanism (decision 5).
- **Medical.** `null` everywhere — no station-level medical service is
  published; staff/medical may pull runners for time.
- **Elevation series.** The official GPX's elevations per nominal loop
  mile, repeated per lap (833–874 ft); station spots at the waypoints.
- **Follow.** No live tracking published; results on the site's
  RunSignup results page (raceId 55312).

## Stale-source traps

- run100s' 30-hour cutoff is superseded by the FAQ's 32.
- The Schedule page's "4:00 PM Course Closes – All Races End" line
  reads as a leftover of the Sunday short-race window; the FAQ and the
  100 Mile listing both say 32 hours / 5:00 PM EDT.
- The FAQ's "registration will open this summer" predates the July 11,
  2026 opening that S2 documents.
- The USATF certification is claimed as a badge; no certification code
  is published on the reviewed pages.

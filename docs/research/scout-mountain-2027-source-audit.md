# Scout Mountain 100 (2027) source audit

Verified on 2026-08-14. This audit uses only Scout Mountain Ultras
material: the scoutmountainultras.com home, Event Info, General Info,
Crew, and GPX Overview pages, the Aid Station Info Google Sheet the
Event Info page links, the official 100M GPX the GPX Overview page
serves, and the RunSignup race page. It records what those sources
actually establish; it does not treat an organizer label as proof
that a fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The home page
banners the 2027 return ("See you again on the first weekend in june
2027!"), and the standing structure is fully published: the 100M
starts 10:00 AM Friday at Lead Draw Trailhead — June 4, 2027, the
first weekend's Friday — and the aid table runs 102.7 miles to the
Mink Creek Group Site finish with a ten-clock cutoff ladder ending
10:00 PM Saturday (36 hours). The official 100M GPX carries the full
line with altitudes (46,134 points, 102.37 GPS miles) and a waypoint
for every station, including the Old Tom out-and-back marker at the
spur apex.

Recorded discrepancies and decisions:

1. **2027 registration is not yet posted.** The RunSignup race page
   still shows the June 5-6, 2026 frame (June 5, 2026 was a Friday;
   June 5, 2027 is a Saturday, so the header cannot be 2027's), and
   the home page's banner is the only 2027 print. `registration_status`
   is `not_open`; the standing pages carry the structure (the Warbird
   pattern).
2. **Three mile frames print; the aid table governs.** The table's
   100M column (15.7, 29.2, 36.2, 48.4, 61.1, 78.8, 85.2, 96.1) is
   the governing frame. The Event Info drop-bag and pacer prose
   prints 15.68/29.4/36.39/48.54/61.33/79.03/85.40/96.25 for the same
   stations, and the crew page prints Gibson Jack at "mile 47.8".
   Each affected pass documents its losing prints.
3. **run100s is stale on climb.** Its 23,800-foot figure has no
   counterpart: the General Info page's The Race section prints
   "~22,000 feet of vertical gain (and loss)" for the 100M, and the
   aid table's per-segment climbs sum to 21,430 up / 21,453 down.
   The printed ~22,000 is recorded for both gain and loss with the
   segment sums documented.
4. **Cutoffs.** The table prints ten clocks from the Friday 10:00 AM
   start: Walker Creek 12:00 PM Fri (120 elapsed minutes), Goodenough
   3:00 PM (300), South Fork 7:15 PM (555), West Fork 9:00 PM (660),
   Gibson Jack 12:45 AM Sat (885), City Creek 5:45 AM (1,185), West
   Fork 12:45 PM (1,605), Scout Mountain 3:30 PM (1,770), Big Fir
   8:00 PM (2,040), and the finish 10:00 PM Saturday (2,160). No
   arrival-versus-departure semantics are published.
5. **The Old Tom out-and-back.** The table rows at 19.0 and 22.1 are
   one water-only location — "at base of out-n-back to Old Tom
   Summit" — and the GPX's `03:WaterOnly` waypoint crosses the line
   twice (scaled 18.83 and 21.94). The summit row at 20.6 is the one
   Turnaround: the GPX's `04:OldTom Out-N-Back` waypoint crosses once
   at scaled 20.39 with a line altitude of 8,632 feet, matching the
   table's printed 8,630-foot segment ceiling. The summit row carries
   no aid.
6. **Crew.** The table's crew column (50M/100M only) marks Goodenough,
   South Fork, Gibson Jack, City Creek, and Scout Mountain as
   100M-only crew stations and both West Fork passes as 50M-and-100M;
   everything else prints NO or blank. The crew page's 100M list
   matches. Crews carry a per-runner vehicle tag from check-in, and
   West Fork is shuttle-only from the Crystal Summit Warming Hut lot
   (8:00 AM - 2:00 PM Saturday) — a window after the first West Fork
   pass's 9:00 PM Friday clock; the table's YES governs the flag with
   the window noted. The finish-row crew cell is blank, but the
   start-lines and crew pages route crews to the finish area on the
   Day Shuttle from Century High School until 10:00 PM, so the Finish
   records crew true with a note. The start records crew false per
   the table (the crew page lists the Lead Draw lot for drop-off).
7. **A crew-page boilerplate conflict at South Fork.** The vehicle
   permit line at South Fork carries "plus one pacer if a pacer is
   starting here", but the table and the Event Info pacer prose mark
   no pacer there (the same line at Scout Mountain matches a real
   pacer station). The table governs: pacer false at South Fork,
   documented on the pass.
8. **Pacers.** The table's column is literally "100-Miler Only Pacer
   Start/Finish Allowed?" — YES at West Fork (both), Gibson Jack,
   City Creek, Scout Mountain, and Big Fir, matching the Event Info
   prose's six join stations exactly. Cusick Creek's cell is blank
   (recorded false, documented); Elk Meadows prints NO. Pacers sign a
   waiver and wear a pacer bib; the Big Fir exchange sits a quarter
   mile from the aid station on the dirt road.
9. **Drop bags.** The table marks seven: Goodenough, South Fork, West
   Fork (both), Gibson Jack, City Creek, and Big Fir; Scout Mountain
   prints NO. Bags check in at the pre-race briefing, all bags are
   transported to the finish (Big Fir's late, after the last
   shuttle), and unclaimed bags go to Goodwill the following Friday.
10. **Medical.** No station-level medical column or staffing is
    published; `med` stays null everywhere.
11. **Elevation.** The official GPX carries altitudes, so the series
    and station elevations are the line's own values (scaled
    102.37 → 102.7). The table's printed segment floors corroborate:
    5,179 at the start (line 5,180), 7,573 at the Old Tom base
    (7,575), 4,821 at City Creek (4,820), 6,780 at Elk Meadows
    (6,781), and 5,154 at the finish (5,154).
12. **Line corroboration.** Every station waypoint's scaled crossing
    lands within about 0.3 mile of its table mile (Walker 5.16/5.3,
    Goodenough 15.49/15.7, South Fork 29.06/29.2, West Fork
    36.05/36.2 and 78.78/78.8, Gibson Jack 48.23/48.4, Cusick
    55.72/55.8, City Creek 61.05/61.1, water 41.94/42.1 and
    65.23/65.3, Elk Meadows 73.01/73.1, Scout Mountain 85.19/85.2,
    Big Fir 96.10/96.1, finish 102.70/102.7). The crew page's lot
    coordinates match the GPX waypoints at every shared station. The
    line also passes within 63 feet of the mile-42 water point again
    at scaled 77.16, where the table lists no row — no pass is
    recorded there.
13. **Waypoint handling.** The source GPX carries two West Fork
    waypoints (`06:` and `13:`) about six feet apart; the bundle
    keeps one. The bundle's waypoints carry nearest-track-point
    altitudes because the source waypoints have none. At 4.3 MB
    (46,134 track points copied exactly), this is the repository's
    largest course file.
14. **Qualifier and service requirement.** The home page prints
    "Scout Mountain Ultras 100M is a Hardrock Endurance Run
    qualifier", and General Info gives the 100M an eight-hour
    service requirement. Both are recorded in the notes. The home
    page also carries the field hold: at least fifty percent of the
    field is held for women, femme, and non-binary runners.
15. **A Scout Mountain lot-label nit.** The crew page's GPS list
    labels the Scout Mountain lot "for 100M and 50M runners ONLY"
    while the aid table's crew cell there prints "100M ONLY"; the
    table governs the flag, with the print noted on the pass.

## Source register

All URLs below were opened or downloaded on 2026-08-14.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | scoutmountainultras.com home | https://scoutmountainultras.com | The 2027 banner ("See you again on the first weekend in june 2027!"); the Hardrock Endurance Run qualifier print; the women/femme/non-binary field hold; tracking information posts here when available. |
| S2 | Event Info page | https://scoutmountainultras.com/event-info | Start lines (100M: 10:00 AM Friday at Lead Draw Trailhead; crews shuttle to the finish area), the Aid Station Info sheet link, planned foods per station, pacer rules (six join stations, waiver and bib, the Big Fir exchange), drop-bag rules, mandatory kit, course markings; its prose mile frame loses to the table (decision 2). |
| S3 | Aid Station Info sheet (Google Sheets) | https://docs.google.com/spreadsheets/d/1yVTdR4Rsr1NqwwZUic_BHCWTNbocpIxI | The governing table: 18 100M rows with miles, crew/drop-bag/pacer columns, the ten cutoff clocks, and per-segment low/high and gain/loss figures. |
| S4 | General Info page | https://scoutmountainultras.com/general-info | The Race's "~22,000 feet of vertical gain (and loss)" print; runner tracking (chip timing at every aid station except Cusick Creek and at the finish; $100 unreturned-chip fee); the drop-out rule; the eight-hour service requirement; the cell-service blackout list (the finish area, West Fork, Big Fir, South Fork Rd); swag. |
| S5 | Crew page | https://scoutmountainultras.com/crew | Vehicle tags, the six-station 100M crew list with per-station instructions, the Crystal Summit and Day shuttles, lot coordinates; its "mile 47.8" Gibson Jack print and the South Fork pacer boilerplate lose to the table (decisions 2, 7). |
| S6 | Official 100M GPX (from GPX Overview) | https://scoutmountainultras.com/s/SMU-100M.gpx | Geometry and elevation authority: 46,134 track points with altitudes (102.37 GPS miles) and 17 station waypoints including the Old Tom out-and-back apex. `db/events/scout-mountain-100.gpx` copies the line exactly. |
| S7 | RunSignup race page | https://runsignup.com/Race/ID/Pocatello/ScoutMountainUltras | Registration home and results host; still on the June 5-6, 2026 frame — the `not_open` evidence (decision 1). |

## Claim-level decisions

- **Name.** "Scout Mountain 100" — the 100M of the Scout Mountain
  Ultras weekend (run100s lists it as Scout Mountain).
- **Registration status.** `not_open` (decision 1). **Lottery.**
  `false` — direct RunSignup registration; at least half the field
  is held for women, femme, and non-binary runners (the home page).
- **Qualifier.** A Hardrock Endurance Run qualifier, with an
  eight-hour service requirement on the 100M (decision 14).
- **Dates.** June 4-5, 2027: the banner's first weekend in June plus
  the standing Friday 10:00 AM start (June 4, 2027 is that Friday).
  America/Boise.
- **Cutoffs.** The ten-clock ladder (decision 4); `cutoff_hours` 36.
- **Station passes.** 18: the Start at Lead Draw, sixteen more over
  fifteen locations (the Old Tom base water at 19.0 and 22.1 and West
  Fork at 36.2 and 78.8 repeat; Old Tom Summit at 20.6 is the one
  Turnaround), and the Finish at 102.7.
- **Crew.** `true` at Goodenough, South Fork, both West Fork passes,
  Gibson Jack, City Creek, Scout Mountain, and the Finish (via the
  Day Shuttle); `false` elsewhere including the Start (decision 6).
- **Pacers.** `true` at West Fork (both), Gibson Jack, City Creek,
  Scout Mountain, and Big Fir (decision 8); `false` elsewhere.
- **Drop bags.** `true` at Goodenough, South Fork, West Fork (both),
  Gibson Jack, City Creek, and Big Fir; `false` elsewhere including
  Scout Mountain's printed NO (decision 9).
- **Medical.** `null` everywhere (decision 10).
- **Elevation series.** The official GPX's own altitudes per nominal
  mile, scaled 102.37 → 102.7 (decision 11); station elevations are
  the line's values at each waypoint.
- **Follow.** Chip timing registers arrival at every aid station
  except Cusick Creek and at the finish; tracking posts on the
  homepage when available; results on RunSignup.

## Stale-source traps

- The RunSignup page is still the 2026 frame; watch it for the 2027
  posting and registration window.
- The aid table is a living Google Sheet ("subject to change" is the
  organizer's working mode); re-check miles, flags, and clocks as
  2027 approaches.
- The Event Info prose and crew page mile frames disagree with the
  table (decision 2); re-check whether the organizer reconciles them.
- The three CalTopo maps linked from GPX Overview were not needed;
  the official GPX is the open geometry surface.
- run100s' 23,800-foot climb has no counterpart (decision 3).

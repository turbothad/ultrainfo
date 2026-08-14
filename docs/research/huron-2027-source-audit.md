# Huron 100 (2027) source audit

Verified on 2026-08-14. This audit uses only Huron 100 material: the
thehuron100.com home, Course, and FAQ pages, the UltraSignup 2027
listing and 2026 results, and the organizer's HelloDrifter interactive
map (the site's Interactive Map button and the listing's course-map
link). It records what those sources actually establish; it does not
treat an organizer label as proof that a fact is current or internally
consistent.

## Bottom line

The record is publishable with a source warning. The home page banners
Saturday June 12th, 2027 (100M at 9:00 AM, 32 hours) three times, and
the UltraSignup 2027 listing (did=142357) carries the same date with
registration opening September 1, 2026 — recorded `not_open`. The
organizer's HelloDrifter map publishes the complete course: the route
line (8,665 points, 100.07 GPS miles), a 4,416-sample elevation
profile, and a marker for every station whose popup prints the mile,
crew access, pacer availability, drop bags, and cutoff clock.

Recorded discrepancies and decisions:

1. **run100s is stale on the cutoff.** Its 33 hours has no
   counterpart: the home page, FAQ, and listing all say 32 hours
   (finish 5:00 PM Sunday).
2. **Mixed page vintages (the Warbird pattern).** The home page is
   2027-frame; the FAQ and the 2027 listing's description body still
   print 2026 dates, prices, and packet timing — they supply the
   standing rules, and the home page and listing header govern the
   frame.
3. **The map is the 2026 event's URL but is the current course
   surface.** Both the 2027-frame site (Interactive Map) and the 2027
   listing (COURSE MAP) link hellodrifter.com/events/huron-100-2026.
   Its cutoff clocks are the 2026 running's; the 2027 frame keeps the
   same Saturday 9:00 AM start and 32-hour window, so the
   elapsed-minute ladder carries over unchanged.
4. **Station count is 16, not the listing's 15.** The map carries
   sixteen aid-station markers and the FAQ says "16 different aid
   stations"; the listing description's "15 aid stations (including 8
   crew access)" loses — though its 8 crew-access count matches the
   map's eight crew-flagged mid-course stations exactly. The map's
   two markers labeled "AS 15" (Hickory Shelter 87 and Windfall Hill
   92) are a numbering typo.
5. **Cutoffs.** Ten clocks from the map's popups, elapsed from the
   Saturday 9:00 AM start: Park Lyndon East 24.4 at 5:15 PM (495),
   Silver Lake 35.4 at 8:45 PM (705), Lakeland Trail 47.1 at 12:15 AM
   (915), Maple Shelter 55 at 3:00 AM (1,080), Sandhill Shelter 62.8
   at 6:00 AM (1,260), Huron Meadows 69.5 at 8:00 AM (1,380), Spring
   Mill Pond 79.5 at 12:00 PM (1,620), Hickory Shelter 87 at 2:00 PM
   (1,740), Windfall Hill 92 at 3:00 PM (1,800), and the finish at
   5:00 PM Sunday (1,920 — exactly 32 hours). No arrival-versus-
   departure semantics are published.
6. **Climb prints disagree three ways.** The home page prints "8200
   ft cumulative gain" (matching run100s); the listing description
   says "roughly 8000 feet"; the organizer route publishes 2,420 m
   (7,940 ft) of gain and 2,423 m (7,950 ft) of loss. The home page's
   8,200 governs the gain; the route's 7,950 is the only published
   loss figure and is recorded for the loss. The home page's "Max
   elevation 1100ft" sits just under the route's 349 m (1,145 ft)
   high point.
7. **One prose mile conflict.** The course page's narrative places
   the Spring Mill Pond aid station at mile 82; the map's marker
   prints 79.5, which governs (noted on the pass).
8. **Pacers.** The map flags pacer availability at Lakeland Trail
   (47.1), Sandhill Shelter (62.8), Huron Meadows (69.5), Spring Mill
   Pond (79.5), Hickory Shelter (87), and Windfall Hill (92); the
   course page's prose calls Chambers Road — just past the Lakeland
   Trail station — the first opportunity to pick up pacers. The map's
   flags govern.
9. **Drop bags.** The map flags bags at Park Lyndon East (24.4),
   Lakeland Trail (47.1), Huron Meadows (69.5), and the finish. The
   start-area "Runner Check-in" marker (Lakeview shelter) also flags
   drop bags — the bag drop-off point, noted in the summary; the
   START marker itself prints no bags.
10. **Two non-station markers are excluded.** The "Runner Check-in"
    marker is a start-area facility sharing the start coordinates,
    and a "Critical Turn" marker plots forty-plus miles off-course
    near Monroe, MI — a stray. Neither is a pass.
11. **The GPX download is account-gated; the embed data is open.**
    HelloDrifter's Download GPX requires sign-in, but the event page
    itself publicly serves the route API (distance, gain/loss, the
    full polyline) and the elevation-chart and marker GeoJSON files
    through tokens the page mints for any visitor. The bundle's line
    decodes the route polyline exactly; elevations interpolate the
    route's own 4,416-sample elevation chart; station waypoints copy
    the map's markers, which sit on the line within about 100 feet
    everywhere.
12. **Medical.** No station-level medical staffing is published;
    `med` stays null everywhere.

## Source register

All URLs below were opened or downloaded on 2026-08-14.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | thehuron100.com home | https://www.thehuron100.com | 2027 frame: "Saturday June 12th, 2027" (100M 9AM, 50M 7AM); 8,200 ft gain; 82% trail; max elevation 1,100 ft; 32 hours; start/finish venues; the shuttle; one stale "Join us in 2026" history paragraph. |
| S2 | Course page | https://www.thehuron100.com/course | The mile-by-mile narrative (Waterloo-Pinckney, Poto, Lakelands, Brighton, Huron Meadows, Island Lake, Kensington, Proud Lake); the Chambers Road pacer prose; the Spring Mill "Mile 82" print (decision 7). |
| S3 | FAQ page | https://www.thehuron100.com/faq | 2026-vintage standing rules: 16 aid stations, aid every 6-8 miles, the station menu, no lottery, the 350 cap, 32/15-hour windows, shuttles, packet timing. |
| S4 | UltraSignup 2027 listing | https://ultrasignup.com/register.aspx?did=142357 | The June 12, 2027 header and "Registration Opens Tue. Sep 1, 2026 @ 12:00 AM ET"; the description body is 2026 text (15-station print, decision 4; addresses; shuttles; refund ladder). Reached via the 2024 listing's "See the 2027 event" link (eid=17312). |
| S5 | Organizer HelloDrifter interactive map | https://www.hellodrifter.com/events/huron-100-2026 | Geometry, elevation, and station authority: the route (161,117 m, gain 2,420 m/loss 2,423 m, the full polyline) plus marker popups with miles, crew/pacer/drop flags, and the cutoff ladder. `db/events/huron-100.gpx` decodes the route polyline exactly with chart elevations. GPX download itself is account-gated (decision 11). |
| S6 | UltraSignup results | https://ultrasignup.com/results_event.aspx?did=129465 | The 2026 100-miler results (June 6, 2026); tabs back to 2024. |

## Claim-level decisions

- **Name.** "Huron 100" (S1, S4).
- **Registration status.** `not_open` (S4: opens September 1, 2026).
  **Lottery.** `false` — "no formal lottery," capped at 350.
- **Dates.** June 12-13, 2027 (S1 banner, S4 header); 9:00 AM start;
  America/Detroit; `cutoff_hours` 32.
- **Cutoffs.** The map's ten-clock ladder (decision 5).
- **Station passes.** 18: the Start at the Portage Lake boat launch,
  sixteen aid stations (four hydration-only: Mount Hope 6.7, Hankerd
  Road 31.1, Teahen Road 59.6, Fire Trail 75), and the Finish at
  Proud Lake (100). Eighteen unique coordinates; no Turnaround rows
  (point to point).
- **Crew.** `true` at the Start, Park Lyndon East, Silver Lake,
  Lakeland Trail, Sandhill Shelter, Huron Meadows, Spring Mill Pond,
  Hickory Shelter, Windfall Hill, and the Finish (the listing's
  "8 crew access" matches the mid-course count); `false` elsewhere.
- **Pacers.** `true` at Lakeland Trail through Windfall Hill's six
  flagged stations (decision 8); `false` elsewhere.
- **Drop bags.** `true` at Park Lyndon East, Lakeland Trail, Huron
  Meadows, and the Finish (decision 9); `false` elsewhere including
  the Start (the check-in marker is the drop-off).
- **Medical.** `null` everywhere (decision 12).
- **Elevation.** Gain 8,200 (home print); loss 7,950 (the route's
  only figure); the series is the route's own elevation chart per
  nominal mile scaled 100.07 → 100.
- **Follow.** Live tracking at enabledtracking (the 2026 URL);
  results on UltraSignup.

## Stale-source traps

- The FAQ and listing description are 2026-vintage (prices, packet
  timing, the 15-station print); re-check when 2027 registration
  opens September 1, 2026.
- The map lives at the huron-100-2026 URL; watch for a huron-100-2027
  event map and any course revision.
- The map's cutoff clocks are 2026's; re-verify the ladder once a
  2027 runner packet publishes (the FAQ says packets publish in late
  April).
- The tracking URL is the 2026 running's; the 2027 link will land on
  the homepage's Runner Tracking button.
- run100s' 33-hour cutoff is superseded (32 hours).

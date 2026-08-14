# Badger Mountain Challenge 100 (2027) source audit

Verified on 2026-08-13. This audit uses the Badger Mountain Challenge
site (a Blogger site by the Nomad Trail Runners), its linked aid station
chart Google Sheet and official course GPX, and the UltraSignup 2026 and
2027 listings. It records what those sources actually establish; it does
not treat an organizer label as proof that a fact is current or
internally consistent.

## Bottom line

The record is publishable with a source warning. The 2027 UltraSignup
listing pins March 26–27, 2027 with the Friday 7:00 AM start and a
November 30, 2026 registration opening; the race site's pages and the
aid chart still carry the 2026 frame but define the whole structure —
two trips on a 50-mile out-and-back from Badger Mountain Trailhead Park
in Richland, WA to the Chandler Butte turnaround, a thirteen-row chart
per trip with menus, drop, crew, and cutoff clocks, drop bags at two
locations, pacers from mile 50, and crews restricted to the
crew-accessible stations. The official GPX (a route file) supplies
geometry and elevations for the full 100 miles.

Recorded discrepancies and decisions:

1. **2026-frame site, 2027-frame listing.** The 100-miler page still
   says March 27–28, 2026 and the rules page is headed "Rules (2026
   race)"; the 2027 listing gives March 26–27, 2027, "100 Miler Fri
   7:00 AM", and the registration opening. The listing governs dates
   and status; the site's structure (32.5 hours, chart clocks) is the
   same pattern the listing preserves.
2. **run100s is stale twice.** Its 32-hour cutoff and 14,000-foot climb
   have no counterpart: the site says 32.5 hours (course closes 3:30 PM
   Saturday) and "18,431' of climbing for the 100 miler".
3. **Candy Mtn's loop-two mile.** The chart prints 55 where every other
   loop-two row is its loop-one mile plus 50 exactly (4.6 + 50 = 54.6;
   the inbound twin sits at 95.4). The printed 55 governs the pass and
   the conflict carries a pass-specific source note.
4. **Directional-only rows.** The chart's two McBee Ridge rows say "no
   aid, directional only" — recorded as passes with water and food
   false. On the GPX line the two rows sit about 0.9 mile apart, so
   they carry separate outbound and inbound waypoints.
5. **Route-file GPX.** The official download ("THE BMC 100MILER") is a
   GPX route (8,363 route points with elevations, 505–2,008 ft),
   GPS-measuring 99.00 miles with a 106-foot closure against the
   chart's 100-mile frame; the bundle converts route points to track
   points and the chart frame governs pass miles.
6. **Cutoffs.** Six chart clocks from the Friday 7:00 AM start: the
   50-mile turnaround 10:00 PM (900), McBee parking 3:00 AM (1,200) and
   7:30 AM (1,470), Jacobs Road 12:00 PM (1,740), Candy Mtn 1:30 PM
   (1,830), finish 3:30 PM (1,950). "Cut-off times will be adhered to."
7. **Turnarounds.** The two Chandler Butte passes (23.3 and 73.3) are
   the Turnarounds per the chart's "(turnaround)" label; other mid
   passes are unlabeled per the domain vocabulary (the LOViT pattern).

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Site home | http://www.badgermountainchallenge.com/ | The 15th annual race hosted by the Nomad Trail Runners; five distances; 2026-frame welcome. The site is not served over https. |
| S2 | 100-miler page | http://www.badgermountainchallenge.com/p/100-miler.html | Course structure (the 50-mile course done twice, out-and-back, ~15 total miles of pavement, 500–2,000 ft, "18,431' of climbing"); check-in and briefing times at the Trailhead Park lower lot (1294 White Bluffs St., 46.238506,-119.306361); early 6:00 AM start by arrangement; drop bags (start/finish and McBee Parking at 18, 31, 68, 80 — the chart's 18.5/31.5/68.5/81.5 govern); the 32.5-hour cutoff; pacer rules (from the 50-mile turnaround, one at a time, bib without registration); crew restriction with directions link; dogs allowed; weather warnings; buckles; links to the chart, course map, GPX, and profile. All 2026-frame. |
| S3 | 100-mile aid station chart | https://docs.google.com/spreadsheets/d/1aHQPNF9a4MOfIDb6mwB_3mLBb10kPbOP/edit | The thirteen-row chart per 50-mile trip: names, loop-one and loop-two miles, per-loop menus, surface notes, drop bags (start/finish, McBee parking), crew access (start/finish, Candy Mtn, McBee parking), and the six cutoff clocks; the Candy 55 misprint; a 2026 sunset/sunrise note. |
| S4 | Official course GPX | https://drive.google.com/file/d/192WL02uAJCglSKFhpW7RqZAbVETtAkgU/view | Geometry and elevation authority ("THE BMC 100MILER"): a GPX route of 8,363 points with elevations covering both 50-mile trips, 99.00 GPS miles, 106-foot closure, start 46.23665,-119.30706. `db/events/badger-mountain-100.gpx` converts the route points to track points exactly and adds eight station waypoints. |
| S5 | UltraSignup 2027 registration page | https://ultrasignup.com/register.aspx?eid=2609 | "Badger Mountain Challenge - March 26 - 27, 2027"; "Registration Opens Mon. Nov 30, 2026 @ 12:00 AM PT"; Start Times (100 Miler Fri 7:00 AM); the body text still carries the 2026 welcome. |
| S6 | UltraSignup 2026 listing | https://ultrasignup.com/register.aspx?did=127508 | Results tabs back to 2011; the See-the-2027-event chain to S5. |

## Claim-level decisions

- **Name.** "Badger Mountain Challenge 100" — the site's 100-Mile
  Endurance Run within the Badger Mountain Challenge weekend.
- **Registration status.** `not_open` — opens November 30, 2026 (S5).
- **Lottery.** `false` — direct registration; no qualifier exists.
- **Cutoffs.** Six chart clocks (decision 6). `cutoff_hours` 32.5.
- **Station passes.** 25: the chart's thirteen rows per trip done twice
  (the start/finish row yields the Start, the mile-50 turnaround pass,
  and the Finish), including the two directional-only ridge markers per
  trip and the two Chandler Butte Turnarounds.
- **Crew.** `true` at the start/finish, Candy Mtn, and McBee parking
  passes per the chart's crew column; crews meeting runners anywhere
  else is a DNF.
- **Pacers.** `true` at the mile-50 turnaround and the crew-accessible
  Candy Mtn (55, 95.4) and McBee parking (68.5, 81.5) passes after 50
  miles; `false` elsewhere.
- **Drop bags.** `true` at the four McBee parking passes plus the
  mile-50 and finish passes; `null` at the Start.
- **Medical.** `null` everywhere — no published medical service.
- **Elevation series.** The official GPX's elevations per nominal chart
  mile (505–1,888 ft at mile resolution); station spots at the
  waypoints, with the inbound ridge marker's spot at its own mile.
- **Follow.** No live tracking published; results on UltraSignup.

## Stale-source traps

- The site's pages, rules heading, and chart are 2026-frame; re-check
  when the 2027 update posts (the site historically updates near the
  December registration opening).
- The chart's sunset/sunrise note (7:15 pm / 6:45 am) is 2026's.
- The 100-miler page's drop-bag miles (18, 31, 68, 80) round the
  chart's 18.5/31.5/68.5/81.5.
- run100s' 32-hour and 14,000-foot figures are superseded (32.5;
  18,431).
- The registration URL is the eid series page until the 2027 did page
  exists; re-point after November 30, 2026.

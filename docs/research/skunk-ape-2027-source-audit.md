# Skunk Ape 100 (2027) source audit

Verified on 2026-08-14. This audit uses only Skunk Ape Events material:
the UltraSignup 2027 listing (the race's primary public page — the
listed event website is a login-walled Facebook page), the organizer
CalTopo course map that listing links, and the UltraSignup 2026 listing
for results. Elevations come from USGS 3DEP point queries because the
CalTopo lines carry no elevation data. It records what those sources
actually establish; it does not treat an organizer label as proof that
a fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The 2027 UltraSignup
listing is fully 2027-frame: April 24-25, 2027 from the Santos
Trailhead in Ocala, FL (3080 S.E. 80th St), 7:00 AM start, 36-hour
maximum, open registration ($262 plus fees, closing April 20, 2027),
and a complete course description with per-segment distances, a
five-cutoff ladder, drop-bag, crew, and pacer rules. The organizer
CalTopo map carries the course lines and station markers. The 100 runs
the ~51.8-mile Florida Trail / Cross Florida Greenway loop twice — out
on the Florida Trail through Ross Prairie to the Pruitt Trailhead
turnaround, back bypassing Ross Prairie — for a 103.5-mile total.

Recorded discrepancies and decisions:

1. **run100s is stale on climb.** Its 2,790-foot figure has no
   counterpart: the listing says 1,562 feet per loop, "Double that for
   the 100 Mile" (3,124). Its 36-hour cutoff and April 24-25 dates
   match.
2. **The organizer's own mileage surfaces conflict at the ±1 level.**
   The per-segment list sums the loop to 52.39 miles (outbound 29.29 +
   in-bound 23.10), but the cutoff table puts the Santos halfway at
   51.76 and the CalTopo loop GPS-measures 51.61. The cutoff table's
   cumulative frame governs: halfway 51.76, total 103.5 (2 × 51.76;
   the listing's own 36-hour pace math of 20:53 per mile implies
   ~103.4).
3. **Loop-two cumulative cutoffs govern loop-two passes.** The
   published 80.02 (Pruitt II) sits 1.03 below the segment chain's
   51.76 + 29.29 = 81.05; the published 86.52 and 92.52 imply
   Pruitt-to-200 = 6.5 and 200-to-49th = 6.0, the reverse of the
   segment list's 6.0 and 6.5. The printed cumulative miles (80.02,
   86.52, 92.52, 96.42) govern those passes and the conflicts carry
   pass-specific notes; loop-two miles without a printed cumulative
   are the segment distances anchored at 51.76.
4. **Drawn line vs published segments.** The line measures the
   in-bound 200-to-49th leg at 6.03 (published 6.5) and the Land
   Bridge-to-finish leg at 6.62 (published 6.7); crossings sit at
   41.20 and 44.99 against the published 41.79 and 45.69. Published
   distances govern pass miles; the line is the geometry authority.
5. **Cutoff style and a date typo.** Five complete-by clocks plus the
   finish, all printed as "April 26th Sunday" — but the race Sunday is
   April 25, 2027 (April 26 is Monday). The weekday-plus-clock frame
   is internally consistent with 36 hours from the Saturday 7:00 AM
   start (2:00 AM = 19h at Santos 51.76; 7:00 PM = 36h at the finish),
   so the clocks are recorded and the date print is documented.
6. **The seconds print.** Land Bridge in-bound (96.42) is printed
   "4:33:32pm" — the only cutoff with seconds (it is 96.42 miles at
   the even 36-hour pace). Recorded as 4:33 PM / 2,013 minutes.
7. **Ross Prairie.** Out-bound only (the in-bound route bypasses it;
   the line crosses its marker once, at 17.64) and its drop bags are
   for 100-milers only, giving the 100 a third drop location.
8. **Medical.** Stations stock band-aids and women's hygiene products
   in a box; no station-level medical staffing is published. `med`
   stays null everywhere.
9. **Elevation.** The CalTopo lines are two-dimensional, so the
   series and station spots use USGS 3DEP point elevations
   (epqs.nationalmap.gov) sampled per nominal mile along the loop
   traversed twice (51-104 feet across the course). The race record's
   gain figures are the organizer's (+871/-865 out, +691/-701 in per
   loop; 3,124/3,132 doubled).
10. **2027 guidebook pending.** "Guidebook and Rules: Coming Soon" —
    the listing itself carries the aid, cutoff, crew, and pacer detail
    recorded here; re-check when the guidebook posts.

## Source register

All URLs below were opened or downloaded on 2026-08-14.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | UltraSignup 2027 listing | https://ultrasignup.com/register.aspx?did=142072 | The race's primary public page: April 24-25, 2027; Santos Trailhead start (3080 S.E. 80th St, Ocala FL); 7:00 AM; 36 hours; $262 + fees, open, closes April 20, 2027; the course description with per-segment distances; the five-cutoff ladder; drop-bag, crew, and pacer rules; the CalTopo, Strava, UltraPacer, Garmin, and AllTrails links; awards and the Trail Series. Reached via the 2026 listing's series chain (eid=16957). |
| S2 | Organizer CalTopo course map | https://caltopo.com/m/GHHF0 | Geometry authority: the Full Course Data loop (2,625 points, 51.61 GPS miles), Outbound and In-Bound lines, per-segment lines, and the six station markers (Start/Finish, Land Bridge Trailhead AS, 49th Ave Trailhead AS, Ross Prairie AS, St. Rd. 200 AS, Pruitt Trailhead AS). Lines carry no elevations. `db/events/skunk-ape-100.gpx` copies the loop exactly, traversed twice, plus the six markers. |
| S3 | UltraSignup 2026 listing | https://ultrasignup.com/register.aspx?did=129761 | "Skunk Ape 100 Mile Endurance Run - April 25, 2026" (took place); results; the run100s href and the chain to the 2027 page. |
| S4 | USGS 3DEP point elevation service | https://epqs.nationalmap.gov/v1/json | Elevation authority for the series and station spots (the CalTopo lines are two-dimensional): per-nominal-mile samples along the doubled loop and the six station coordinates. |

## Claim-level decisions

- **Name.** "Skunk Ape 100" — the Skunk Ape 100 Mile Endurance Run by
  Skunk Ape Events (house short form, like the HURT and LOViT
  records).
- **Registration status.** `open` (S1; closes April 20, 2027).
  **Lottery.** `false` — direct registration.
- **Cutoffs.** Six complete-by points (decision 5): Santos 51.76 at
  2:00 AM (1,140), Pruitt 80.02 at 10:52 AM (1,672), St. Rt. 200
  86.52 at 1:07 PM (1,807), 49th Ave 92.52 at 3:13 PM (1,933), Land
  Bridge 96.42 at 4:33 PM (2,013; decision 6), finish at 7:00 PM
  (2,160). `cutoff_hours` 36.
- **Station passes.** 19: the Start, seventeen mid-race passes over
  five aid stations plus the Santos halfway (Land Bridge ×4, 49th Ave
  ×4, Ross Prairie ×2, St. Rt. 200 ×4, Pruitt Turnaround ×2, Santos
  halfway ×1), and the Finish. The two Pruitt passes are the
  Turnarounds.
- **Crew.** `true` everywhere except the Start row's pre-race hub —
  "All the aid stations will have crew access", with a crew tent at
  the Santos hub. Recorded true at all 19 rows including Start
  (the hub is the crew base) — see the pass rows.
- **Pacers.** 100-milers may pick up a pacer after 50 miles: `true`
  from the Santos halfway (51.76) through Land Bridge 96.42; `false`
  before and at the Finish. Runners over 60 or needing special
  assistance may have a pacer at any time (rule summary).
- **Drop bags.** `true` at every 49th Ave (10.45, 41.79, 62.21,
  92.52) and Pruitt (29.29, 80.02) pass, and at both Ross Prairie
  passes (17.59, 69.35 — 100-milers only); `null` at the Start (bags
  are collected there); `false` elsewhere.
- **Medical.** `null` everywhere (decision 8).
- **Elevation series.** USGS 3DEP per nominal mile (51-104 ft;
  decision 9); station spots at each pass's mile.
- **Follow.** No live tracking published; results on UltraSignup.

## Stale-source traps

- "Guidebook and Rules: Coming Soon" — re-check the 2027 guidebook
  for station-level detail when it posts.
- The event-website link is a Facebook page (login-walled, not
  verifiable here).
- The listing's segment sums, cumulative cutoffs, and the drawn line
  disagree at the ±1-mile level (decisions 2-4); re-check whether the
  organizer republishes a consistent table.
- run100s' 2,790-foot climb is superseded (3,124 doubled from the
  listing's 1,562 per loop).

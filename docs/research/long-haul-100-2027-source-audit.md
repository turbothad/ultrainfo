# Long Haul 100 (2027) source audit

Verified on 2026-08-13. This audit uses only A1 Ultra Events material: the
official race page, the 2027 UltraSignup listing it links, the Runner & Crew
Handbook PDF it hosts, and the CalTopo course map it links — plus USGS 3DEP
spot elevations. It records what those sources actually establish; it does not
treat an organizer label as proof that a fact is current or internally
consistent.

## Bottom line

The record is publishable with a source warning. The 2027 UltraSignup listing
supports the January 16–17, 2027 date, the 7:00 AM Saturday start, 6 loops of
16.8 miles, the 32-hour course cutoff and 30-hour Western States qualifying
mark, the four station locations with per-loop mile marks, sold-out
registration with a closed waitlist, and the $325 fee. The organizer's
surfaces conflict on the Metal Mark Pond mile and the loop-length frame, and
the only handbook available is the 2026 edition.

Recorded discrepancies:

1. **Loop frame.** The 2027 UltraSignup listing and the race page headline say
   6 × 16.8-mile loops, and the organizer's CalTopo line measures 16.82 miles;
   but the race page's pacer sentence ("after loop 3, at mile 50.1") and the
   2026 handbook say 16.7. This record uses the 16.8 frame throughout (loop-3
   end at mile 50.4) and treats 50.1/16.7 as the prior year's frame. Six
   16.8-mile loops total 100.8 miles against the billed 100.
2. **Metal Mark Pond mile.** UltraSignup says MM 13.4; the race page says MM
   13.2; the CalTopo marker sits at line-mile 13.36. The record uses 13.4
   (UltraSignup + map).
3. **Mile-0.5 station name.** The race page calls it "Day Use Area"
   (loops 2–6); UltraSignup calls it "Middle Lake AS = MM .05" — ".05" is an
   evident typo for .5 given the race page and the handbook's "Day Use Area:
   Mile .5 on the course" parking entry. No CalTopo marker exists for it; the
   GPX waypoint is placed at the 0.5-mile track point.
4. **Handbook edition.** The only handbook is the 2026 edition (updated
   2025-11-11). Schedule pattern, parking areas, drop-bag logistics, and
   detailed pacer/crew rules come from it and are flagged as subject to change
   for 2027. Facts available on current surfaces (start time, cutoffs, loops,
   stations, sold-out status) are taken from those surfaces instead.
5. **Elevation.** No organizer elevation figures exist. USGS 3DEP puts the
   four stations at 88–94 ft; `elevation_gain_ft`/`loss` stay null and the
   profile is the station spot elevations at each pass mile.
6. **Water potability.** Stations are "full-service … hot and cold food and
   beverages"; water itself is implied, never certified potable.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Long Haul 100 official race page | https://a1ultraevents.wordpress.com/long-haul-100/ | Supports January 16–17, 2027; Colt Creek State Park, 16000 State Rte 471, Lakeland, FL; "6 x 16.8-Mile Loops"; 32-hour cutoff (30-hour WSER); station list (South Loop MM 3.3 and 8.5, Metal Mark Pond MM 13.2 — conflicting, see UltraSignup; Day Use Area MM .5 on loops 2–6); pacers "may join their runner after loop 3, at mile 50.1" (prior frame) and "during loops 4–6", over-60 exception; SOLD OUT banner; links to the handbook, CalTopo, AllTrails, and the 2027 UltraSignup listings. |
| S2 | 2027 UltraSignup listing | https://ultrasignup.com/register.aspx?did=134998 | Current operational authority: "Long Haul 100 - January 16, 2027"; 100M start 7:00 AM (100 Furlongs 10:00 AM); "6 loops of 16.8 miles"; "Cut-off: 32 hours (WSER qualifying cut-off is 30 hours)"; stations "South Loop AS M 3.3 and MM 8.5", "Metal Mark Pond AS = MM 13.4", "Middle Lake AS = MM .05" (typo for .5); drop-bag access every loop; buckle for all finishers; "Our 2027 event is sold out, and the Waitlist has been temporarily turned off"; $325 fee ($373.85 with fees); gates 5:00 AM, pre-race meeting 6:45 AM; results history including the 13:18:58 course record ('12 Mike Morton). |
| S3 | LH100 Runner & Crew Handbook (2026 edition) | https://a1ultraevents.wordpress.com/wp-content/uploads/2025/11/lh100-handbook.pdf | Updated Nov 11, 2025 for the 2026 race; supports the schedule pattern (Friday packet pickup, 7:00 AM Saturday start, sub-24 buckle 7:00 AM Sunday, WSER mark 1:00 PM, race end 3:00 PM Sunday), parking areas A–D with crew rules, "no medical checks before, during, or after the race", IVs/supplemental oxygen prohibited, drop bags at the start/finish pavilion and AS1 only (max 5-gallon, one bag), pacer rules (mandatory free registration and waiver, bib, one at a time, no muling, no bicycles, start/pull out only at official stations, over-60 exception), chip timing with ankle straps, live tracking via Trailhead Ultras Timing, and Colt Creek park fees ($4/vehicle or $3/person for non-runners). Flagged as prior-edition operational detail. |
| S4 | Organizer CalTopo course map | https://caltopo.com/m/558GS72 | Geometry authority linked from S1 as a 2027 course map: one "Long Haul 2026" line of 2,133 points measuring 16.82 miles (22 ft closure), markers for Start/Finish (28.296300, -82.040450), Aid Station 1 (28.277280, -82.031100), Aid Station 2 (28.316240, -82.041010), and parking areas. AS1 marker sits at line-mile 3.29 and AS2 at 13.36, corroborating the MM 3.3/13.4 frame. `db/events/long-haul-100.gpx` copies the line's coordinates exactly. |
| S5 | USGS 3DEP Elevation Point Query Service | https://epqs.nationalmap.gov/v1/json | Spot elevations at the station points (queried 2026-08-13): HQ 89 ft, South Loop 94 ft, Metal Mark Pond 91 ft, Day Use 88 ft. Not an organizer source; used because the organizer publishes no elevation data. |
| S6 | Official 2026 results (UltraSignup) | https://ultrasignup.com/results_event.aspx?did=123897 | Most recent completed year's official results, linked from S1's results index; 2027 results will appear on the same UltraSignup event. |

## Claim-level decisions

- **Name.** "Long Haul 100" (S1/S2). run100s lists "Long Haul".
- **Registration status.** `sold_out` — S2's explicit banner; the waitlist is
  temporarily closed, which stays in prose, not the enum.
- **Lottery.** `false` — direct first-come UltraSignup registration that sold
  out; no reviewed source mentions a lottery.
- **Cutoffs.** Only the 32-hour course cutoff exists (3:00 PM Sunday from the
  7:00 AM Saturday start), recorded in both clock and elapsed forms on the
  Finish pass. The 30-hour WSER mark and sub-24 silver buckle are performance
  marks, recorded in notes only.
- **Station passes.** 30: Start, then per loop the South Loop station at MM
  3.3 and 8.5 (one physical location, passed twice), Metal Mark Pond at MM
  13.4, HQ at MM 16.8, plus Day Use at MM 0.5 on loops 2–6; final HQ pass
  recorded as the Finish at mile 100.8.
- **Crew.** `true` at HQ passes (Area D paved-path canopies, Area C
  self-crewing at mile 16.4) and Day Use passes (Area A vehicle crewing);
  `false` at South Loop (no published access) and Metal Mark Pond (S3:
  "No access for crews"). Crew bicycles are prohibited.
- **Pacers.** Guarantee-based booleans: `true` from the mile-50.4 loop-3/4
  checkpoint onward (loops 4–6), `false` before with the over-60 exception in
  notes. One at a time, no muling, no bicycles, mandatory free registration.
- **Drop bags.** `true` at South Loop and HQ passes (S3: pavilion and AS1
  only; S2: "access to your drop bags every loop"), `false` at Metal Mark
  Pond and Day Use, `null` at the Start (bags are staged pre-race).
- **Medical.** `false` everywhere — S3's explicit "no medical checks" rule;
  first-aid supplies at stations are noted in aid text.
- **Elevation series.** S5 station spot elevations listed at each pass mile —
  the flat-course profile approach reviewed for the Southern Tour record.
- **Follow.** Live tracking runs on Trailhead Ultras Timing (S3); official
  results live on UltraSignup (S6).

## Stale-source traps

- The race page's "mile 50.1" pacer sentence and MM 13.2 for Metal Mark Pond
  match the 2026 (16.7-mile) frame, not the current 16.8-mile listing.
- The handbook is the 2026 edition; do not copy its dates (Jan 16–18, 2026)
  or schedule times into 2027 facts that current surfaces already state.
- The CalTopo line is titled "Long Haul 2026" but is linked from both 2027
  surfaces as the current course; regenerate geometry from the map's export,
  never from AllTrails or Garmin mirrors.
- run100s' row (32h cutoff, 741'/778') matches roughly but is not organizer
  material; its climb figures have no organizer counterpart and were not
  copied.

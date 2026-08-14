# Viper 100 (2027) source audit

Verified on 2026-08-13. This audit uses the organizer's 2027 UltraSignup
listing (which carries the complete race manual), the Mamba Trail
Runners site, and the course loop the listing embeds from plotaroute. It
records what those sources actually establish; it does not treat an
organizer label as proof that a fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The 2027 UltraSignup listing
is the primary source for everything: March 19–20, 2027; the 100 starts
Friday 7:00 AM with a 41-hour cutoff (all distances conclude at midnight
Saturday); a 33.4-mile Shelby Farms Park loop run three times; four
physical stations producing six passes per loop with published crew,
pacer, and drop-bag rules; open registration ($250). The embedded
plotaroute loop supplies geometry. The organizer site (mambatrailrunners.com)
is a one-page hub that links each race to UltraSignup.

Recorded discrepancies and decisions:

1. **run100s is stale twice.** Its 3/12-13/27 dates and 38-hour cutoff
   have no counterpart on the 2027 listing (March 19–20; 41 hours).
   Neither was copied.
2. **Loop frame.** The listing bills a 33.4-mile loop and prices the 107K
   as "66.8 Miles" (two loops); three loops give `distance_mi` 100.2. The
   plotaroute loop GPS-measures 33.43 miles with a 23-foot closure; the
   billed 33.4 governs pass miles.
3. **Course artifact vintage.** The embedded route (3232103) is named
   "Viper 300 Route 2026", was drawn on February 18, 2026 by Mamba Trail
   Runners founder James Boler, and is the map the 2027 listing presents as "Viper Course Loop -
   33.4 miles". Used for geometry only; re-check before race week.
4. **Twin passes.** Bridge is visited at loop miles 7.4 and 14.4 — the
   two track passes run 61 feet apart under the Walnut Grove Road Bridge.
   Tour de Wolf is visited at 20.8 and 27.0 — the track crosses the
   pavilion area twice, about 0.18 mile apart; the waypoint sits at the
   first pass (20.8). Both stations are published as single locations
   "visited twice each loop".
5. **Cutoffs.** Only the overall 41 hours is published ("all race
   distances conclude at Midnight on Saturday, March 20, 2027", DST
   already in effect). Friday 7:00 AM + 41 hours = 12:00 AM entering
   March 21; the finish pass records that clock and 2,460 minutes; no
   intermediate cutoffs exist.
6. **Elevations.** The plotaroute route carries no point elevations; the
   organizer publishes no gain figure in prose. plotaroute computes 324 m
   ascent per loop (~3,190 ft over three) — recorded here, with
   `elevation_gain_ft` left null. The profile and station spots are USGS
   3DEP values (242–336 ft — a flat Memphis park course).
7. **Start pass.** No mile-zero aid row is published (Hyde Lake Pavilion
   is listed as the final station of each loop), so the Start pass
   records food false and water null with the framing quoted.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | UltraSignup 2027 registration page | https://ultrasignup.com/register.aspx?did=137755 | Primary source: "Viper 100 - March 19 - 20, 2027"; Hyde Lake Pavilion, Shelby Farms Park, Memphis/Cordova TN; distances 100 Mile / 107K / 53K / 25K with starts and cutoffs (100: Friday 7:00 AM, 41 hours; all conclude midnight Saturday, DST in effect); the aid station section (Bridge 7.4 & 14.4 no crew; Refuge 10.8 crew; Tour de Wolf 20.8 & 27.0 crew, drop bags, medical; Hyde Lake 33.4 crew, drop bags, hot food, sleep station); crew and drop-bag lists; the pacer section (100/107K only, after one full loop, one at a time, crew-accessible pickups and swaps, waiver and bib, no muling); race rules (no dropping down, no crewing outside aid stations, no caching, on foot only, IV/oxygen ends the race); live tracking sentence; parking at the TDW Pavilion; packet pickup; deferral ladder; open registration $250. |
| S2 | Mamba Trail Runners site | https://www.mambatrailrunners.com/ | Organizer hub; links every race (including this listing) to UltraSignup; no separate Viper page or GPX. |
| S3 | Course loop on plotaroute | https://www.plotaroute.com/route/3232103 | Geometry authority, embedded on S1 as "Viper Course Loop - 33.4 miles": route "Viper 300 Route 2026" by Mamba founder James Boler (drawn 2026-02-18), circular, 53,868 m per its distance field; the 2,313-point line haversine-measures 33.43 miles with a 23-foot closure and carries no elevations; plotaroute computes 324 m ascent / 325 m descent per loop. `db/events/viper-100.gpx` copies the points exactly and adds waypoints at each station's first loop mile. The page also embeds route 3244380 ("Viper 25k") for the 25K, not used here. |

## Claim-level decisions

- **Name.** "Viper 100" — the listing's title for the 100-mile race; the
  weekend brand is "The Viper".
- **Registration status.** `open` — all four distances sell on S1.
- **Lottery.** `false` — direct registration.
- **Cutoffs.** Finish only: 100.2 = 12:00 AM (2,460). `cutoff_hours` 41.
- **Station passes.** 19: the Start plus six passes on each of three
  loops (Bridge +7.4, Refuge +10.8, Bridge +14.4, TDW +20.8, TDW +27.0,
  Hyde Lake +33.4), the last recorded as the Finish. Loop passes carry
  "Loop N" directions per the domain vocabulary.
- **Crew.** `true` at Refuge, Tour de Wolf, and Hyde Lake passes (and the
  Start); `false` at every Bridge pass — per S1's crew list.
- **Pacers.** `true` exactly at crew-accessible passes after one full
  loop: 33.4, 44.2, 54.2, 60.4, 66.8, 77.6, 87.6, and 93.8; `false` at
  the Finish (no pickup) and everywhere on loop one.
- **Drop bags.** `true` at every Tour de Wolf and Hyde Lake pass (Start
  `null`); `false` at Bridge and Refuge — per S1's drop-bag list.
- **Medical.** `true` at Tour de Wolf ("medical support"); `null`
  elsewhere.
- **Elevation series.** USGS 3DEP spots per nominal mile along the loop,
  repeated per loop; station spots at the waypoint coordinates.
- **Follow.** The listing says 100 mile and 100k runners will be live
  tracked (no service or link published); results on UltraSignup.

## Stale-source traps

- run100s' 3/12-13/27 dates and 38-hour cutoff are last year's frame; the
  2027 listing says March 19–20 with 41 hours.
- The embedded course is a 2026-named plotaroute route; re-check for a
  redrawn loop before race week.
- The listing's tracking sentence says "100 mile and 100k runners" —
  the weekend's second distance is billed elsewhere as the 107K.
- The Mamba site home still lists 2026-season races; it is a hub, not a
  fact source for Viper 2027.

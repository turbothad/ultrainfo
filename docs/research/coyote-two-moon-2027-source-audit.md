# Coyote Two Moon 100 (2027) source audit

Verified on 2026-08-14. This audit uses only Coyote Two Moon material:
the coyote2moon.com 100-miler page (turn-by-turn directions), the
Runners page, the organizer CalTopo map the Runners page links as the
100M Topo map, and the UltraSignup 2027 listing. Elevations for the
profile come from USGS 3DEP point queries because the CalTopo line is
two-dimensional; station elevations are the turn-by-turn's printed
values. It records what those sources actually establish; it does not
treat an organizer label as proof that a fact is current or
internally consistent.

## Bottom line

The record is publishable with a source warning. The 2027 UltraSignup
listing is fully 2027-frame: the 100M starts Friday, April 30, 2027
at 1700 (5:00 PM) from the Rock Tree Sky school on Sisar Road in
upper Ojai, CA, with a 42-hour cutoff (Sunday 11:00 AM), open
registration closing April 28, 2027, a 200-spot weekend cap, a
qualifier (a trail 100K with 10,000 feet within one year), and
26,000 feet of climbing. The 100-page's turn-by-turn prints every
pass with miles and elevations, and the organizer CalTopo map
(m/2D1CJ) carries the full course line (6,986 points, 100.52 GPS
miles) and the eight station markers.

Recorded discrepancies and decisions:

1. **run100s is stale twice.** Its May 21-22 dates and 40-hour
   cutoff have no counterpart: the listing says April 30 - May 2,
   2027 and 42 hours for the 100M and 100K.
2. **The turn-by-turn's section headers and body prints disagree on
   six pass miles**, always by 0.16-0.45: 10.60/10.76, 23.65/23.77,
   52.24/52.65, 63.36/63.83, 71.54/71.76, and 93.20/93.45. The
   CalTopo line arbitrates each pair (crossings at scaled 10.75,
   24.03, 52.06, 63.54, 71.48, 93.11): the figure nearer the line
   governs — 10.76, 23.77, 52.24, 63.36, 71.54, 93.20 — with the
   losing print documented per pass (the Sugar Creek pattern).
3. **One wild print.** The Gridley Top-to-Bottom section closes
   "Once you arrive at Gridley Bottom, you will be at Mi. 63.44" —
   but its own header runs "Mile 52.24 to Mile 57.91" and the line
   crosses the Bottom Gridley marker at scaled 57.80. 57.91 governs.
4. **Aid-station numbering is chaotic** (Cozy Dell is labeled both
   "AS # Eight" and "# six"; Gridley Top is "# Four" and "# Five" in
   adjacent sections). The CalTopo markers' numbering governs the
   audit's naming (AS1 TopaTopa/ElderCamp, AS2 Rose Valley, AS3
   Thacher Creek Trailhead, AS4 Gridley Top, AS5 Gridley Bottom, AS6
   Cozy Dell); the pass rows use the location names.
5. **Water-only naming.** The two unmanned water passes (42.0,
   85.36) sit at one marker on the Chief Peak climb; the Runners
   page calls this stop Chief Peak ("It's water. Just water.").
6. **Climb figures.** The listing says 26,000 feet; the 100-page
   says 26,393. The listing's 26,000 is recorded and the print
   documented. No loss figure is published (the course returns to
   its start).
7. **A Sunday date typo.** The listing's Sunday header says "May
   3rd" but its own title says April 30 - May 2, 2027 (Sunday is May
   2; May 3 is Monday). The 30K/10K day, not the 100's frame.
8. **Crew.** No crew provisions are published on any surface — the
   Runners page covers pacers and drop bags only. Crew flags are
   recorded false everywhere with notes; pacers imply road access at
   Gridley Bottom and Cozy Dell.
9. **Pacers.** One pacer total for the 100M ("One pacer. Uno.
   Singular."), joining at the Gridley trailhead or Cozy Dell
   trailhead — recorded true at Gridley Bottom (57.91) and Cozy Dell
   (71.54), with the pacer's details emailed in advance.
10. **Drop bags.** Rose Valley, Horn Canyon, Gridley Bottom, and
    Cozy Dell for the 100M. The Horn Canyon bag serves the Thacher
    Creek Trailhead station (34.90), which the course reaches down
    Horn Canyon Trail — recorded there with a note. Bags in by 4:00
    PM Friday; returns Sunday afternoon.
11. **Elevation.** The CalTopo line is two-dimensional, so the
    series uses USGS 3DEP point samples per nominal mile along the
    scaled line; the pass rows carry the turn-by-turn's printed
    station elevations (1,574 start/finish; 5,273 TopaTopa; 3,416
    Rose Valley; 1,370 Thacher Creek; 4,837 water stop; 3,807
    Gridley Top; 1,253 Gridley Bottom; 881 Cozy Dell).
12. **Frame.** The turn-by-turn's cumulative prints end at the Rock
    Tree Sky school finish, "100.23mi" (governs); the CalTopo line
    GPS-measures 100.52 and crosses the finish marker at scaled
    100.18.

## Source register

All URLs below were opened or downloaded on 2026-08-14.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | UltraSignup 2027 listing | https://ultrasignup.com/register.aspx?did=139136 | 2027 frame: April 30 - May 2, 2027; the 100M/100K Friday 1700 start and 42-hour cutoffs; per-distance climb figures (100M 26,000 ft); the 200-spot cap; qualifiers (trail 100K with 10,000 ft within a year for the 100M); open registration closing April 28, 2027; no refunds or transfers, deferral at the Race Director's discretion; the "May 3rd" Sunday typo. Reached via the Runners page's SIGN UP link (did=127423, the 2026 listing) and its series chain (eid=1428). |
| S2 | 100-miler page (turn-by-turn) | https://www.coyote2moon.com/turn-by-turn-directions | The pass-by-pass course: miles, elevations, summits (four bracelets), and the "30 April 27@1700" date line; the paired header/body mile conflicts (decisions 2-3); the 26,393-foot print; the empty CalTopo button (the working link lives on the Runners page). |
| S3 | Runners page | https://www.coyote2moon.com/general-1 | Aid stocking (Neversecond and GU, PB&J, quesadillas, soups; Chief Peak water-only); pacer rules (one pacer; 100M joins at Gridley TH or Cozy Dell TH); drop-bag rules and locations (Rose Valley, Horn Canyon, Gridley Bottom, Cozy Dell for the 100M; in by 4:00 PM Friday; returns Sunday afternoon); the 100M Topo map (CalTopo) link; a start-times table and prose still carrying 2025/2026 frames (the 42-hour pattern matches the 2027 listing). |
| S4 | Organizer CalTopo course map (100M Topo map) | https://caltopo.com/m/2D1CJ | Geometry authority: the 100M line (6,986 points, 100.52 GPS miles, two-dimensional) and the Start & Finish, six aid-station, and Unmanned Water Station markers. `db/events/coyote-two-moon-100.gpx` copies the line exactly and the eight station markers. |
| S5 | USGS 3DEP point elevation service | https://epqs.nationalmap.gov/v1/json | Elevation authority for the profile series (the CalTopo line carries no elevations): per-nominal-mile samples along the scaled line. |

## Claim-level decisions

- **Name.** "Coyote Two Moon 100" — the 100-mile race of the Coyote
  Two Moon weekend.
- **Registration status.** `open` (S1; closes April 28, 2027).
  **Lottery.** `false` — direct registration with a qualifier.
- **Cutoffs.** One: the finish at 42 hours — 11:00 AM Sunday, May 2,
  2027 (2,520 minutes). No station ladder is published.
- **Station passes.** 17: the Start, fifteen mid-race passes over
  seven locations (TopaTopa ×5 at 7.09/10.76/23.77/89.59/93.20, Rose
  Valley ×2 at 17.56/46.86, Thacher Creek Trailhead at 34.90, the
  water stop ×2 at 42.0/85.36, Gridley Top ×3 at 52.24/63.36/79.60,
  Gridley Bottom at 57.91, Cozy Dell at 71.54), and the Finish at
  100.23. Eight unique coordinates (the Start and Finish share the
  school marker).
- **Crew.** `false` everywhere (decision 8).
- **Pacers.** `true` at Gridley Bottom and Cozy Dell (decision 9);
  `false` elsewhere.
- **Drop bags.** `true` at both Rose Valley passes, Thacher Creek
  Trailhead (the Horn Canyon bag), Gridley Bottom, and Cozy Dell;
  `null` at the Start; `false` elsewhere.
- **Medical.** `null` everywhere — no published medical service.
- **Elevation series.** USGS 3DEP per nominal mile (decision 11);
  station spots carry the turn-by-turn's printed elevations.
- **Follow.** No live tracking published; results on UltraSignup.

## Stale-source traps

- The Runners page's start-times table and lower prose still carry
  2025/2026 dates; the 2027 listing governs.
- The 100-page's CalTopo button has an empty href — the working map
  link is the Runners page's "100M Topo map".
- The turn-by-turn's paired mile prints and station numbering
  (decisions 2-4); re-check whether the organizer reconciles them.
- The Strava and HelloDrifter maps are login-walled; CalTopo is the
  open geometry surface.
- run100s' May 21-22 dates and 40-hour cutoff are superseded (April
  30 - May 2; 42 hours).

# Rocky Raccoon 100 (2027) source audit

Verified on 2026-08-13. This audit uses only Tejas Trails material: the
official race page, the published aid station chart, the official GPX and
course-map downloads, and the RunSignup race site. It records what those
sources actually establish; it does not treat an organizer label as proof
that a fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The official page and
RunSignup site support the February 6–7, 2027 date, the 6:00 AM mass start,
5 × 20-mile laps at Huntsville State Park, ~1,250 ft of gain per lap, open
registration with a sell-out warning, and pacer/drop-bag rules. The aid
station chart supplies every pass mile, crew flag, drop-bag flag, and the
rolling final-lap cutoffs. The organizer's own surfaces conflict in three
small ways, recorded below.

Recorded discrepancies:

1. **Final-lap cutoff.** The race page summary says the final lap must start
   by 7:41 AM; the aid chart's mile-80 row says 7:36 AM (25 hr 36 min). The
   chart governs the pass rows; the conflict is noted in `source_notes`.
2. **Chart rounding.** The chart's final-lap Gate/Nature Center/Dam Nation
   rows print miles 84/89/94 while its own splits (3.8/5.3/5.0/5.9) sum to
   83.8/89.1/94.1. The record uses the split arithmetic.
3. **GPX vintage and length.** The official GPX download is embedded-named
   "2021 Rocky Raccoon 100" and its GPS-recorded lap measures 21.5 miles
   against the chart's 20.0 frame. It is used for geometry and elevations
   only (Bighorn precedent); its trailing junk zero-elevation point is
   replaced by the start value in the profile.
4. **run100s staleness.** run100s lists a 30-hour cutoff and 5,375 ft of
   climb; the chart's ladder ends at 32 hours and the page says ~1,250
   ft/lap. Neither run100s figure was copied.
5. **Elevation gain.** `elevation_gain_ft` is 6,250 — five times the page's
   ~1,250 ft per full lap — recorded as derived arithmetic on the
   organizer's figure.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Rocky Raccoon 100 official page | https://www.tejastrails.com/rocky100/ | Supports February 6, 2027; Huntsville State Park, 565 Park Road 40 West, Huntsville, TX; 5 × 20-mile laps (100K = short lap + 3 full); ~1,250 ft gain/loss per lap; 6:00 AM 100M start (start line closes 6:30); the 7:41 AM final-lap summary figure; 2:00 PM Sunday course closure; pacers after mile 49 with the 60+ exception; Gate/Dam Nation drop-bag delivery due Friday 7 PM; cupless/leave-no-trace rules; course marking; links to the GPX, course map, aid chart, RunSignup, pacer form, camping store, and EDS live results. |
| S2 | Aid station chart (published spreadsheet PDF) | https://docs.google.com/spreadsheets/d/e/2PACX-1vRM-Ahyl7-ubj3bVBhmjvFS_RgWKuKYKLu0WkdzarQCFLTfYgBZ_lW5qPDheCmcFzWkTmw5jm7PqBrk/pub?output=pdf | Pass authority: sequence, splits (3.8/5.3/5.0/5.9), miles, drop-bag delivery (Gate and Dam Nation only), crew Y everywhere with parking limits (Coloneh lot for Gate/Dam Nation, a few spots at Nature Center), full hot-and-cold service at every pass, and the rolling cutoffs (mile 80 7:36 AM; 84 8:48 AM; 89 10:30 AM; 94 12:06 PM; finish 2:00 PM = 32 hr) with the 19:12 slowest-pace framing. |
| S3 | Official course GPX download | https://drive.google.com/file/d/1P_JGfJT723SU5x2Q1boWpgR6vLmxbws4/view?usp=sharing | Geometry authority: 3,004 track points with elevations forming one closed lap (2 ft closure) that GPS-measures 21.5 miles; embedded name "2021 Rocky Raccoon 100". `db/events/rocky-raccoon-100.gpx` copies its points exactly and adds station waypoints at the chart's lap miles (the download has none); Tyler's is the track start. |
| S4 | Official course map download | https://drive.google.com/file/d/1OcIEOuX_4RVs19C49DULJjNXTaV4MWkI/preview | Visual course map linked beside the GPX. |
| S5 | RunSignup race site | https://runsignup.com/Race?raceId=76532 | Supports "Sat February 6 - Sun February 7 2027", open registration ("Register early as these races both sell out and go to Wait list"), and 2027 campsite reservations; `registration_url`/`results_url` point here. |

## Claim-level decisions

- **Name.** "Rocky Raccoon 100" (S1). First run in 1993 (run100s first-year
  datum, corroborated by the race's own history framing on S1).
- **Registration status.** `open` — S5 sign-up live at verification; the
  sell-out warning stays in prose.
- **Lottery.** `false` — direct first-come RunSignup registration.
- **Cutoffs.** Five both-form rolling cutoffs from the 6:00 AM CST mass
  start: 80 = 7:36 AM (1,536 min); 83.8 = 8:48 AM (1,608); 89.1 = 10:30 AM
  (1,710); 94.1 = 12:06 PM (1,806); 100 = 2:00 PM (1,920).
- **Station passes.** 21: the Start plus Gate (+3.8), Nature Center (+9.1),
  Dam Nation (+14.1), and Tyler's (+20) on each of five laps, the last
  recorded as the Finish.
- **Crew.** `true` at every pass (chart column), with the chart's parking
  limits in `park` notes.
- **Pacers.** Guarantee-based booleans: `true` from mile 49.1 onward, `false`
  before, with the 60-and-older full-race exception in notes.
- **Drop bags.** `true` at Gate and Dam Nation passes (chart "we can
  deliver"; bags due Friday 7 PM), `false` at Nature Center and Tyler's
  passes (chart "no delivery"), `null` at the Start.
- **Medical.** `null` everywhere — no published medical service.
- **Elevation series.** The official GPX's elevations sampled per lap mile
  and repeated per lap, with the junk trailing zero replaced by the start
  value; station spot elevations are the file's values at the waypoint
  positions.
- **Follow.** Live timing through EDS (S1's live-results link); official
  results on RunSignup.

## Stale-source traps

- The GPX download's embedded metadata says 2021; use it for geometry and
  elevations only, never for dates or operations.
- The linked EDS live-results URL is year-stamped (2026rr100); the 2027 URL
  will differ.
- run100s' 30-hour cutoff and 5,375 ft climb are stale; the chart and page
  govern.
- The pacer-form link is stamped "PACER2026Registration"; expect a 2027
  form.

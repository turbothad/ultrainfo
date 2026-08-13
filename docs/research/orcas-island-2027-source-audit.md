# Orcas Island 100 (2027) source audit

Verified on 2026-08-13. This audit uses only Rainshadow Running material: the
official race page, the official course GPX download, the linked course
description and station-directions Google Docs, and the organizer's CalTopo
map. It records what those sources actually establish; it does not treat an
organizer label as proof that a fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The official page supports
the February 26, 2027 start (8:00 AM Friday), four nominal 25-mile Moran
State Park loops totaling 100.8 miles, ~26,000 ft of gain, the 36-hour limit
with the full last-lap cutoff ladder, per-lap crew rules for all four
stations, pacer rules from mile 25, drop-bag logistics, and open registration
on Webscorer. The official GPX ships with the four station waypoints and
elevations.

Recorded discrepancies and decisions:

1. **Mile frame.** The organizer bills 25-mile loops and quotes last-lap
   cutoffs at miles 75/80/90/96/100, while calling the total 100.8; the
   official GPX GPS-measures the loop at 24.0 miles. The nominal 25-mile
   frame governs pass miles (Mountain Lake 5, Cascade Lake 15, Mt
   Constitution 21, Camp Moran 25 per lap), matching both the cutoff table
   and the results-sheet split columns (15/21/25/40/46/50/...).
2. **GPX vintage.** The current download's embedded name is "2026 Orcas 100
   (revised 2.23)"; it is the file the 2027 page links, used for geometry,
   waypoints, and elevations. Its per-loop elevation sum (~6,650 ft; ~26,600
   over four loops) corroborates the published ~26,000.
3. **Post-8 PM finishes.** The page states a runner who leaves the last aid
   station by its cutoff earns an official finish even after the 8:00 PM
   close; the finish pass records 8:00 PM/2,160 with that caveat in notes.
4. **Crew laps.** Mountain Lake laps 2–4 only; Cascade Lake all laps; Mt
   Constitution lap 4 only and road-dependent; Camp Moran always. Lap-1
   passes at Mountain Lake and Mt Constitution are crew-false.
5. **Pacers.** From mile 25 only (none on lap 1), starting at crew-accessible
   stations — Mt Constitution pickup on the last lap only; registration and
   a pacer bib at Camp Moran; no muling. Booleans follow pickup
   availability per pass.
6. **Water potability and medical.** Full aid everywhere; potability never
   certified; no published medical service.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Orcas Island 100 official page | https://www.rainshadowrunning.com/orcas100.html | Primary source: February 26, 2027; Olga, WA; four 25-mile loops, 15 aid encounters framing, ~26,000 ft, 36-hour cutoff; schedule (Thursday bib pickup/drop-bag drop at Camp Moran, Friday 7:00-7:50 check-in, 7:30 Mountain Lake drop-bag deadline and 8:00 for other stations, 8:00 AM start); last-lap cutoffs (Camp Moran 75 at 11:00 AM, Mountain 80 at 12:45 PM, Cascade Lake 90 at 4:00 PM, Mt Constitution 96 at 6:15 PM, finish 8:00 PM with the out-of-last-aid exception); Crew Access & Pacers rules per station and lap; Tower Club; ferry-reservation guidance; Discover Pass parking; Trail Mix Fund; registration and results links; land acknowledgment. |
| S2 | Official course GPX download | https://www.rainshadowrunning.com/uploads/2/6/1/4/26141050/2026_orcas_100__revised_2.23_.gpx | Geometry authority: 1,804 track points with elevations (354-2,402 ft) and four named station waypoints (Camp Moran 48.648505,-122.842512 at 440 ft; Mountain 48.655083,-122.818844 at 928 ft; Cascade 48.656174,-122.855579 at 358 ft; Constitution 48.677531,-122.831375 at 2,388 ft). Loop GPS-measures 24.0 miles (49 ft closure). `db/events/orcas-island-100.gpx` copies points and waypoints exactly. |
| S3 | Course description document | https://docs.google.com/document/d/1psSza3f-xV_Nsope3KfCoFYUVDOdupAW2mV05w6M_pg/edit?usp=sharing | Turn-by-turn loop description; places Mountain Lake Aid at mile 5 and Cascade Lake Aid at mile 15 and describes the Constitution climb and tower option. |
| S4 | Organizer CalTopo course map | https://caltopo.com/m/1QAU0 | Interactive companion map linked beside the GPX. |
| S5 | Camp Moran directions document | https://docs.google.com/document/d/1sg6qIkXcfaSKz6KFTbZtdIt_j9jtqtiBcQmFsGKHCZo/edit?usp=sharing | "Crew allowed at the start/finish and on every lap" plus driving directions. |
| S6 | 2027 Webscorer registration | https://www.webscorer.com/register?pid=1&raceid=423395 | Live "Register Now for 2027" target; early-bird $450 before April 1. |
| S7 | Chronokeep results | https://chronokeep.com/results/orcas-island-100m | Results surface linked from the page (2026 results live there); `results_url`. |

## Claim-level decisions

- **Name.** "Orcas Island 100" (S1).
- **Registration status.** `open` — S6 live at verification.
- **Lottery.** `false` — direct Webscorer registration for this race;
  Rainshadow's lottery pages cover other events.
- **Cutoffs.** Five both-form last-lap cutoffs from the 8:00 AM PST Friday
  start: 75 = 11:00 AM (1,620), 80 = 12:45 PM (1,725), 90 = 4:00 PM
  (1,920), 96 = 6:15 PM (2,055), 100 = 8:00 PM (2,160) with the
  out-of-last-aid exception noted.
- **Station passes.** 17: the Start plus Mountain Lake (+5), Cascade Lake
  (+15), Mt Constitution (+21), and Camp Moran (+25) on each of four loops,
  the last recorded as the Finish.
- **Crew.** Per-lap booleans from S1's table (decision 4).
- **Pacers.** Pickup booleans from mile 25 per S1 (decision 5).
- **Drop bags.** `true` at every non-Start pass — all four stations take
  bags with staggered deadlines; `null` at the Start.
- **Medical.** `null` everywhere — no published medical service.
- **Elevation series.** The official GPX's elevations sampled per nominal
  lap mile and repeated per lap; station spot elevations are the GPX
  waypoints' track values.
- **Follow.** Chronokeep results (S7); no live tracking is published.

## Stale-source traps

- The GPX download is the 2026-revision file; re-check for a 2027 revision
  before race week (the organizer revised mid-February in 2026).
- The results-sheet split columns use informal station names (Lakeside,
  Forestside) that do not match the GPX waypoint names; the GPX names
  govern.
- run100s' row matches this year's figures but its 2/26-27 date spans the
  Friday start and Saturday finish, not two race days.
- Mt Constitution crew access depends on the summit road being open;
  re-check in bad weather years.

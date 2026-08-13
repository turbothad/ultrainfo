# LOViT 100 (2027) source audit

Verified on 2026-08-13. This audit uses only runlovit.com material: the
site's 2027 pages (home, details, cutoffs, aid stations, pacers, drop bags),
the published 100 Mile aid station chart, and the official GPX downloads.
It records what those sources actually establish; it does not treat an
organizer label as proof that a fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The site is fully updated
for February 27–28, 2027: the details page gives the 6:00 AM Saturday start,
34-hour cutoff, and course records; the aid chart gives all 23 passes with
cumulative miles and crew/drop-bag/restroom flags; the cutoffs page gives
four firm cutoffs; the pacing page lists the six safety-runner pickup
stations; and the GPX page hosts the official course files. The organizer's
surfaces conflict on three station miles, recorded below.

Recorded discrepancies and decisions:

1. **Cutoff-page miles vs the chart.** The cutoffs page quotes Avery Rec
   Area at 34.5, Hickory Nut Mountain at 66, and ADA (west end) at 81; the
   aid chart's cumulative column puts those passes at 32.8, 62.9, and 79.4.
   The chart (which also carries the crew/drop columns) governs pass rows;
   both figures are recorded in the pass source notes.
2. **Pacing-page miles.** The pacing page's "approximate mileage" lists
   Charlton (Westbound) at 58 against the chart's 55; the chart governs.
3. **Course shape.** Two out-and-backs from Mountain Harbor's East Cove:
   east to the Avery Rec Area turnaround (32.8) and west to the ADA west
   end turnaround (79.4). Both turnaround passes carry direction
   Turnaround; other mid-race passes are unlabeled per the domain
   vocabulary for courses that fit neither the loop nor the single
   out-and-back frame.
4. **GPX.** The official download's embedded name is "LOViT 100M 2025" and
   it is the current file on the 2027 site; it GPS-measures 97.6 miles
   against the chart's 100-mile cumulative frame and sums ~13,500 ft of
   gain. The organizer publishes no gain figure (run100s' 17,000 was not
   copied), so gain stays null. Station waypoints are placed at each
   station's first chart mile along the track; the out-and-back mirror
   symmetry (4.1/95.9, 16.5/50.5, and so on) corroborates the placements.
5. **Water potability and medical.** Stations serve standard ultra food
   with water and Tailwind; the two Spillway passes are marked minimal
   (recorded food-false); potability is never certified and no medical
   service is published.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | LOViT site home | https://www.runlovit.com/ | Supports February 27–28, 2027; Mt. Ida, AR; Mountain Harbor Resort host; the new East Cove start/finish; 6:00/7:00/8:00 AM starts by distance. |
| S2 | Race details page | https://www.runlovit.com/race/details | 100M start Saturday, February 27, 2027 6:00 AM with a 34-hour cutoff (Sunday 4:00 PM, 20:24 pace); course records (Karl Meltzer 19:36:36, Bea Miller 21:45:41); 22 manned aid stations on the 100-mile course; swag deadlines through January 31, 2027. |
| S3 | Cutoffs page | https://www.runlovit.com/cutoffs | Firm cutoffs: Avery Rec Area 5:35 PM Saturday (11:35), Hickory Nut Mountain 4:30 AM Sunday (22:30), ADA west end 10:00 AM Sunday (28:00), finish 4:00 PM Sunday (34:00) — quoting miles 34.5/66/81/100 against the chart's frame. |
| S4 | Aid stations page and 100 Mile chart | https://www.runlovit.com/aid-stations | The 23-row 100 Mile aid station chart (station, split, cumulative mile, crew, drop bag, restroom) plus the standard-ultra-food and Tailwind inventory. |
| S5 | Pacing and safety runners page | https://www.runlovit.com/pacers | Six 100-mile pickup stations (Brady Mountain westbound 39.8; Crystal Springs 50.5; Charlton westbound ~58; Joplin westbound 68.3; ADA west end 79.4; Joplin eastbound 90.5); one safety runner at a time; waiver and bib; 60-and-older exception with prior RD permission. |
| S6 | Drop bags page | https://www.runlovit.com/drop-bags | Bags to the start/finish, Tompkin's Bend (100-mile only), Crystal Springs Pavilion, and Avery Rec Area; labeling rules; rolling return schedule; donation of unclaimed items. |
| S7 | Official 100-mile GPX download | https://www.runlovit.com/s/lovit-100m-2025-jzzs.gpx | Geometry authority: 5,057 points with elevations (427–1,319 ft), GPS length 97.6 miles, start/end at Mountain Harbor (34.574459, -93.432167). `db/events/lovit-100.gpx` copies the points exactly and adds waypoints at each station's first chart mile. |
| S8 | Organizer CalTopo maps | https://caltopo.com/m/GB9S (and /m/SA4A) | Interactive companions linked from the GPX page. |

## Claim-level decisions

- **Name.** "LOViT 100" — the Lake Ouachita Vista Trail race (S1).
- **Registration status.** `open` — the site's Register page is live with
  2027 swag deadlines ahead.
- **Lottery.** `false` — direct registration.
- **Cutoffs.** Four both-form firm cutoffs from the 6:00 AM CST start:
  32.8 = 5:35 PM (695); 62.9 = 4:30 AM (1,350); 79.4 = 10:00 AM (1,680);
  100 = 4:00 PM (2,040).
- **Station passes.** 23 chart rows over twelve physical locations, with
  Avery (32.8) and ADA (79.4) as the two Turnarounds and the final
  Mountain Harbor row as the Finish.
- **Crew/drop/restrooms.** Copied column-for-column from the chart;
  restroom rows carry bathroom notes.
- **Pacers.** `true` exactly at the six pickup stations; the 60-and-older
  exception lives in notes.
- **Medical.** `null` everywhere — no published medical service.
- **Elevation series.** The official GPX's elevations sampled per nominal
  chart mile across the full course; station spot elevations are the GPX
  values at the derived waypoints.
- **Follow.** Results on the site's results page; no live tracking is
  published.

## Stale-source traps

- The GPX file name says 2025; it is the current download for 2027 — use
  it for geometry only and re-check before race week.
- run100s' row carries 2023 results, a 17,000 ft climb figure with no
  organizer counterpart, and predates the East Cove start/finish move.
- The cutoffs and pacing pages quote miles from an older frame; the aid
  chart's cumulative column is the consistent authority.

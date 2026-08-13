# HURT 100 (2027) source audit

Verified on 2026-08-13. This audit uses only organizer-owned HURT100.com
material and the course files that site links directly (the official
HURT100.gpx download and the organizer's Google My Maps course map). It records
what those sources actually establish; it does not treat an organizer label as
proof that a fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The Book of HURT 2027
supports the January 16–17, 2027 date, the 6:00 AM start at the Hawaiʻi Nature
Center, five nominal 20-mile laps, 24,500 ft of cumulative gain per 100 miles,
the three stations and their identical aid inventories, every intermediate and
final cutoff, crew and pacer and drop-bag rules, and the lottery with its
weighting system. The organizer's own course files contradict the nominal
20-mile lap length, and no organizer file carries track elevations.

Recorded discrepancies:

1. **Lap length.** The organizer frames the race as 5 laps of a 20-mile loop
   (cutoff table miles 80/87/92.5/100). The official HURT100.gpx route
   measures ~16.8 miles per loop and the My Maps legs ~18.8 miles. Dense-canopy
   GPS shortening on switchbacked single track is the likely cause, but no
   source says so. The record keeps the organizer's cutoff-table frame and
   notes the measurements.
2. **Elevations.** Neither the official GPX (route points only) nor the KML
   line for the loop carries usable track elevation in a form the organizer
   labels; the My Maps course legs embed per-point altitudes, and the profile
   and station spot elevations use those values (Makiki 434 ft, Mānoa 521 ft,
   Nuʻuanu 830 ft). Per-lap gain computed from those altitudes (~5,300 ft,
   ~26,600 ft per 100 miles) corroborates the published 24,500 ft figure; the
   record publishes the organizer's 24,500.
3. **Water potability.** Water is listed at all stations; nothing certifies
   potability. `potable_water` stays null at every pass.
4. **Medical.** The Book of HURT explicitly lists "typical first-aid items" as
   NOT provided at aid stations, so `med` is recorded as `false` at every
   pass — an established negative, unlike the null default.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | HURT100 site home | https://hurt100.com/ | Entry point; links the Book of HURT, course map page, and results page. |
| S2 | Book of HURT 2027 | https://hurt100.com/book-of-hurt-2027/ | Primary operational source: January 16–17, 2027; 6:00 AM start; Hawaiʻi Nature Center, 2131 Makiki Heights Drive; 5 laps, 99% single track, 24,500 ft gain, 20 stream crossings; 36-hour limit; cutoffs Makiki mile 80 11:00 AM, Mānoa mile 87 1:30 PM, Nuʻuanu mile 92.5 3:30 PM, finish 6:00 PM Sunday, stations closing 15 minutes after cutoff; station inventories and the explicit not-provided list; crew rules (Makiki anytime, Mānoa not before 10:00 AM Saturday, Nuʻuanu never, 100-yard rule, authorized parking); pacer rules (after 60 miles or 5:00 PM Saturday, one pacer, starts only at Mānoa or Makiki, bib, aid-station entry/exit rules); drop-bag rules (12x12x18, Makiki delivery 4:45–5:45 AM, Arboretum Trail staging, retrieval by 6:15 PM Sunday at Hālau Kū Māna); lottery (registration July 15–28 2026, drawn August 8 2026, 130 runners, kukui-nut weighting, qualifying 50-mile finish, 8 hours trail work); $425 fee. |
| S3 | Course map page | https://hurt100.com/course-map/ | Links the official GPX, KML, CalTopo map (caltopo.com/p/F08HC), and the My Maps course map. |
| S4 | Official HURT100.gpx route download | https://hurt100.com/HURT100.gpx | Geometry authority: CALTOPO export, one `full loop` route of 1,230 points starting and ending at Makiki (25 ft closure gap), measuring ~16.8 miles. SHA-256 c1d490a3fe0d8d27797195e8a09ccd3850e1e93561667f0b67fd618a750cc012. `db/events/hurt-100.gpx` copies these coordinates exactly, converted from route points to track points because Ultrainfo reads tracks; no elevations. |
| S5 | Organizer Google My Maps "HURT 100 Course" (KML export) | https://www.google.com/maps/d/kml?mid=12L8hV6-KuFKDGc26uqvEzbxSJ1_NN2Q&forcekml=1 | Station placemarks (Makiki 21.316378,-157.827723; Mānoa 21.331349,-157.801411; Nuʻuanu 21.346832,-157.820921) used as GPX waypoints, and three course legs with embedded altitudes used for the elevation profile and spot elevations. Leg positions put Mānoa at ~6.9 and Nuʻuanu at ~11.8 of an ~18.8-mile loop, consistent with the Book's mile 7 / mile 12.5 frame. |
| S6 | Race data and past results page | https://hurt100.com/race-data-and-past-results/ | Official results surface; used for `results_url`. |

## Claim-level decisions

- **Name.** "HURT 100" (site branding; run100s lists "HURT"). H.U.R.T. is the
  Hawaiian Ultra Running Team.
- **Registration status.** `closed` — the 2027 lottery was drawn August 8,
  2026; the field is set. `registration_url` points at the Book of HURT, the
  organizer's canonical entry-process document.
- **Lottery.** `true` — fully documented in S2 (categories, weighting,
  reserved slots).
- **Cutoffs.** All both-form (clock + elapsed from the 6:00 AM Saturday
  start): mile 80 = 11:00 AM Sunday = 29h; mile 87 = 1:30 PM = 31.5h; mile
  92.5 = 3:30 PM = 33.5h; mile 100 = 6:00 PM = 36h. Station closure 15
  minutes after cutoff is carried in source notes.
- **Crew.** Makiki passes `true`; Mānoa `false` on the first pass (mile 7 —
  access opens 10:00 AM Saturday and most runners reach mile 7 near or before
  then) and `true` with the time note from mile 27 on; Nuʻuanu `false` always
  (explicit prohibition).
- **Pacers.** Guarantee-based booleans, matching the Southern Tour precedent:
  `true` only where distance alone guarantees eligibility at a permitted
  station (Makiki/Mānoa passes from mile 60), `false` elsewhere with the
  5:00 PM Saturday exception and the no-starts-at-Nuʻuanu rule in notes.
- **Drop bags.** `true` at Makiki lap passes (bags staged into that station),
  `null` at the Start (bags are handed in pre-race), `false` at Mānoa and
  Nuʻuanu (S2 locates the service exclusively at Makiki).
- **Medical.** `false` everywhere — S2's explicit not-provided list.
- **Station passes.** 16: Start, then Mānoa (mile 7), Nuʻuanu (12.5), Makiki
  (20) per lap, final Makiki pass recorded as the Finish.
- **Elevation series.** S5 leg altitudes sampled per nominal lap mile and
  repeated per lap; flagged as map-derived in `source_notes`.

## Stale-source traps

- run100s.com's row (36h cutoff, 24,935 ft climb) roughly matches but is not
  organizer material; its climb figure differs from the Book's 24,500 and must
  not be copied.
- The CalTopo map p/F08HC is interactive; the checked-in geometry must always
  be regenerated from the direct HURT100.gpx download, not hand-traced.
- Older editions' Books of HURT remain online at similar URLs; only the 2027
  edition governs this record.

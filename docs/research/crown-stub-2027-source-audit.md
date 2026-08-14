# Crown Stub 100 (2027) source audit

Verified on 2026-08-13. This audit uses only Bivouac Racing material:
the Crown Stub 100 page and its Course Maps/GPX and Aid Stations & Crew
Access subpages, the aid spreadsheet they link, the organizer CalTopo
course map, and the UltraSignup 2026 and 2027 listings. It records what
those sources actually establish; it does not treat an organizer label
as proof that a fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The 2027 UltraSignup
listing pins April 24, 2027 with the 12:00 PM start and open
registration; the race pages carry the 32-hour cutoff, the single
Stewarts Gate intermediate cutoff, drop-bag and pacer rules, and the
crew system; the aid spreadsheet carries the pass table (thirteen
station passes); and the CalTopo
map carries the course line with elevations and station markers. The
course runs from the Hilltop Day Use Area at L.L. Stub Stewart State
Park over the Banks-Vernonia trail system with out-and-backs to the Hwy
30 and Banks turnarounds.

Recorded discrepancies and decisions:

1. **run100s is stale three ways.** Its April 3 dating and the
   onboarding snapshot's 30-hour cutoff and 10,000-foot climb (columns
   the live table no longer displays) have no counterpart: the 2027 listing says
   April 24, the aid page says 32 hours (8:00 PM Sunday close), and
   the race page says just over 7,000 feet of gain.
2. **The chart's Vernonia totals are internally wrong.** The chart
   prints 18 and 58, but its own segment chain gives 5.1 + 10.9 = 16.0
   and 49.6 + 11.2 = 60.8, the aid page's drop-bag list says 16.0 and
   60.8, and the CalTopo line crosses the Vernonia marker at scaled
   miles 15.8 and 61.0. The corrected 16.0 and 60.8 govern those two
   passes, each with a pass-specific source note (the Sugar Creek
   pattern: a chart's own internal evidence outranks its typo).
3. **The aid page's Stewarts Gate drop miles conflict the other way.**
   Its 94 and 100.7 disagree with the chart's 92.3 and 98.2; the line
   corroborates the chart (crossings at 92.1 and 98.7), so the chart
   governs and the prose conflict is recorded.
4. **Turnaround rows.** The chart's two RACE TURNAROUND POINT rows (Hwy
   30 at 38.3, Banks at 81.7) are recorded as no-aid Turnaround passes;
   other mid passes are unlabeled per the domain vocabulary.
5. **Frame.** The chart's cumulative column ends at 100.2 (governs);
   the CalTopo line GPS-measures 98.62 miles with an 1,805-foot gap
   between its drawn endpoints (so the Finish pass reuses the Hilltop
   hub's coordinates and elevation).
6. **Stale register button.** The Crown Stub page's "Register here"
   still points at the 2025 listing (did=121852); the chain runs
   through the 2026 listing (did=131712) to the 2027 page (eid=17228).
7. **Medical.** The aid page says official stations are "fully stocked
   with food, hydration, medical support, and volunteers" — med true
   at the thirteen mid-race station passes, null at the Start,
   turnarounds, and Finish.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Crown Stub 100 page | https://www.bivouacracing.com/karissawhyracingeventscom | The Realm (Stub Stewart State Park, Buxton, OR); April 24-25, 2027; starts (100 at 12:00 PM, relay 2:00 PM, Hill Top Day Use Area); just over 7,000 feet of gain; more than 25 crew access locations; King and Queen of Stub and the Royal Purse; pricing tiers from August 1, 2026; the stale 2025 Register here link. |
| S2 | Course Maps/GPX page | https://www.bivouacracing.com/new-page-1 | The CalTopo link; course tips (single track for the first four-plus miles, shoe changes at Stewarts Gate, the Vernonia headlamp requirement); relay squire guidance. |
| S3 | Aid Stations & Crew Access page | https://www.bivouacracing.com/new-page-2 | Thirteen station passes; the page counts four full-service stations while naming two locations (Stewarts Gate and Vernonia) with burgers, grilled cheese, and quesadillas; typical aid elsewhere with Skratch Labs; crew access points and the no-sitting-in-vehicles rule; drop bags (two per runner, six accesses, with the 94/100.7 prose conflict); pacers from Pisgah (40.2); cutoffs (32 hours, 8:00 PM Sunday close, Stewarts Gate 71.7 at 2:00 PM Sunday). |
| S4 | Aid stations and crew spreadsheet | https://docs.google.com/spreadsheets/d/1nv_Gb56o1HHzEfubp1HNgr9K4k_l0vFQD7CxZ0gQzlE/edit | The pass table: the Start, thirteen station passes with totals and segments, two turnaround rows, crew access points with map links, drop-bag flags, bathroom notes, the 2:00 PM Sunday cutoff, and the Finish at 100.2 — including the internally conflicted Vernonia totals (decision 2). |
| S5 | Organizer CalTopo course map | https://caltopo.com/m/BEDR0FU | Geometry and elevation authority: the Crown Stub 100 LineString (4,761 points with elevations, 98.62 GPS miles) plus station, turnaround, and relay-exchange markers. `db/events/crown-stub-100.gpx` copies the line exactly and the nine station-relevant markers. |
| S6 | UltraSignup 2027 registration page | https://ultrasignup.com/register.aspx?eid=17228 | "Crown Stub 100 - April 24, 2027"; Start Times (100 Miler 12:00 PM, Royal Ultra Relay 2:00 PM); open registration $197 rising after August 31; closes April 23, 2027; results 2024-2026. |
| S7 | UltraSignup 2026 listing | https://ultrasignup.com/register.aspx?did=131712 | "Crown Stub 100 - April 4, 2026"; the chain to the 2027 page; results tabs. |

## Claim-level decisions

- **Name.** "Crown Stub 100" (S1/S6).
- **Registration status.** `open` — S6 sells both events.
- **Lottery.** `false` — direct registration.
- **Cutoffs.** Two: Stewarts Gate 71.7 = 2:00 PM (1,560) and the finish
  100.2 = 8:00 PM (1,920). `cutoff_hours` 32 from the noon start.
- **Station passes.** 17: the Start, thirteen station passes over seven
  physical stations (Stewarts Gate ×4, Vernonia ×2, Nehalem ×2, Pisgah
  ×2, Manning ×2, Hill Top Day Use ×1), the two Turnarounds, and the
  Finish.
- **Crew.** `true` where the chart says crew access (Vernonia, Pisgah,
  Manning, Hill Top, and the start/finish hub); `false` at Stewarts
  Gate and Nehalem per its NO CREW ACCESS notes and at the
  turnarounds. The 25-plus between-station crew points live in notes.
- **Pacers.** `true` at Pisgah mile 40.2 only — the single published
  join point; `false` elsewhere with the rule noted.
- **Drop bags.** `true` at the four Stewarts Gate and two Vernonia
  passes; `false` elsewhere; `null` at the Start.
- **Medical.** `true` at the thirteen mid-race station passes (decision 7).
- **Elevation series.** The CalTopo line's elevations per nominal chart
  mile (63-1,437 ft; the course drops from the 1,214-foot Hilltop to
  the Hwy 30 lowlands); station spots at each station's first pass
  mile.
- **Follow.** No live tracking published; results on UltraSignup.

## Stale-source traps

- The Crown Stub page's Register here button points at the 2025
  listing; use the eid chain.
- The aid page's drop-bag miles (94, 100.7) and the chart's Vernonia
  totals (18, 58) are both wrong in different directions; the
  corrected frame is decision 2/3. Re-check whether the organizer
  fixes either surface.
- Crew driving directions "will be updated once our permits are
  finalized" — re-check for the final crew map.
- run100s' dates, cutoff, and climb are all stale (decision 1).

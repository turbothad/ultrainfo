# Forgotten Florida 100 (2027) source audit

Verified on 2026-08-13. This audit uses only Run Bum Tours material: the
official race page, the Runners Handbook and crew-directions Google Docs it
links, the 2027 UltraSignup listing, and the organizer's CalTopo course maps —
plus USGS 3DEP spot elevations. It records what those sources actually
establish; it does not treat an organizer label as proof that a fact is
current or internally consistent.

## Bottom line

The record is publishable with a source warning. The 2027 UltraSignup listing
confirms January 30–31, 2027, the four distances, open registration (11
100-mile spots at verification, closing January 29), and pricing. The Runners
Handbook supplies the entire operational frame — a complete 100-mile aid
station matrix with leave-by cutoffs, drop-bag, crew, and pacer columns — but
is the 2026 edition, so matrix details are flagged as prior-edition material.

Recorded discrepancies and decisions:

1. **Course length.** The matrix totals 98.85 miles against the billed 100,
   and the organizer notes that figure includes the mandatory 1-mile St
   Nicholas shuttle van ride across Highway 50; the CalTopo line measures
   98.3. `distance_mi` stays the billed 100 with the figures in notes.
2. **Handbook edition.** The handbook was updated January 15, 2026 for the
   prior running (its timeline says 1/30/26–2/1/26). The 2027 site and
   listing confirm date/distances/registration; the matrix, 6:30 AM start,
   and logistics carry over with a warning. The organizer explicitly says
   "all mileage is 'ish'" and cutoffs are leave-by times.
3. **Shuttle crew conflict.** The CalTopo map marks the shuttle pickup
   "crew access", and the 50-mile matrix agrees, but the 100-mile matrix says
   crew NO at St Nicholas Shuttle. The 100-mile matrix governs this record;
   the conflict is noted.
4. **Wheeler Road naming.** The matrix calls the mile-47 crew point WHEELER
   RD; the organizer map's marker there is "Seminole Ranch Crew access no
   aid". The record uses the matrix name with the map marker's coordinates.
5. **Turnaround.** The 50-mile finish line at mile 52.6 is the 100-mile
   turnaround (matrix row "50 MILE FINISH LINE", crew and pacer YES, no aid
   table); the record marks it direction Turnaround. Runners pass within
   about a half mile of their parked cars there and may restock after
   checking in.
6. **Elevation.** No organizer elevation data; the CalTopo line is 2-D.
   Stations sit at 8–42 ft (USGS 3DEP); gain/loss stay null.
7. **Water potability.** Aid is cupless with fluids at stations; nothing
   certifies potability. Full stations stock first-aid and blister kits, but
   no medical checks or staff are published, so `med` stays null.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Forgotten Florida official race page | https://www.runbumtours.com/forgotten-florida | Supports January 30–31, 2027; Christmas, FL; distances (100/50/15/8); course narrative (Tosohatchee, Charles Bronson State Forest, Seminole Ranch, Little Big Econ; palm groves and pine flatwoods); links to the handbook, crew doc, and UltraSignup. |
| S2 | Runners Handbook (2026 edition, Google Doc) | https://docs.google.com/document/d/1e0v2GSyR2vGxXzGn1Hd-t8bmzy-1YSL1id1pM8BsKTM/edit?usp=sharing | Primary operational source, updated 2026-01-15: start venue (Shane Kelly Park, 1555 County Rd 426, Oviedo — 28.67520 N, 81.17543 W) and finish (Tosohatchee WMA, 3364 Taylor Creek Rd, Christmas); 6:30 AM 100/50-mile start; 34-hour cutoff; the complete 100-mile aid station matrix (names, segment/total miles, aid levels, drop bags, crew, pacer, leave-by cutoffs from 7:40 AM at mile 4 to 4:30 PM Sunday at 98.85, shuttle closing 9:30 PM sharp); aid inventories and hot food; first-aid/blister supplies; no portable toilets on course; drop-bag rules (2.5-gallon clear bags; Joshua Creek and Charlie Lake x3); pacer rules (from the 50-mile turnaround, one at a time, swaps at crew stations, FWC waiver); crew guidance (one car per runner, Joshua Creek day-pass fee); required gear (smartphone, GPX, 300+ lumen headlamp from Joshua Creek, 1.5 L capacity); $3 WMA cash fee; $35 optional start shuttle at 5:10 AM; cupless; CalTopo map links per distance. |
| S3 | Crew directions (Google Doc) | https://docs.google.com/document/d/1dQSAHWKk3vTFKKDwq43QUsTXc71pHIB8Jmvozp_WrXc/edit | Crew routing to the crew-accessible points; referenced by the handbook. |
| S4 | 2027 UltraSignup listing | https://ultrasignup.com/register.aspx?did=135495 (eid=13123) | Current authority: "Forgotten Florida - January 30 - 31, 2027"; 3365 Taylor Creek Rd, Christmas, FL; registration closes Friday, January 29 @ 11:59 PM ET; 11 100-mile spots available at verification ($325; 50-mile sold out); buckle for 100-mile finishers. |
| S5 | Organizer CalTopo 100-mile course map | https://caltopo.com/m/8U811 | Geometry authority ("100 MILE COURSE MAP" in the handbook): "Forgotten Florida 100 mile" line of 4,431 points measuring 98.3 miles point to point, plus organizer markers for the start, all aid stations (Barr St AS 1; Culpepper AS 2/3; Bronson AS 4/6 NO CREW; Joshua Creek AS 5; Seminole Ranch AS 7/8; AS 9 for 100 only [False Finish]; Fish Hole AS 10/14; Charlie Lake Rd AS 11/12/13), crew points (Seminole Ranch crew access/Wheeler Rd; Powerline Rd), the shuttle pickup/drop-off, the Long Bluff water drop, and the finish. Marker track miles corroborate the matrix within ~0.4 mi. `db/events/forgotten-florida-100.gpx` copies the line's coordinates exactly. The handbook's 50/15/8-mile maps (105JE, 09JLK, 13Q11) are separate and unused. |
| S6 | USGS 3DEP Elevation Point Query Service | https://epqs.nationalmap.gov/v1/json | Spot elevations at the organizer's markers (queried 2026-08-13): 8–42 ft across the fourteen station locations. Used because the organizer publishes no elevation data. |

## Claim-level decisions

- **Name.** "Forgotten Florida 100" for the 100-mile Race within the
  Forgotten Florida weekend.
- **Registration status.** `open` — S4 showed 11 spots at verification.
- **Lottery.** `false` — direct first-come UltraSignup registration.
- **Cutoffs.** Nineteen both-form leave-by cutoffs from the 6:30 AM EST
  start, exactly the matrix column (70 min at mile 4 through 2,040 min at
  98.85); Powerline Road and Long Bluff passes carry none.
- **Station passes.** 24: the matrix's 23 rows plus the Start, using matrix
  miles; the mile-52.6 row is direction Turnaround and the mile-98.85 row is
  the Finish.
- **Crew/drop/pacer booleans.** Copied cell-for-cell from the matrix, which
  already uses pickup semantics for pacers (NO at False Finish, Long Bluff,
  and the Finish; YES from the turnaround through Powerline at 91.65).
- **Aid levels.** FULL AID rows carry the published inventory; WATER ONLY
  rows are water-true/food-false; CREW ACCESS ONLY and SHUTTLE ONLY rows are
  water-false/food-false with their function in the aid note; the Start has
  no published aid (the handbook warns runners not to arrive unfed).
- **Elevation series.** S6 station spot elevations at each pass's matrix
  mile — the flat-course profile approach used for prior records.
- **Follow.** Results on the UltraSignup listing; no live tracking is
  published.

## Stale-source traps

- The handbook is the 2026 edition; its timeline dates (1/30/26–2/1/26) and
  sunrise/sunset table must not be copied as 2027 facts.
- The old UltraSignup listing (did=124228) remains live for 2026 results;
  only did=135495 governs 2027.
- run100s' row says 36 hours; the organizer's handbook and matrix say 34.
  The organizer wins; the run100s figure was not copied.
- The RunSignup-style page at runbumtours.com may lag the UltraSignup
  listing on registration status.

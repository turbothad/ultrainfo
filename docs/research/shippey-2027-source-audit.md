# The Shippey 100 (2027) source audit

Verified on 2026-08-13. This audit uses only organizer material: theshippey.com
pages, the 2026 and 2027 UltraSignup listings, and the organizer's Google My
Maps course map. It records what those sources actually establish; it does not
treat an organizer label as proof that a fact is current or internally
consistent.

## Bottom line

The record is publishable with a source warning. The 2027 UltraSignup listing
supports the January 16–17, 2027 date, the 6:00 AM Saturday start, the
34-hour limit, the loop/leg structure, pacer and drop-bag rules, and open
registration. The organizer's course map supplies the full loop geometry with
embedded altitudes and both station markers. The direction alternates yearly
and the 2027 UltraSignup blurb still carries a 2026 date string, both recorded
below.

Recorded discrepancies and decisions:

1. **Direction.** The course runs clockwise in odd years and counterclockwise
   in even years. The organizer's course line is drawn clockwise (shoelace
   orientation), which is the 2027 direction, so the checked-in GPX and pass
   miles need no reversal; an even-year record would.
2. **Stale date string.** The 2027 listing's cutoff blurb still says "4:00pm
   Sunday January 18th" — the 2026 date. The 2027 race is January 16–17; the
   times carry over, the date does not.
3. **Pass miles.** The organizer publishes leg counts (5 legs of 3.3–5.3
   miles) but no station-mile table. Pass miles are measured along the
   organizer's own line in the 2027 direction: Sverdrup at 5.2, 9.8, and 13.2
   and Emerson mid-loop at 16.4 per nominal 20-mile loop (the line measures
   20.03 miles). This matches the published pattern (Emerson twice and
   Sverdrup three times per 20 miles).
4. **Elevation.** No organizer gain figure exists; run100s' 15,000 ft was not
   copied. The profile and station spot elevations use the altitudes embedded
   in the organizer's course line (512–843 ft range; the line's own values
   total roughly 2,800 ft of gain per loop). `elevation_gain_ft` stays null.
5. **Cutoff modeling.** Hard cutoffs: Sverdrup closes at 2:00 PM Sunday with
   all runners required on leg 4 of the final loop (mile 93.2 pass, 32
   hours), and the finish closes at 4:00 PM Sunday (34 hours). The
   organizer's 1:00 PM leg-3 warning is advisory and lives in notes.
6. **Water potability.** The race is cupless with fluids at both stations; no
   source certifies potability. `potable_water` stays null. No medical
   service is published; `med` stays null.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | The Shippey official site | https://theshippey.com/ | Organizer entry point ("STL's Original 100-mile trail ultra", Beaumont Scout Reservation). |
| S2 | Course details page | https://theshippey.com/course-details-1 | Supports the 5-leg 20-mile loop (legs 3.3–5.3 miles; 1x/2x/3x/5x for 20M/40M/100K/100M), yearly direction switch (clockwise odd years), Emerson twice and Sverdrup three times per 20 miles, ~75% single/double track with 35–40% grade climbs of 0.10–0.30 miles, pink-ribbon course marking, the Sverdrup 2:00 PM Sunday shutdown with the leg-4 requirement, the 1:00 PM leg-3 advisory, the 4:00 PM final cutoff, and private-property status. Its "distance & elevation" content is screenshots without figures. |
| S3 | Runner information page | https://theshippey.com/runner-info/ | Supports the cupless policy, station food ("Standard ultramarathon aid station foods… eggs, bacon, pancakes, burgers, quesadillas, broth"), crew aid only at stations, Emerson indoor camping with downstairs bathrooms/showers, timing-mat placement (outside at Emerson, inside at Sverdrup), Final Lap Racing live per-leg splits, parking (main lot, Cub World for short distances, no crew parking on the road to or at Sverdrup), and the organizer's Google My Maps campus/course map link. |
| S4 | 2027 UltraSignup listing | https://ultrasignup.com/register.aspx?did=135549 (eid=10358) | Current authority: "The Shippey Endurance Runs - January 16 - 17, 2027"; 6480 Beaumont Reservation Drive, High Ridge, MO; 100M start 6:00 AM Saturday with a 34-hour cutoff; all runners on leg 4 of the last loop by 2:00 PM Sunday; drop bags at both stations (max 24x16x13 inches); limited crew inside Sverdrup; pacers must register and are allowed after 40 miles (2 loops) or 5:00 PM for solo 100M/100K runners; Friday packet pickup and required meeting; registration open. Its cutoff blurb retains the 2026 "January 18th" date string. |
| S5 | 2026 UltraSignup listing | https://ultrasignup.com/register.aspx?did=124128 | run100s' discovery link; supports continuity (same venue and structure) and hosts 2026 results. Superseded by S4 for 2027 facts. |
| S6 | Organizer Google My Maps course map (KML export) | https://www.google.com/maps/d/kml?mid=1PYJm-QOer7LvmGH4y4iRRRyYvocHGCI&forcekml=1 | Geometry authority linked from S3: "Shippey 20 mile loop" line of 11,945 points with embedded altitudes (measures 20.03 miles, 32 ft closure, drawn clockwise) plus Start/Finish Aid Station (38.502104, -90.548969), Sverdrup Lodge (38.500676, -90.545268), Emerson Center, and parking markers. `db/events/shippey-100.gpx` copies the line's coordinates exactly; the Emerson waypoint uses the on-course Start/Finish Aid Station marker rather than the building marker (~250 ft off the line). |

## Claim-level decisions

- **Name.** "The Shippey 100" for the 100-mile Race within The Shippey
  Endurance Runs weekend.
- **Registration status.** `open` — S4 shows open registration.
- **Lottery.** `false` — direct first-come UltraSignup registration.
- **Cutoffs.** Both-form from the 6:00 AM CST start: mile 93.2 = 2:00 PM
  Sunday (1,920 min) and mile 100 = 4:00 PM Sunday (2,040 min).
- **Station passes.** 26: Start, then Sverdrup ×3, Emerson mid-loop, and the
  Emerson loop-end pass on each of five loops, the last recorded as the
  Finish.
- **Crew.** `true` at Emerson passes (indoor camping 15 yards from the line)
  and at Sverdrup with the published limits ("limited crew inside"; no crew
  parking on the road to or at the station).
- **Pacers.** Guarantee-based booleans: `true` from the mile-40 loop-end pass
  onward, `false` before with the 5:00 PM Saturday exception in notes. All
  pacers must register.
- **Drop bags.** `true` at both stations' passes (S4: "allowed at both Aid
  Stations", max 24x16x13 inches), `null` at the Start.
- **Medical.** `null` everywhere — no published medical service.
- **Elevation series.** The organizer line's altitudes sampled per nominal
  lap mile and repeated per lap, HURT-style; station spot elevations use the
  line altitude at each station marker.
- **Follow.** Live per-leg splits through Final Lap Racing (S3); results on
  the UltraSignup listing.

## Stale-source traps

- The 2027 listing's cutoff blurb says "January 18th" — a 2026 leftover; the
  2027 dates are January 16–17.
- The course direction reverses in even years: this GPX and mile frame are
  odd-year (2027) specific.
- run100s' row (34h, 15000'/15000') matches the cutoff but its climb figures
  have no organizer counterpart and were not copied.
- The 2026 listing (S5) remains live with near-identical text; only S4
  governs 2027.

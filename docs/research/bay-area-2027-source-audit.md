# Bay Area 100 (2027) source audit

Verified on 2026-08-14. This audit uses only Bay Area 100 material:
the bayarea100.com home, The Race, and Planning pages, the 2026
Athlete Guide (the Drive PDF The Race page links, revised April 27,
2026), the pace-chart sheet, the official course GPX with stations,
and the UltraSignup 2027 listing. It records what those sources
actually establish; it does not treat an organizer label as proof
that a fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The home page
banners the second running on June 12, 2027 and the UltraSignup 2027
listing (did=141132) carries the Saturday 5:00 AM start, the
300-runner cap, the registration timeline (open enrollment from
August 3, closing December 8, Waitlist Wednesday December 9), and two
explicit 2027 deltas. Registration is recorded `open`. The 2026
Athlete Guide's aid table is the governing station structure until
the 2027 guide lands (the listing says mid-August, the home page
early September — the Warbird pattern), and the official GPX carries
the full line with altitudes and all twenty station waypoints.

Recorded discrepancies and decisions:

1. **Frame.** June 12-13, 2027 (a Saturday start), 5:00 AM,
   America/Los_Angeles, 33 hours to the 2:00 PM Sunday finish. The
   guide table and pace chart end at 100.7 miles (the official GPX
   GPS-measures 100.28; run100s' 6/12-13/27 date matches).
2. **Registration.** `open`: the listing's timeline puts open
   enrollment from August 3 (200 spots inside the 300 cap, then the
   waitlist), closing December 8, 2026. Rolling registration with
   entry review, first-come waitlist offers — `lottery` false. A
   qualifying time (a 50-mile within the year) is recommended, not
   required, with an exception request during pre-registration.
3. **Two explicit 2027 deltas in the listing.** "There will be no
   early start this year" (the 2026 guide had a 3:00 AM early start
   by request), and "cutoffs starting at 10:00 am" — matching the
   guide table's first clock and superseding The Race page's stale
   "starting at 11:30 am" print.
4. **The guide table governs miles, flags, and cutoffs.** Four other
   frames print small variants, each documented on its pass: the
   pace chart (25.6/31.4/35.5/68.0/70.8/74.3), the guide's gear-bag
   prose (Wildcat Canyon at 15.95), the guide and planning-page crew
   prose (Bort Meadow's second pass at 82.95 against the table's
   83), and the planning page (Lake Chabot at 60.75, agreeing with
   the table).
5. **Cutoffs.** Thirteen clocks from the guide table, elapsed from
   5:00 AM Saturday: Wildcat Canyon 15.3 at 10:00 AM (300), Steam
   Trains 25.65 at 1:00 PM (480), Valle Vista 35.55 at 4:15 PM
   (675), Rancho Laguna 40.1 at 5:15 PM (735), Las Trampas 46 at
   7:15 PM (855), Chabot Staging 56.6 at 11:30 PM (1,110), Clyde
   Woolridge 64.9 at 2:00 AM (1,260), Bort Meadow 68.05 at 3:00 AM
   (1,320), Space Center 74.35 at 5:20 AM (1,460), Bort Meadow 83 at
   8:15 AM (1,635), Marciel 88 at 10:00 AM (1,740), Marciel 93.2 at
   12:00 PM (1,860), and the finish 100.7 at 2:00 PM (1,980 — the
   33-hour total). No arrival-versus-departure semantics are
   published.
6. **Climb prints disagree.** The home page's "18,000ft of vertical
   gain" governs; the pace chart's segment climbs sum to 18,447 and
   run100s prints 18,263. The chart's summed descents (17,103) are
   the only published loss figures and are recorded for the loss.
7. **Pacers.** The general pacer start is Chabot Staging (56.6),
   with early entry at Las Trampas (46) only for runners arriving
   after 6:00 PM; changes at Lake Chabot Marina, all three Bort
   Meadow passes, and Space Center. One pacer at a time, no muling
   (a disqualification); pacers register free on UltraSignup and
   wear a pacer bib. The table's finish-row pacer mark records
   pacers finishing with their runner. Pacer flags copy the table's
   marks: 46, 56.6, 60.75, 68.05, 74.35, 83, 97.5, and the finish.
8. **Crew.** The table marks eleven crew points: Wildcat Canyon,
   Valle Vista, Rancho Laguna, Las Trampas, Chabot Staging, Lake
   Chabot Marina, Bort Meadow ×3, Space Center, and the finish. Lake
   Chabot's lot closes to new cars at 10:00 PM (street parking and a
   walk after); Bort Meadow's 75 spaces are reserved through the
   race questionnaire; Space Center is the unlimited-parking
   alternative.
9. **Gear bags.** Wildcat Canyon, Rancho Laguna, Las Trampas, Chabot
   Staging, Lake Chabot Marina, Bort Meadow ×3, and the finish —
   14 liters, 10 pounds, bib-marked, dropped Thursday or Friday,
   returned to the finish as stations close.
10. **Medical.** The guide's safety section makes runners the first
    responders; no station-level medical staffing is published —
    `med` stays null everywhere.
11. **Geometry.** The official Bay_Area_100-with-stations.gpx is the
    authority: 6,156 track points with altitudes and twenty station
    waypoints, every waypoint sitting exactly on the line, with
    scaled crossings within about 0.4 mile of every table mile. The
    bundle copies the line and altitudes exactly; the GPX's "Wildcat
    Gate", "Chabot Marina", and "Chabot Observatory" waypoints are
    the table's Wildcat Canyon, Lake Chabot, and Space Center.
12. **Vintage.** The Planning page's race-week schedule and the
    guide are the 2026 running's (June 13, 2026); the structure
    carries over on the same 5:00 AM/33-hour frame, and the 2027
    guide is due mid-August per the listing.
13. **The unnamed second water-only stop.** The guide overview says
    the twenty-three aid-station stops include two water-only stops,
    but its detailed table and the organizer's pace chart independently
    identify only Pinehurst as water only. Those two station-specific
    lists govern over the unnamed overview count: Pinehurst records no
    food, while the guide's Hydration and Nutrition section supports
    food at the other mid-course stations. The same guide disagrees on
    the start of warm food (Las Trampas on page 7, Chabot Staging on
    page 15), so no station pass claims a specific warm-food onset.
14. **Clyde Woolridge crew conflict.** The guide's Section 4 prose on
    page 15 calls Clyde Woolridge crew-accessible, while the governing
    page 11 table leaves Clyde's crew cell blank. The table governs the
    `false` crew flag, consistently with the Planning page's direction
    to use the aid table for crew access.
15. **Marciel Gate at 95.5 is not a published station pass.** The
    guide's page 22 turn-by-turn directions say "Enter Marciel Gate
    Aid (95.5)", but the governing aid table and pace chart omit it,
    and the official GPX has no separate waypoint there. The detailed
    station lists and geometry govern: the print is retained as a route
    instruction between Marciel at 93.2 and Bort Meadow at 97.5, not
    imported as a twenty-sixth pass.

## Source register

All URLs below were opened or downloaded on 2026-08-14.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | bayarea100.com home | https://bayarea100.com/ | The June 12, 2027 second-running banner; 18,000 ft; 33 hours; the 2028 Western States qualifier print; the 2027 guide "early September" note. |
| S2 | The Race page | https://bayarea100.com/the-race/ | The guide, pace-chart, Strava, and GPX links; the two buckles (One Day sub-24, True Grit sub-33); UTMB Index; live tracking and stream; the stale "cutoffs starting at 11:30 am" print (decision 3). |
| S3 | Planning page | https://bayarea100.com/planning/ | Crew rules and restrictions (Lake Chabot 10:00 PM lot, Bort Meadow reservations), mandatory free pacer registration, gear bags, the 2026 race-week schedule (bib pickup at Sports Basement Berkeley, no race-day pickup). |
| S4 | 2026 Athlete Guide (Drive PDF, revised April 27, 2026) | https://drive.google.com/file/d/1RfYYAK0eQzhM27-z04lMd-BwXUxkL1Ir/view | The governing aid table (page 11: miles, cutoff/crew/gear-bag/pacer columns); pacer rules (page 6); gear-bag rules; the Bort Meadow, Lake Chabot, and Space Center diagrams; pink-ribbon markings; the water-only, Clyde crew, Marciel Gate, and warm-food conflicts (decisions 13-15). |
| S5 | Pace chart sheet | https://docs.google.com/spreadsheets/d/1Rs4X2-qInwaNJ9b4iysUnaQmb5JqJVPI | Segment miles, per-segment gain and loss (sums 18,447/17,103), and the cutoff clocks; its mile frame loses to the guide table (decision 4), while its single Pinehurst water-only label corroborates the detailed guide table (decision 13). |
| S6 | Official course GPX with stations | https://bayarea100.com/wp-content/uploads/2026/06/Bay_Area_100-with-stations.gpx | Geometry and elevation authority: 6,156 track points with altitudes (GPS 100.28) and twenty station waypoints on the line. `db/events/bay-area-100.gpx` copies the line exactly. |
| S7 | UltraSignup 2027 listing | https://ultrasignup.com/register.aspx?did=141132 | The June 12, 2027 / 5:00 AM header; the registration timeline, 300 cap, and December 8 close; the qualifying recommendation; the 2027 deltas (no early start; first cutoff 10:00 AM); WSER/UTMB status; deferral rollover to 2028; the 2026 results tab. |

## Claim-level decisions

- **Name.** "Bay Area 100" (S1, S7). The organizer is Scena
  Performance (Skyline 50k, Dick Collins Firetrails).
- **Registration status.** `open` (decision 2). **Lottery.** `false`.
- **Cutoffs.** The thirteen-clock ladder (decision 5);
  `cutoff_hours` 33.
- **Station passes.** 25: the Start at California Memorial Stadium,
  twenty-three mid-race passes over eighteen locations (Inspiration
  Point ×2, Big Bear ×2, Marciel ×2, Bort Meadow ×3), and the Finish
  at Skyline High School (100.7). Twenty unique coordinates; no
  Turnaround rows.
- **Crew.** `true` at the table's eleven marks (decision 8); `false`
  elsewhere including the Start.
- **Pacers.** `true` at the table's eight marks (decision 7);
  `false` elsewhere.
- **Gear bags.** `true` at the table's nine marks (decision 9);
  `false` elsewhere including the Start (bags drop at Basecamp
  before the race).
- **Food.** `false` at Pinehurst, the only water-only stop identified
  by both detailed station lists; `true` at the other mid-course
  passes (decision 13). Start and Finish are not aid-food passes.
- **Medical.** `null` everywhere (decision 10).
- **Elevation.** Gain 18,000 (the home print); loss 17,103 (the
  chart's summed descents); the series is the official GPX's own
  altitudes per nominal mile scaled 100.28 → 100.7.
- **Follow.** Live tracking with a YouTube stream; the tracking link
  posts on bayarea100.com; results on UltraSignup.

## Stale-source traps

- The 2026 Athlete Guide and Planning-page schedule are the 2026
  running's; the 2027 guide is due mid-August 2026 per the listing —
  re-verify the table (especially the two 2027 deltas) when it
  lands.
- The Race page's "cutoffs starting at 11:30 am" is stale against
  the listing's 10:00 AM and the table.
- The pace chart is headed "Saturday, June 13, 2026"; its clocks
  match the guide table's ladder.
- The gear-bag prose's Wildcat 15.95 and crew prose's Bort 82.95 are
  losing prints (decision 4).
- The overview's unnamed second water-only stop, Section 4's Clyde
  crew label, the 95.5 Marciel Gate Aid route instruction, and the two
  warm-food onset prints lose to the detailed station lists (decisions
  13-15).
- run100s' 18,263-foot climb sits between the home page's 18,000 and
  the chart's 18,447 sum; the home print governs.

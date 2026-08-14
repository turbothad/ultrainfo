# Massanutten Mountain Trails 100 (2027) source audit

Verified on 2026-08-14. This audit uses only Virginia Happy Trails
Running Club material: the MMT 100 race page and its Course, Entry,
Schedule, Crew Instructions, and Pacers subpages on new.vhtrc.org, and
the official course GPX the Course page serves. It records what those
sources actually establish; it does not treat an organizer label as
proof that a fact is current or internally consistent.

## Bottom line

The record is publishable with a source warning. The race page is
2027-frame: the race starts Saturday, May 15, 2027 at 5:00 AM from
Caroline Furnace Lutheran Camp, Fort Valley, VA, with a 36-hour
cutoff, and entry ($250, cap 250, waitlist on filling) opens October
31, 2026. The Course page carries the complete table — fifteen
stations with splits, cumulative miles, crew and drop-bag columns,
cutoff clocks, footnote icons, and a Google-Maps pin per row — plus
the official GPX (2,496 track points with elevations, 17 named
waypoints) and the 100.6-mile / 18,500-foot frame.

Recorded discrepancies and decisions:

1. **run100s is stale on climb.** Its 19,000-foot figure has no
   counterpart: the Course facts say 18,500 feet of total
   ascent/descent (the home page says "more than 18,000").
2. **The finish cutoff prints 3:00 pm on the course table — an
   impossible clock.** It would precede Gap Creek II's 3:55 pm at
   mile 96.8 and contradict the same page's 36-hour cutoff. The Crew
   Instructions table prints the finish at 5:00 pm, which is exactly
   36 hours from the 5:00 AM start and pace-consistent with the
   ladder. 5:00 PM / 2,160 minutes governs with a pass-specific note
   (the Sugar Creek pattern).
3. **The crews table returns the favor with its own misprint.** It
   prints Picnic Area at 12:50 am, which would precede Camp
   Roosevelt's 2:50 am at mile 63.9; the course table's 12:50 pm
   (31h50m, ladder-consistent) governs. Each table corrects the
   other's single AM/PM typo.
4. **Crew count: 8, 9, or 10.** The Course facts box says "8 with
   crew access"; the aid-station prose says "9 of which are
   crew-accessible"; the course table checks 8 mid-race rows but the
   Crew Instructions page lists nine mid-race stations plus the
   finish — adding Gap Creek II (96.8), the same physical station as
   crew-accessible Gap Creek (69.6). The Crew Instructions list
   governs: crew true at nine mid stations plus the start/finish
   camp.
5. **Cutoff footnotes.** Woodstock Tower (11:30 am) and Powells Fort
   (1:15 pm) carry the clock icon: "Cutoff is recommendation only
   and not enforced" — recorded with pass-specific notes. Moreland
   Gap is fluids-only (food false). Woodstock Tower, Powells Fort,
   Indian Grave, and Bird Knob are remote stations where runners may
   not withdraw except in serious medical condition.
6. **Pacer miles.** The Pacers page says pacers join "at the Camp
   Roosevelt aid station (63.5 miles)" against the table's 63.9; the
   table governs. Pacers may join at Camp Roosevelt or any
   crew-access station beyond, plus Habron Gap (54.0) after 6:00 PM
   Saturday (recorded true with the condition noted); runners 62 or
   older may take a pacer from Elizabeth Furnace (33.3; rule
   summary).
7. **Schedule page frame.** The Schedule page still carries the 2026
   weekend ("Friday, May 15 / Saturday, May 16" with the 3:00 AM
   30th-anniversary over-60 start); the race page's Sat May 15, 2027
   date governs, and the schedule's structure (Friday check-in and
   drop-bag collection to 8:00 PM, 5:00 AM start) is the standing
   pattern.
8. **Frame.** The course table's cumulative column ends at 100.6
   (governs); the official GPX GPS-measures 97.82 miles.
9. **Medical.** A race Medical Emergency Plan covers directions from
   each station; no station-level medical column exists. `med` stays
   null everywhere.
10. **Elevation.** The official GPX carries elevations (573-2,808 ft
    at mile sampling against the page's stated 540 low / 2,835
    high); its 17 waypoints carry no elevation values, so the bundle
    adds line-derived elevations to the copied waypoints.

## Source register

All URLs below were opened or downloaded on 2026-08-14.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | MMT 100 race page | https://new.vhtrc.org/races/mmt | 2027 frame: "Race starts Sat May 15, 2027 at 5:00 am"; entry opens Sat Oct 31, 2026 at 8:00 am; Caroline Furnace Lutheran Camp, Fort Valley, VA (38.7401,-78.511173); 36-hour cutoff; more than 18,000 feet; the Participants' Guide and Medical Emergency Plan links. |
| S2 | Course page | https://new.vhtrc.org/races/mmt/course | The fifteen-station table (splits, cumulative, crew, drop bags, cutoffs, footnote icons, map pins); 100.6 miles; 18,500 feet; 36 hours; the figure-8 description; the official GPX download; the 3:00 pm finish misprint (decision 2); high/low points; course markings. |
| S3 | Official course GPX | https://new.vhtrc.org/media/pages/races/mmt/course/c9a263be78-1779210606/vhtrc-mmt-100.gpx | Geometry and elevation authority: 2,496 track points with elevations (97.82 GPS miles) and 17 station waypoints named with chart miles. `db/events/massanutten-100.gpx` copies points and waypoints exactly, adding line-derived waypoint elevations (decision 10). |
| S4 | Entry page | https://new.vhtrc.org/races/mmt/entry | $250; 250-person entry limit; opens October 31, 2026 8:00 am via UltraSignup; refund schedule ($25 withheld through March 1, $100 March 2-April 16, none after; entry closes April 26 and the waitlist is deleted); waitlist on filling. |
| S5 | Crew Instructions page | https://new.vhtrc.org/races/mmt/info/crews | The crew-access station list (nine mid stations plus the finish camp) with the 5:00 pm finish print (decision 2) and its own 12:50 am Picnic Area misprint (decision 3); crew conduct rules. |
| S6 | Pacers page | https://new.vhtrc.org/races/mmt/info/pacers | Pacers from Camp Roosevelt (printed 63.5) or any crew-access station beyond; Habron Gap after 6:00 PM Saturday; one at a time; runner leads; no muling; the 62-plus Elizabeth Furnace exception. |
| S7 | Schedule page | https://new.vhtrc.org/races/mmt/info/schedule | 2026-frame weekend structure: Friday check-in/packet pickup 2:00-8:00 pm with drop-bag collection, 4:00 pm briefing, Saturday 4:00-4:45 am check-in, 5:00 am start, and the 3:00 am over-60 start. |

## Claim-level decisions

- **Name.** "Massanutten Mountain Trails 100" — MMT 100 (house full
  form; the club renders both).
- **Registration status.** `not_open` — opens October 31, 2026 (S4).
  **Lottery.** `false` — first-come entry with a waitlist.
- **Cutoffs.** Fifteen clocks: thirteen enforced station cutoffs,
  two recommendation-only (decision 5), and the finish at 5:00 PM
  Sunday (decision 2). `cutoff_hours` 36.
- **Station passes.** 17: the Start, fifteen station rows, and the
  Finish at Caroline Furnace. Gap Creek I and II share one
  coordinate, as do the Start and Finish — fifteen unique locations.
  No Turnaround rows on the figure-8.
- **Crew.** `true` at Edinburg Gap, Elizabeth Furnace, Shawl Gap,
  Habron Gap, Camp Roosevelt, Gap Creek I, Visitor Center, Picnic
  Area, Gap Creek II (decision 4), and the Start/Finish camp;
  `false` elsewhere.
- **Pacers.** `true` at Habron Gap (after 6:00 PM Saturday), Camp
  Roosevelt, Gap Creek I, Visitor Center, Picnic Area, and Gap Creek
  II; `false` elsewhere with the 62-plus exception in the rule
  summary.
- **Drop bags.** `true` at the ten checked rows: Edinburg Gap,
  Woodstock Tower, Elizabeth Furnace, Shawl Gap, Habron Gap, Camp
  Roosevelt, Gap Creek I, Visitor Center, Picnic Area, Gap Creek II;
  `null` at the Start; `false` elsewhere.
- **Medical.** `null` everywhere (decision 9).
- **Elevation series.** The official GPX's elevations per nominal
  chart mile (573-2,808 ft); station spots at each pass's chart
  mile.
- **Follow.** No live tracking link is published; results post on
  the club's results page.

## Stale-source traps

- The Schedule page and sponsor list are 2026-frame; re-check for
  the 2027 schedule.
- The Participants' Guide link serves the prior year's guide until
  updated.
- The course table's 3:00 pm finish and the crews table's 12:50 am
  Picnic Area misprints (decisions 2-3); re-check whether the club
  fixes either surface.
- The Pacers page's Camp Roosevelt mile (63.5) lags the table's
  63.9.
- run100s' 19,000-foot climb is superseded (18,500).

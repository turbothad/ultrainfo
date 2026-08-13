# Jackpot 100 (2027) source audit

Verified on 2026-08-13. This audit uses only Aravaipa Running material: the
official race page, the organizer's CalTopo Long Course map, the USATF course
certifications the page links, and the 2027 UltraSignup listing — plus a USGS
3DEP spot elevation. It records what those sources actually establish; it
does not treat an organizer label as proof that a fact is current or
internally consistent.

## Bottom line

The record is publishable with a source warning. The official page supports
the February 19–21, 2027 weekend, both 100-mile variants, start times,
cutoffs, the 24/7 Main Strip Aid Station, pacer and crew rules, and open
registration closing February 14. This record covers the **Long Course 100
Mile** (Saturday 8:00 AM, one short opening loop then 43 certified
2.3094-mile loops for the organizer's 100.489-mile total, 30-hour cutoff); the separate Friday Short Course 100 (85 × 1.17078
miles, 48-hour window, USATF 100 Mile Championship host) is recorded in
prose.

Recorded discrepancies and decisions:

1. **Two 100-mile races.** run100s' single "Jackpot" row conflates the
   Friday Short Course 100 (48-hour window) and the Saturday Long Course 100
   (30 hours; 32 with the 6:00 AM early start — run100s' 32 matches the
   early-start figure). The Long Course is the general-entry race and
   governs this record.
2. **Loop order and length.** The page says Saturday 100-mile runners "run
   1 short loop and then 43 full regular course loops for a total distance
   of 100.489 miles"; pass miles therefore open with the short loop (first
   pass at 1.18) and step by the certified 2.3094 miles (NV23003MWC) to the
   100.49 finish. The organizer's drawn CalTopo line measures 2.35.
3. **Pacers.** The Long Course allowance is sunset to sunrise — time-based —
   and Championship (Short Course) competitors may not use pacers, so no
   pass records guaranteed pickup; the rule lives in notes, consistent with
   the guarantee-based boolean convention.
4. **Elevation.** The organizer publishes 72 ft of gain per loop and a
   1,912 ft max elevation but no whole-race total, so gain/loss stay null
   with the per-loop figure in source notes; the profile is the USGS 3DEP
   value (1,903 ft) at the start/finish marker, held constant.
5. **Water and medical.** The 24/7 station serves food and drink with
   vegan, vegetarian, and gluten-free options; nothing certifies
   potability. First aid kits and an EMT are onsite for the whole race with
   a medical tent at the start/finish, so `med` is true at every pass.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Jackpot Ultras official race page | https://aravaiparunning.com/jackpot/ | Supports February 19–21, 2027; Cornerstone Park, 1600 Wigwam Pkwy, Henderson, NV; start times (Short Course 100 and 48-hour Friday 8:00 AM; Long Course 100 and 100K Saturday 8:00 AM with 6:00 AM early start; 50 Mile Saturday 8:30); cutoffs (Short Course 48 hours; Long Course 30 hours, 32 with early start; overall close 2:00 PM Sunday); loop specs (Short 1.17078 miles × 85; Long: one short loop then 43 × 2.3094 miles totaling 100.489); the 72 ft/loop gain and 1,912 ft max; first aid kits, an onsite EMT, and the medical tent; the 24/7 Main Strip Aid Station with dietary options; pacer rules (Long Course sunset-to-sunrise; prohibited for Championship competitors); crew guidance; registration closing February 14, 2027 with race-day entry. |
| S2 | Organizer CalTopo Long Course map | https://caltopo.com/m/T3R0R9M | Geometry authority: 225-point "Long Course" line (4 ft closure, drawn length 2.35 miles), the Start / Finish marker (36.036930, -115.054300), crew areas, and camping. `db/events/jackpot-100.gpx` copies the line's coordinates exactly; the waypoint is the organizer's marker. |
| S3 | USATF certification, Long Course | https://www.aravaiparunning.com/avr/wp-content/uploads/2023/03/NV23003MWC-Jackpot-Ultras-Long-Course.pdf | Certifies the 2.3094-mile loop (cert NV23003MWC) that governs pass miles. |
| S4 | USATF certification, Short Course | https://www.aravaiparunning.com/avr/wp-content/uploads/2023/03/NV23001JOE-Jackpot-Ultras-PREVERIFIED.pdf | Certifies the 1.17078-mile Short Course loop (NV23001JOE), cited for the prose note only. |
| S5 | 2027 UltraSignup listing | https://ultrasignup.com/register.aspx?did=138131 | Registration surface; `registration_url` and (post-race) `results_url` point here. |
| S6 | Aravaipa live results | https://live.aravaiparunning.com/#/jackpot_ultras-2027?raceId=301959 | 2027 live-results surface; supports the follow story. |
| S7 | USGS 3DEP Elevation Point Query Service | https://epqs.nationalmap.gov/v1/json | Spot elevation at the start/finish marker (queried 2026-08-13): 1,903 ft. |

## Claim-level decisions

- **Name.** "Jackpot 100" for the Long Course 100-mile Race within the
  Jackpot Ultras festival (which also runs 48/24/12/6-hour and shorter
  races).
- **Registration status.** `open` — S1/S5 at verification.
- **Lottery.** `false` — direct first-come registration.
- **Cutoffs.** One published cutoff: 100 miles by 2:00 PM Sunday (1,800
  minutes from the 8:00 AM Saturday start), both forms on the Finish pass;
  the early-start variant is prose.
- **Station passes.** 45: the Start, the short-loop crossing at 1.18, 42
  certified-loop crossings (3.49 through 98.18), and the Finish at 100.49.
- **Crew.** `true` at every pass — crew areas line the loop.
- **Pacers.** `false` at every pass (time-based allowance; see decision 3).
- **Drop bags.** `null` everywhere — no published service; runners pass
  their own crew area every loop.
- **Medical.** `true` everywhere — the page publishes first aid kits, an
  onsite EMT, and a medical tent at the start/finish venue every loop
  crosses.
- **Elevation series.** Constant 1,903 ft (S7) — the flat-loop degenerate
  case of the spot-elevation profile convention.
- **Follow.** Aravaipa live results (S6); official results on UltraSignup
  (S5).

## Stale-source traps

- run100s' 32-hour cutoff is the early-start figure and its row mixes the
  two 100-mile variants; the race page governs.
- The USATF certification PDFs are dated 2023; certifications are
  long-lived, but re-check the certs if the organizer redraws either loop.
- The live-results URL is year-stamped for 2027.

# Bighorn 100 (2026) source audit

Verified on 2026-08-13. This audit treats the current Ultrainfo Bighorn record as
untrusted and uses only organizer-owned Bighorn Trail Run material, the event's
official ITS YOUR RACE registration/timing pages, and direct assets linked from
those pages. It records what those sources actually establish; it does not treat
an organizer label as proof that a fact is current or internally consistent.

## Bottom line

The current Bighorn record must not be described as fully verified. The official
sources support the course shape, most station miles/elevations/cutoffs, most aid
descriptions, the three drop-bag locations, crew access, 2026 schedule, and
official results. They do **not** support the current `potable water` assertions,
presenting the 35-hour limit as undisputed, the registration-status narrative, or
the current per-pass pacer interpretation. Several sources contradict one another.

Highest-priority corrections:

1. Keep the operational limit at 35 hours but mark it disputed. The year-specific
   organizer schedule's 9:00 AM Friday start and 8:00 PM Saturday finish cutoff
   span 35 clock hours, and the organizer's course-description PDF says 35 hours;
   the official timing/registration page instead says 34 hours.
2. Set potable-water availability to `unknown` at every pass. Official sources
   say `water`, `fresh mountain spring water`, or `water filtered by hand`; none
   certify potability.
3. Separate `pacer pickup/transfer point` from `pacer may accompany runner
   through this pass`. The current boolean and notes conflate those concepts.
4. Preserve Dry Fork outbound as no scheduled medical check, but mark the claim
   with a source warning: pass-specific material lists medical only inbound,
   while the location-level Medical page says evaluations occur `at Dry Fork`
   without naming a direction. The finish has no specific medical-check evidence.
5. Cite direct assets rather than the generic `/100-mile` page, and stop calling
   the undated aid quick-reference a `2026` chart.
6. Remove or qualify `2026 filled from the wait list`, the `lottery: false`
   assertion, and the synthetic 183.9-mile/9.3-hour crew route until claim-level
   evidence is attached.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Bighorn 100 page | https://bighorntrailrun.com/100-mile | Current organizer page with narrative station details and links to S2/S3. |
| S2 | Bighorn Mountain Trail 100 course description PDF | https://img1.wsimg.com/blobby/go/07161f14-d61e-453c-a3cc-f57e0150d044/Bighorn100_Course_Description-0cce83e.pdf | Undated PDF; server `Last-Modified` 2025-08-28. Supports course totals and station narrative, but not a 2026 label. |
| S3 | Bighorn 100 Aid Station Quick Reference PDF | https://img1.wsimg.com/blobby/go/07161f14-d61e-453c-a3cc-f57e0150d044/downloads/30d8acf5-26bd-40cf-b6a4-a5ffefb537e2/Bighorn%20100%20Aid%20Station%20Chart.pdf?ver=1782760210683 | Undated one-page chart; server `Last-Modified` 2025-09-02. Supports pass miles/elevations/cutoffs/aid level/crew access, not detailed food, water, drop-bag, or medical claims. |
| S4 | Maps & Profiles page | https://bighorntrailrun.com/maps-%26-profiles-4 | Current organizer course-download surface; it links S5. A separate `/downloads` page still exposes an older, conflicting GPX ZIP and is a stale-source trap. |
| S5 | Bighorn 100 GPX ZIP | https://img1.wsimg.com/blobby/go/07161f14-d61e-453c-a3cc-f57e0150d044/downloads/7a86f4c4-57c7-4031-85fa-7894b7441563/Bighorn_100.zip?ver=1782760216101 | Server `Last-Modified` 2025-04-17. The contained GPX SHA-256 is `23b61f90e7e4931e55cadb9dbc2f781043c0290638a83958b1331a91e0ea2cd5`, exactly matching `db/events/bighorn-100.gpx`. Use it for geometry/waypoint identity only: its embedded start/track description, statistics, and station operations are dated/stale 2016 material and conflict with current sources. |
| S6 | 2026 race-weekend schedule PDF | https://img1.wsimg.com/blobby/go/07161f14-d61e-453c-a3cc-f57e0150d044/2026%20BHTR%20SCHEDULE-fb5032e.pdf | Explicitly 2026; supports June 18-21 schedule, 100M start at 9:00 AM Friday June 19, and finish cutoff at 8:00 PM Saturday June 20. |
| S7 | Official ITS YOUR RACE event page | https://bhtr.itsyourrace.com/event.aspx?id=384 | Supports event dates, 9:00 AM start, Dayton/Scott Park event location, course surface totals, and a **34-hour** limit. |
| S8 | Official ITS YOUR RACE registration flow | https://bhtr.itsyourrace.com/register/default.aspx | Supports registration opening dates and event weekend. At verification time it showed the 18M as sold out, not the 100M. |
| S9 | Official ITS YOUR RACE purchase page | https://bhtr.itsyourrace.com/register/eventpurchase.aspx | Supports the 100M price and fee while still offering 100M quantity selection at verification time; it does not support `filled from the wait list`. |
| S10 | Official ITS YOUR RACE 2026 results | https://bhtr.itsyourrace.com/Results.aspx?id=384 | Results status was `Official`: 232 participants, 174 finishers; event date Friday June 19, 2026. |
| S11 | Bighorn crew information | https://bighorntrailrun.com/general-crew-information-1 | Supports crew points, road restrictions, parking/walking constraints, and approximate point-to-point travel times. Its linked printable direction PDF is https://img1.wsimg.com/blobby/go/07161f14-d61e-453c-a3cc-f57e0150d044/downloads/1d1cfu236_586761.pdf?ver=1782760220604. |
| S12 | Bighorn pacer information | https://bighorntrailrun.com/general-pacer-information-1 | Supports pacer rules and named pickup/transfer locations; it calls Jaws `mile 52`, conflicting with the station chart/course page's mile 48. |
| S13 | Bighorn course rules | https://bighorntrailrun.com/course-rules | Supports cutoff enforcement, crew exceptions, and pacer accompaniment from Sally's outbound to the finish. It uses a 100-yard station crew radius, conflicting with the race-announcements page's 100-foot language. |
| S14 | Bighorn drop-bag page | https://bighorntrailrun.com/drop-bags-1 | Supports three recommended 100M drop-bag locations: Dry Fork, Footbridge, and Jaws, plus the combined out/in bag guidance. Its linked direct PDF is https://img1.wsimg.com/blobby/go/07161f14-d61e-453c-a3cc-f57e0150d044/downloads/1c7mmjgt2_903907.pdf?ver=1782760222081. |
| S15 | Bighorn medical page | https://bighorntrailrun.com/medical-1 | Says verbal medical evaluations occur for every 100M runner `at Dry Fork`, Sally's Footbridge, and Jaws, but does not identify a Dry Fork pass/direction. |
| S16 | 2026 race announcements | https://bighorntrailrun.com/race-announcements | Explicit 2026 operational facts: Tailwind hydration, no gels at aid stations, cupless rules, one crew member in the tent at Dry Fork/Sally's/Jaws, and Tongue Canyon Road restrictions. The page also contains placeholder/incomplete content, so only explicit dated statements should be used. |
| S17 | Bighorn results and timing page | https://bighorntrailrun.com/results-%26-timing-1 | Links 2026 results to S10 and notes that live splits depend on connectivity; the site's historic winner list is incomplete. |
| S18 | Bighorn SPOT tracking page | https://bighorntrailrun.com/tracking-device | Says 100M runner tracking by Track Leaders is provided `this year`; it does not expose a stable public live-tracking URL for the archived race record. |

## Claim audit: race, course, registration, and follow

| Current claim | Finding | Evidence | Correction |
|---|---|---|---|
| 2026 race weekend; 100M starts Friday June 19 at 9:00 AM | Supported. | S6, S7, S10. | Keep. Use S6 as the schedule citation. |
| Race `end_date` is Saturday June 20 | Supported for the 100M cutoff/finish window, although the overall event continues Sunday June 21. | S6; S7 lists June 19-21. | Keep for the 100M Race; do not describe it as the whole event's end date. |
| Start venue `Tongue Canyon Road, Dayton` | Partially supported. S6 calls it `Tonge River Canyon Campground`; S1 calls it `Start - Tongue Canyon Road`; S11 locates it on Tongue Canyon Road. | S1, S6, S11. | Prefer `Tongue Canyon Road start near Dayton` and retain the official map coordinates. Do not use Scott Park as the 100M start merely because S7 lists it as event location. |
| Finish at Scott Park, Dayton | Supported. | S2, S6, S7. | Keep; `Scott Bicentennial Park` is the fullest name. |
| 100 miles, out-and-back, 20,500 ft ascent, 20,750 ft descent; 76 miles single-track, 16 jeep/two-track, 8 gravel | Supported by S2 and repeated by S7. | S2, S7. | Keep, but cite S2 directly. |
| 35-hour cutoff | Contradicted. S2 says 35 hours, S7 says 34 hours, while S6's 9:00 AM Friday start and 8:00 PM Saturday cutoff span 35 hours. | S2, S6, S7. | Retain 35 hours because the explicit 2026 organizer schedule and its clock arithmetic are the most specific operational evidence, but mark the value disputed and disclose S7's 34-hour statement. |
| Final cutoff `8:00 PM June 20, 2026` | Supported. | S3, S6. | Keep as a clock cutoff. |
| Time zone `America/Denver` | Reasonable and consistent with official `MDT` registration language, but not encoded as an IANA zone in the sources. | S7/S8 use Mountain/MDT. | Keep as normalization, label it derived rather than quoted. |
| `registration_status: closed` because `2026 filled from the wait list` | Unsupported and contradicted by current official registration pages. S8 singled out only the 18M as sold out; S9 still offered 100M quantity selection. The race has already occurred, so registration is operationally closed, but not for the claimed reason. | S8, S9, S10. | Replace with `past/closed after event` if the product supports it; delete `filled from the wait list`. |
| `lottery: false` | Not established by the reviewed sources. Regular registration opening dates do not prove absence of a lottery or other allocation step. | S7, S8. | Set unknown/unpublished unless a first-party policy explicitly says no lottery. |
| Registration URL `/event.aspx?id=384` | Event page is valid, but it is not the registration transaction itself. | S7-S9. | Label S7 `official event/registration hub`; use S8 for registration status and S9 for price/availability evidence. |
| Results link points to Bighorn timing page | Supported but indirect. | S17 links to S10. | Prefer S10 as the direct 2026 results URL and retain S17 as context. |
| Live tracking unavailable | Incomplete. Bighorn says 100M SPOT tracking by Track Leaders was provided this year, but no durable archived live link was exposed. | S18. | State `SPOT tracking announced; public link not preserved/verified`, not simply `No tracking link published`. |
| GPX is official/current course evidence | Provenance is supported: repo GPX exactly matches S5. Currency is not: embedded 2016 timestamps/statistics remain in the file. | S4, S5; SHA above. | Keep for course geometry with `organizer-linked file, downloaded 2026-08-13`; explicitly exclude embedded 2016 time, 99.3-mile, 16,378-ft climb, and 16,555-ft descent metadata from 2026 claims. |
| Crew route is 183.9 mi / 556 min through Start, Dry Fork, Sally's, Jaws, Finish | Not a first-party claim. S11 gives approximate leg times/distances, but the JSON geometry and aggregate appear routed/generated; Footbridge is difficult and includes a walk/shuttle. | S11 versus `db/events/bighorn-100.crew_route.json`. | Label as an Ultrainfo routing estimate with provenance/date and warning, not a verified race fact. Do not reduce it to the unsupported slogan `Start to Dry Fork to Sally's to Jaws to Finish`. |

## Station-pass evidence matrix

This matrix distinguishes what can be asserted from what remains unknown. `Water
listed` means S1 names water; it does **not** mean potability was certified. S2's
`filtered by hand` and `fresh mountain spring water` descriptions likewise are not
potability certifications. S5 is not used for operational aid/access facts because
its embedded 2016 data conflicts with S1/S3/S15. `Next marker` is arithmetic from
S3's marker miles and spot elevations: it is not measured trail distance, segment
gain/loss, or a route survey. All sources were checked 2026-08-13; only
S6/S10/S16 are explicitly 2026.

| Pass | Mile / elev / cutoff | Current aid evidence | Water / potability | Crew / bag / medical | Pacer | Next marker (distance, net elev) | Correction or caveat |
|---|---|---|---|---|---|---|---|
| Start - Tongue Canyon Road | 0 / 4,275 / 9:00 AM start | Moderate (S1/S3) | Not stated / unknown | Yes / not listed / not listed | No standard pickup; pre-approved exceptions may start paced (S12) | Tongue +1.25 mi, -35 ft | Start time is not a cutoff; `food:true` is an inference from `Moderate`, not an item-level claim. |
| Tongue River Trailhead out | 1.25 / 4,240 / none | Minimal, water only (S1/S3) | Water listed / **not certified potable** | No / not listed / not listed | Before general pacing starts | Lower +2.25 mi, +785 ft | S5's stale 10:25 AM outbound cutoff conflicts with S3's no cutoff; use S3. |
| Lower Sheep Creek out | 3.5 / 5,025 / none | Minimal; water, sports drink, trail mix, pretzels, bars, candy, nuts (S1/S3) | Water listed / **not certified potable** | No / not listed / not listed | Before general pacing starts | Upper +5 mi, +2,425 ft | Keep current item list from S1. |
| Upper Sheep Creek out | 8.5 / 7,450 / none | Minimal; water, sports drink, trail snacks, fruit (S1/S3) | Water listed / **not certified potable** | No / not listed / not listed | Before general pacing starts | Dry Fork +5 mi, +30 ft | Keep current item list from S1. |
| Dry Fork Ridge out | 13.5 / 7,480 / 3:00 PM | Major; sandwiches, soup, fruit, chips, soda, cookies, candy, jerky (S1/S3) | Water not stated / unknown | Yes / yes / no scheduled check (**warning**) | No standard pickup until Sally's out | Kern's +6 mi, -880 ft | S1 omits medical outbound and explicitly names it inbound; S5 says `Medical Check (Inbound only)`. S15 is location-level and directionless. Keep `med:false`, display `Not listed outbound — source warning`. S1 says a 1/4-mile parking walk; S11 says a short walk. |
| Kern's Cow Camp out | 19.5 / 6,600 / none | Moderate; drinks, snacks, fruit, bacon (S1/S3) | Water not stated / unknown | No / not listed / not listed | Before general pacing starts | Bear +7 mi, +200 ft | Display `Kern's`; `Kearns` is only the S5 waypoint spelling/match key. |
| Bear Camp out | 26.5 / 6,800 / none | Minimal; drinks, pretzels, bars, candy (S1/S3) | Water not stated / unknown | No, no vehicle / not listed / not listed | Before general pacing starts | Sally's +3.5 mi, -2,210 ft | Do not expand `drinks` to water. |
| Sally's Footbridge out | 30 / 4,590 / 8:30 PM | Major; hot food, sandwiches, fruit, soda, cookies, candy, jerky (S1/S3) | Water not stated / unknown | Yes / yes / yes | Pickup/transfer point; general pacing begins (S12/S13) | Cathedral +3.5 mi, +490 ft | S1 says parking 1/2 mile away; detailed S11 says a 3/4-mile shuttle/walk. Prefer the conservative figure and expose the conflict. |
| Cathedral Rock out | 33.5 / 5,080 / none | Minimal; drinks, soup, pretzels, bars, candy, nuts (S1/S3) | S2 says filtered water / **not certified potable** | No / not listed / not listed | Pacer may accompany; not a pickup point | Spring +6.5 mi, +1,840 ft | Current `No pacers` is misleading if read as accompaniment. |
| Spring Marsh out | 40 / 6,920 / none | Moderate; drinks, trail mix, pretzels, candy (S1/S3) | S2 says spring water / **not certified potable** | No / not listed / not listed | Pacer may accompany; not a pickup point | Jaws +8 mi, +1,880 ft | Current `No pacers` is misleading. |
| Jaws turnaround | **48** / 8,800 / 4:00 AM | Major; hot food, sandwiches, soup, chips, soda, fruit, cookies, jerky (S1/S3) | Water not stated / unknown | Yes / yes / yes | Pickup/transfer point | Spring +8 mi, -1,880 ft | S12 says mile 52, contradicting S1/S2/S3; use mile 48 and document the error. |
| Spring Marsh in | 56 / 6,920 / none | Moderate; `same great snacks` (S1/S3) | Water not stated / unknown | No / not listed / not listed | Pacer may accompany; not a pickup point | Cathedral +6.5 mi, -1,840 ft | Do not copy S5's old inventory into a current row. |
| Cathedral Rock in | 62.5 / 5,080 / none | Minimal; drinks, soup, pretzels, bars, candy, nuts (S1/S3) | Water not stated / unknown | No / not listed / not listed | Pacer may accompany; not a pickup point | Sally's +3.5 mi, -490 ft | Current `No pacers` is misleading. |
| Sally's Footbridge in | 66 / 4,590 / 10:00 AM | Major; medical and drop bags, no current item list (S1/S3) | Water not stated / unknown | Yes / yes / yes | Pickup/transfer point | Bear +3.5 mi, +2,210 ft | Use S11's parking/walk warning. |
| Bear Camp in | 69.5 / 6,800 / none | Minimal; drinks, pretzels, bars, candy (S1/S3) | Water not stated / unknown | No, no vehicle / not listed / not listed | Pacer may accompany; not a pickup point | Kern's +7 mi, -200 ft | Current `No pacers` is misleading. |
| Kern's Cow Camp in | 76.5 / 6,600 / none | Moderate; snacks, fruit, bacon (S1/S3) | Water not stated / unknown | No / not listed / not listed | Pacer may accompany; not a pickup point | Dry Fork +6 mi, +880 ft | Current `No pacers` is misleading. |
| Dry Fork Ridge in | 82.5 / 7,480 / 3:00 PM | Major; medical and drop bags, no current item list (S1/S3) | Water not stated / unknown | Yes / yes / yes | Pickup/transfer point | Upper +5 mi, -30 ft | Keep parking restrictions from S11. |
| Upper Sheep Creek in | 87.5 / 7,450 / 4:30 PM | Moderate; fruit, soda, trail snacks (S1/S3) | Water not stated / unknown | No / not listed / not listed | Pacer may accompany; not a pickup point | Lower +5 mi, -2,425 ft | Current `No pacers` is misleading. |
| Lower Sheep Creek in | 92.5 / 5,025 / none | Minimal; drinks, snacks (S1/S3) | Water not stated / unknown | No / not listed / not listed | Pacer may accompany; not a pickup point | Tongue +2.3 mi, -785 ft | Current `No pacers` is misleading. |
| Tongue River Trailhead in | 94.8 (S1/S3) or 94.75 (S11/S13) / 4,240 / 6:45 PM | Moderate; items unspecified (S1/S3) | Water not stated / unknown | Yes, foot/bike only / not listed / not listed | Pacer may accompany; crew runner may accompany on foot/bike (S12/S13) | Home +3.2 mi, -200 ft | Current `pacer:false`/`No pacers` is misleading; retain 94.8 but record the 94.75 variance. |
| Home Stretch in | 98 / 4,040 / none | Minimal; snacks and drinks (S1/S3); S2 mentions otter pops | Water not stated / unknown | Yes, foot/bike only / not listed / not listed | Pacer or crew runner may accompany | Finish +2 mi, -70 ft | Current `pacer:false`/`No pacers` is misleading. |
| Scott Park finish | 100 / 3,970 / 8:00 PM | Finish food/celebration (S2/S6), no detailed aid inventory | Not stated / unknown | Yes / no course bag / **medical unsupported** | Pacer may remain with runner through finish | Course complete | `food:true` is supportable at this granularity; current `med:true` is not. |

## Cross-source contradictions and interpretation rules

- **34 versus 35 hours:** S7 says 34; S2 says 35; S6 clock times imply 35.
  Preserve the clock facts and expose the contradiction instead of selecting a
  silent winner.
- **Jaws mile 48 versus 52:** station/course sources S1/S2/S3/S5 say 48; pacer
  page S12 says 52. Use 48 for course position, while noting the pacer-page error.
- **Dry Fork medical:** S1 omits a medical check outbound and explicitly lists it
  inbound; S5 also says inbound only. S15 says evaluations occur `at Dry Fork`
  but does not identify a pass. The safest pass-level value is outbound false/not
  listed with warning metadata, and inbound true. Do not silently generalize the
  location-level statement to both passes.
- **Crew radius:** S13 says 100 yards; S16 says runners may be crewed within 100
  feet and only one crew member may enter the tent at Dry Fork/Sally's/Jaws.
  Apply the stricter 100-foot 2026 announcement operationally and record the rules
  page conflict.
- **Tongue Canyon vehicle timing:** S13 says vehicles are prohibited from the
  trailhead to the finish once the 100M starts Friday morning; S16 says race
  vehicle travel is prohibited after noon Friday June 19 and completely Saturday
  June 20. Continue to show no vehicle access for the inbound Tongue/Home passes,
  but do not publish one start time for the restriction without the conflict.
- **Pacer meaning:** `No Crew/Pacers` in S1/S5 at intermediate aid stations is
  best read as no crew access and no pacer pickup/access at that station. It cannot
  mean a runner's existing pacer is prohibited from passing through, because S13
  allows a pacer from Sally's outbound to the finish and requires pacers to check
  in/out with runners. Model `pacer pickup/access` separately from `pacer on course`.
- **Water meaning:** `water`, `spring water`, and `filtered by hand` are not
  first-party certifications of potable water. The requested UI field should stay
  unknown unless an attributable source explicitly answers potability.
- **Version labeling:** S2/S3/S5 are currently linked by the organizer, but none is
  explicitly 2026; S5 contains 2016 metadata. `Verified on 2026-08-13` describes
  our access date, not the material's effective race year.
- **Duplicate GPX source trap:** the current Maps & Profiles page S4 links S5,
  whose extracted GPX exactly matches the repository. The organizer's separate
  https://bighorntrailrun.com/downloads page still links an older ZIP at
  https://img1.wsimg.com/blobby/go/07161f14-d61e-453c-a3cc-f57e0150d044/downloads/Bighorn%20100%20gpx%20file.zip?ver=1782760221377
  (server `Last-Modified` 2023-06-07; extracted GPX SHA-256
  `8a896376547d368cad75215ceec18d105cc2bee3ebf8ccf893d0b7eb5d161f90`).
  Treat S4/S5 as current and record the stale duplicate rather than claiming only
  one organizer-hosted GPX exists.

## Correction list for the current repository

This is a correction specification, not an application edit.

1. In `db/events/bighorn-100.yml`, downgrade the global and station source status
   from blanket `verified` to claim-level statuses; attach the direct S2/S3/S5/S6
   URLs and 2026-08-13 access dates.
2. Retain the 35-hour scalar with warning/conflict metadata while retaining start
   `2026-06-19 9:00 AM` and finish cutoff `2026-06-20 8:00 PM`; cite S7's
   contradictory 34-hour statement.
3. Set every `water`/`has_water` value used for **potable** display to unknown.
   Keep literal water inventory in `aid` notes with its source.
4. Keep Dry Fork outbound medical false/not listed, add the S1/S5/S15 ambiguity as
   a source warning, keep Dry Fork inbound true, and downgrade finish medical to
   unknown/not specifically established; finish food is supported by S2/S6.
5. Split pacer data into at least `pickup_allowed` and `accompaniment_allowed`, or
   relabel the current boolean everywhere as `pacer pickup/transfer`. Remove `No
   pacers` notes on post-mile-30 through-passes and the finish.
6. Keep drop bags only at Dry Fork, Sally's Footbridge, and Jaws. Source them to
   S14 plus S1/S2, and retain out/in bag-combination guidance. For all other
   passes, prefer `not listed` over an inferred hard `false` if the schema permits.
7. Replace the source note that a `2026 aid chart explicitly lists water`: S3 is
   undated and does not list water except in `Minimal (Water Only)` at Tongue River
   Trailhead. The wider water inventory comes from S1/S5.
8. Delete `2026 filled from the wait list`; represent registration as past/closed
   after the race, and set lottery status unknown.
9. Prefer direct 2026 results S10. Describe S18 as announced SPOT tracking with no
   durable live link verified.
10. Mark the crew-route geometry/distance/time as an Ultrainfo-generated estimate,
    not an official race fact; reconcile its legs against S11's approximate times.
    The displayed aid-station route omits official non-aid crewing points at Camp
    Creek Ridge and the Devil's Canyon Road crossing, so it is not a complete crew
    access itinerary.
11. Preserve the GPX because its bytes are proven to match S5, but store provenance,
    access date, hash, and the 2016-metadata caveat next to the artifact.
12. Recompute the event bundle digest only after the corrections are reviewed and
    applied; do not use the current digest as evidence that the facts are correct.

## Audit boundary

No application, event-data, test, database, or generated-asset files were changed
as part of this audit. This file is the sole durable artifact. Facts not positively
established above should be published as unknown or disputed, not inferred from
the shape of another field.

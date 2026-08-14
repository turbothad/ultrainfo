# Burney Mountain 100 (2027) source audit

Verified on 2026-08-14. This audit uses only the current Intermountain
Endurance race page, its linked Google Docs runner and crew guides, the
organizer-linked Gaia and CalTopo course data, and the UltraSignup 2027
registration and results surfaces. It records what those sources establish;
it does not treat a source label as proof that the material is year-current or
internally consistent.

## Bottom line

**The Race is publishable with a source warning.** UltraSignup announces
Friday, June 18, 2027 at 4:30 AM in Cassel, California, and offers a live paid
registration button. The organizer says the course starts and finishes at
Burney Mountain Guest Ranch and has a 40-hour cutoff. Its currently linked
guide supplies a complete thirteen-pass operational frame (Start, eleven
mid-race passes, and Finish), and its currently linked Gaia and CalTopo maps
supply the same 4,583-point elevation-bearing line.

The record cannot be presented as final. The 2027 listing says the course will
be one of four snow-dependent variants, A-D; the guide says the choice will not
be known until race week. The linked line is explicitly titled **“Burney
Mountain 100 2026,”** and the guide retains a June 20 date from the completed
2026 Race. Treat the linked line and pass table as the organizer's current
provisional 2027 surfaces, publish them at verification status `warning`, and
re-audit when the organizer selects a variant or posts a 2027-labeled guide or
map.

Recorded discrepancies and decisions:

1. **2027 frame, mixed-vintage details.** UltraSignup `did=140927` establishes
   June 18, 2027 and the 4:30 AM start. The organizer race page advertises
   registration for 2027, and the 2027 listing directs runners to that page's
   GPX and guide links. However, both linked maps are titled 2026, and the
   guide's post-race section says the meal is on “Saturday, June 20st,” the
   2026 Saturday. The current links are provisional authority, not evidence
   that the underlying artifacts were rewritten for 2027.
2. **Snow decides the exact line.** The listing and guide publish Courses A,
   B, C, and D. Only A reaches Magee Peak fully; B-D alter the upper-elevation
   course according to remaining snow. The guide says the selection will not
   be known until race week. Publish the linked line with a warning, not as a
   final 2027 promise.
3. **Date, clocks, and timezone.** Start is Friday, June 18 at 4:30 AM PT;
   the guide's final cutoff is Saturday at 8:30 PM, exactly 40 hours later and
   therefore June 19, 2027. Use `America/Los_Angeles`. UltraSignup's JSON-LD
   incorrectly gives the Race an end date equal to its start date; the guide's
   dated cutoff ladder governs the end.
4. **Registration.** Record `open`. UltraSignup renders a green $350 paid
   registration choice ($376.25 including fees), its metadata says
   `InStock` and `validFrom` August 1, 2026, and the page says registration
   closes Friday, June 11, 2027 at 11:59 PM PT. The group-events API's
   `OpenRegistration:false` conflicts with the actionable registration page
   and loses. No capacity is published. This is direct registration with no
   lottery mechanism published, so `lottery` is false.
5. **Location pin conflict.** The organizer says Start and Finish are at
   Burney Mountain Guest Ranch in Cassel. The current course starts and closes
   at `40.957249,-121.561317` (1.6 m closure), while UltraSignup's Directions
   pin is `40.9171205648601,-121.556530455525`, about 2.78 miles away. The
   named venue and course endpoint govern; do not use the registration pin as
   the course start.
6. **Pass table is nominally 102 miles.** The guide's `Next AS` distances and
   pass miles end at 102, while the linked route is approximately 104 miles.
   Preserve the guide's operational miles and the map's geometry separately;
   do not rescale one and claim the result was organizer-published.
7. **Conditional Magee aid station.** A note after the guide table says a
   minimal Magee aid station, consisting of ham radio personnel, medical, and
   bare-bones supplies, may be present and in some years is pulled. It has no
   published mile and no table row. The 2027 station-pass record therefore has
   the thirteen table passes below; Magee must not be manufactured as a
   fourteenth pass unless pre-race material confirms it and supplies its mile.
8. **Cutoffs.** Eight guide clocks elapsed from Friday 4:30 AM: Tamarack 7:00
   PM Friday (870 min), Cypress 2:00 AM Saturday (1,290), Base of Burney
   Mountain first pass 4:30 AM (1,440), Burney Mountain Summit 9:00 AM
   (1,710), Base second pass 11:30 AM (1,860), Goose Valley 3:00 PM (2,070),
   Black Ranch 5:00 PM (2,190), and Finish 8:30 PM (2,400). The guide does not
   state arrival-versus-departure semantics.
9. **Crew and pacers.** The table marks crew at Highway 89, both Base passes,
   Goose Valley, and Black Ranch. The crew guide publishes coordinates for
   those four physical locations. Pacer pickup or exchange is allowed at both
   Base passes, Goose Valley, and Black Ranch; the first pacer may start at the
   first Base pass (mile 55). Up to four pacers are allowed, one at a time;
   they sign a waiver/check in, stay with the runner to a designated point,
   carry their own required gear, and may not mule.
10. **Drop bags.** The guide marks bags at Highway 89, Tamarack, Cypress, both
    Base passes, Burney Mountain Summit, Goose Valley, and Black Ranch. All
    bags must be staged at the Guest Ranch Thursday from 4:00-7:00 PM. The
    Start is therefore a bag drop-off, not a published on-course bag pass; the
    Finish row leaves the field blank.
11. **Elevation conflicts.** The 2027 listing says approximately 15,000 feet
    of cumulative climbing, and the current organizer page says the Race
    climbs and descends a cumulative 15,000 feet. The guide instead says
    approximately 14,000 feet of gain. Gaia reports +3,539.8/-3,523.5 m
    (+11,614/-11,560 ft) for the linked line, while raw point-to-point summation
    of its unsmoothed altitude samples is about +16,513/-16,509 ft. Record the
    current 15,000-foot organizer scalar as approximate; retain the line's
    altitude series without claiming that noisy raw summation is the Race's
    published gain.
12. **Tracking and results.** No live-tracking surface is published. The
    stable UltraSignup results page supplies 2026 results and links 2025; no
    2027 follow URL exists yet.
13. **run100s is stale.** Its discovery row describes the 2026 Race as 38
   hours and 7,500/7,500 feet. The organizer page and guide publish 40 hours,
   and the current first-party elevation prints are 14,000 or 15,000 feet of
   gain. Neither run100s figure should enter the Race record.
14. **2027 service requirement and gear.** The 2027 listing requires either
    eight hours of trail work or twelve hours of race volunteering. The
    current mixed-vintage guide does not yet contain the promised submission
    details. Its required-gear list is a headlamp with backup, one-liter water
    capacity, and a cell phone; a foil blanket and calories are recommended,
    not required.

## Source register

All URLs below were opened or downloaded on 2026-08-14.

| ID | First-party or organizer-linked source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | Intermountain Endurance Burney Mountain 100 page | https://www.intermountainendurance.com/burney-mountain-100 | Current organizer entry point. Announces 2027 registration; says Start/Finish are at Burney Mountain Guest Ranch, 40 hours, 4:30 AM, and 15,000 ft; links S2-S7. Its body retains a 2026/2027 trail-work transition note. |
| S2 | UltraSignup 2027 registration | https://ultrasignup.com/register.aspx?did=140927 | Friday June 18, 2027 at 4:30 AM; Cassel, CA; live $350 registration; June 11 close; approximate 15,000-ft climb; four snow-dependent course variants; 2027 trail-work/volunteer requirement; deferral and transfer terms. Its JSON-LD supplies the August 1, 2026 `validFrom` date but incorrectly makes `endDate` equal `startDate`. |
| S3 | Current organizer-linked runner guide | https://docs.google.com/document/d/1bx0CV_oRxGoTrrdYb3CfoTwC2W2Bf9-OOetM5G_l1l4/edit?usp=sharing | Race operations: 4:30 AM start, 40-hour and eight-clock cutoff ladder, nominal 102-mile table, crew/pacer/drop-bag rules, aid, required gear, four course variants, and conditional Magee station. Mixed vintage: still prints Saturday June 20 for the meal and does not contain S2's promised 2027 trail-work submission details. |
| S4 | Current organizer-linked crew guide | https://docs.google.com/document/d/18c98P7KTyV8mcTXluTR5aqmfT3YpDJVPBl9qsqCfo_s/edit?tab=t.0 | Directions and exact coordinates for the four crew-accessible physical aid locations; crew/pacer safety rules; ham radio at Tamarack, Cypress, and Base; medical contact. |
| S5 | Organizer-linked Gaia course map | https://www.gaiagps.com/map/?loc=9.3/-121.5704/40.8452&pubLink=K6miEiOB1sQCQc8ZP95KthcK&trackId=b2815b045bafe777549913c3b6483bf9 | Public track titled “Burney Mountain 100 2026,” created by the race director's account. Thirteen segments, 4,583 elevation-bearing points, 167,408 m / 104.023 mi and Gaia-calculated +3,539.8/-3,523.5 m. Current-linked but not 2027-final. |
| S6 | Gaia public track data | https://www.gaiagps.com/api/objects/track/b2815b045bafe777549913c3b6483bf9/ | Machine-readable geometry and published route metrics behind S5. No station waypoints. Updated May 1, 2026. |
| S7 | Organizer-linked CalTopo course map | https://caltopo.com/m/F0KV9AL | “Burney Mountain entire course 2026”; displays the same route as S5 as one line and supplies interactive profile/export capability. Current-linked but not 2027-final. |
| S8 | CalTopo map data | https://caltopo.com/api/v1/map/F0KV9AL/since/0 | Machine-readable line behind S7: one 4,583-point elevation-bearing `LineString`, title “Burney Mountain 100 2026,” no markers. The merged line measures 104.036 mi because it connects tiny gaps between S5's thirteen segments. Created/updated May 31, 2026. |
| S9 | UltraSignup 2026 results | https://ultrasignup.com/results_event.aspx?did=128016 | Latest completed results, Friday June 19, 2026; year navigation also reaches 2025. Stable results target, not live tracking. |
| S10 | UltraSignup Intermountain Endurance feed | https://ultrasignup.com/service/events.svc/groupevents?gid=510 | Confirms EventId 18259 / EventDateId 67495 and the 2027 date, but returns `OpenRegistration:false`, conflicting with S2's actionable green registration choice and `InStock` metadata. |

## Current provisional station-pass table

This is the exact sequence supported by S3 for the currently linked course,
with Start added as the implied landmark at the Guest Ranch. It is provisional
for 2027 because of decisions 1, 2, and 7. `Y` and `N` reproduce published
table values; `--` means the guide leaves the field blank or the fact is not
applicable. “Pacer” means pickup or exchange at that pass, not whether a pacer
already accompanying the runner may pass through. The map has no station
waypoints, so coordinates appear only where S4 publishes them.

| Direction | Mile | Station pass / aid | Crew | Pacer pickup | Drop bag | Cutoff clock (elapsed) | Published coordinates |
|---|---:|---|:---:|:---:|:---:|---|---|
| Start | 0 | Burney Mountain Guest Ranch / Start | Y (venue) | N | Staging only | Fri 4:30 AM (0 min) | Course start `40.957249,-121.561317` |
| Pass | 7 | Cassel Rd / water drop | N | N | N | None published | -- |
| Pass | 16 | Cache 22 | N | N | N | None published | -- |
| Pass | 23 | Highway 89 / Hat Creek Fire Station | Y | N | Y | None published | `40.80851637983394,-121.5133973560638` |
| Pass | 37 | Tamarack Trailhead / hot food | N | N | Y | Fri 7:00 PM (870 min) | -- |
| Pass | 50 | Cypress Trailhead / hot food | N | N | Y | Sat 2:00 AM (1,290 min) | -- |
| Pass | 55 | Base of Burney Mountain (first) / hot food | Y | Y, first pickup | Y | Sat 4:30 AM (1,440 min) | `40.7802174400607,-121.64314497687803` |
| Pass | 63.5 | Burney Mountain Summit | N | N | Y | Sat 9:00 AM (1,710 min) | -- |
| Pass | 72 | Base of Burney Mountain (second) / hot food | Y | Y | Y | Sat 11:30 AM (1,860 min) | Same as mile 55 |
| Pass | 83 | Goose Valley Rd / hot food | Y | Y | Y | Sat 3:00 PM (2,070 min) | `40.8726619327789,-121.69481148497168` |
| Pass | 89 | Black Ranch / hot food | Y | Y | Y | Sat 5:00 PM (2,190 min) | `40.928575944564145,-121.64497639781568` |
| Pass | 95 | Rail Trail / water only | N | N | N | None published | -- |
| Finish | 102 | Burney Mountain Guest Ranch / Finish | -- | -- | -- | Sat 8:30 PM (2,400 min) | Course finish `40.957241,-121.561333` |

S3 says snacks, Hammer gels, and electrolytes are available at all aid
stations, with the named hot-food stations shown above. Cassel Road is labeled
a water drop and Rail Trail is explicitly water-only; neither supports a food
claim. No source certifies water potability. No
table pass has published station-level medical staffing; retain `med: null`.
The conditional Magee operation is the sole medical-staffing statement and is
not a mappable pass until its 2027 presence and mile are announced.

## Course geometry and elevation audit

S5/S6 and S7/S8 are two representations of the same coordinate and altitude
series:

- Gaia preserves thirteen contiguous or nearly contiguous segments containing
  4,583 points. Its own distance property is 167,408.37 m (104.023 mi), and
  it reports +3,539.83/-3,523.50 m (+11,614/-11,560 ft).
- CalTopo concatenates the points as one line. Haversine summation including
  its connections across the tiny segment gaps is 104.036 mi. The longest
  inter-segment gap in Gaia is about 32 ft.
- Start is `40.957249,-121.561317`; Finish is
  `40.957241,-121.561333`, about 1.6 m away. Bounds are latitude
  `40.699581..41.002289` and longitude `-121.694618..-121.423920`.
- Every point carries elevation. The range is 907-2,600 m
  (2,976-8,530 ft). Raw positive and negative sample deltas are approximately
  +5,033/-5,032 m (+16,513/-16,509 ft); those noisy totals do not override
  either Gaia's smoothed properties or the organizer's printed scalar.
- Neither map contains station waypoints. Gaia's thirteen segment boundaries
  roughly track the guide's station sequence and expose an extra boundary
  between Tamarack and Cypress, consistent with the conditional Magee note,
  but the sources do not name the boundaries. Do not promote them to station
  coordinates by inference.

For an event bundle, use the current-linked line and its embedded elevations
as provisional geometry, the guide's nominal miles for station-pass labels,
and the four exact S4 coordinates where available. Any other station spots
must be clearly derived from the line rather than described as published
waypoints.

## Claim-level decisions

- **Name.** `Burney Mountain 100` (S1, S2).
- **Publication.** Publishable at verification status `warning`; current
  route and operations are provisional pending the snow-dependent 2027 course
  choice.
- **Date/start/cutoff.** June 18-19, 2027; Friday 4:30 AM; 40 hours to
  Saturday 8:30 PM; `America/Los_Angeles` (S1-S3).
- **Location.** Burney Mountain Guest Ranch, Cassel, California. Use the
  course endpoint, not UltraSignup's displaced Directions pin.
- **Registration.** `open`; metadata opens August 1, 2026 and the page closes
  June 11, 2027 at 11:59 PM PT. Capacity unknown/unpublished. `lottery: false`
  because the live surface is direct paid registration and publishes no
  lottery.
- **Station passes.** Thirteen provisional passes: Start, eleven mid-race
  passes, Finish. Do not add conditional Magee until confirmed.
- **Crew/pacers/drop bags/cutoffs.** Use the table above. Crew and pacer rules
  are pass-specific, and cutoff arrival/departure semantics are unpublished.
- **Medical.** `null` at every modeled pass. Conditional Magee may have
  medical but is not yet a modeled pass.
- **Elevation.** Approximate gain 15,000 ft from the current 2027 listing;
  approximate loss 15,000 ft from the organizer page's climb-and-descent
  statement. Preserve S5/S8 elevations for the profile and retain all metric
  conflicts in source notes.
- **Follow/results.** No live tracking published; latest results at S9.

## Recheck triggers

- Re-audit in race week when the organizer announces Course A, B, C, or D and
  whether Magee aid exists.
- Replace the 2026-titled line only when the organizer links a 2027-final map;
  compare its distance, endpoints, elevations, and station crossings.
- Re-export the guide when it adds the promised 2027 trail-work submission
  instructions or replaces the stale June 20 meal date.
- Confirm whether any capacity, live tracking, station-level medical service,
  or arrival/departure cutoff semantics are later published.
- Reconcile the UltraSignup group feed's false registration flag if the paid
  registration choice disappears.

## Audit boundary

No application, race-data, queue, GPX, generated-asset, database, test, or
git-state files were changed as part of this audit. This Markdown file is the
sole durable artifact.

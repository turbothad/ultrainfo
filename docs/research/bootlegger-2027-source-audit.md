# Bootlegger 100 (2027) source audit

Verified on 2026-08-13. This audit uses the organizer's 2027 UltraSignup
listing, bootlegger100.com (Revolution Running), the Runners Packet
Google Doc both sites link, and the official course GPX the listing
links. It records what those sources actually establish; it does not
treat an organizer label as proof that a fact is current or internally
consistent.

## Bottom line

The record is publishable with a source warning. The 2027 listing is
live ("The Bootlegger 100 Mile Trail Race - March 20, 2027", the 5th
running) with open registration and start times (100 Mile 6:00 AM); the
site and Runners Packet publish the 35-hour cutoff schedule, the
two-station loop with the crew table, pacer rules, and drop-bag policy;
and the listing's Download GPX File link supplies the loop with
elevations. The 100 runs eight 12.5-mile loops from the Group Shelter at
Indian Springs State Park through the Dauset Trails near Flovilla, GA.

Recorded discrepancies and decisions:

1. **run100s is stale twice.** The 32-hour cutoff and 6,000-foot climb
   captured in the onboarding queue's run100s snapshot (the live table no
   longer displays those columns for this row) have no counterpart: the site says "The cutoff for the 100 mile race
   is 5pm on Sunday-35 hours" and the gain figures cluster around
   1,000 per loop. Neither run100s figure was copied.
2. **Three conflicting gain figures.** The listing says "roughly 9000
   feet of gain (little over 1K each loop)", the site "about 1050 feet
   of elevation per loop" (8,400 over eight), and the Runners Packet
   "approximately 1,000 feet ... per loop" (8,000). No figure is
   recorded; all three are documented.
3. **Loop frame.** Billed 12.5 miles per loop (eight loops = 100); the
   official GPX GPS-measures 12.31 miles with an 18-foot closure. The
   billed frame governs pass miles.
4. **Cutoffs.** Two published gates: the last loop must start by 12:00
   PM Sunday (mile 87.5, 30 hours) and everything ends 5:00 PM Sunday
   (35 hours). No other station cutoffs exist.
5. **Crew.** The Runners Packet's table: Start/Finish 12.5 YES; Aid
   Station #2 6.2 NO — plus a ban on crewing along the gravel Lake
   Clark Road section. Crew true at the Group Shelter passes only.
6. **Pacers.** "Pacers can start pacing after 5pm at the Start/Finish
   aid station", one at a time, bib and waiver required (no source names
   the day; the record quotes only the clock). Pacer true at
   the mid-race Group Shelter passes with the 5:00 PM condition noted;
   false at Aid Station 2, the Start, and the Finish.
7. **Drop bags.** Taken for the mile-6.2 station only (left at packet
   pickup, returned Sunday); the start/finish hub needs none because
   crews set up there. Drop true at the 6.2 passes, null at the hub.
8. **Qualification, not a lottery.** Entry requires a finished 50K (or
   50 miles on this course); registration is otherwise direct.

## Source register

All URLs below were opened or downloaded on 2026-08-13.

| ID | First-party source | Direct URL | Scope and caveat |
|---|---|---|---|
| S1 | UltraSignup 2027 registration page | https://ultrasignup.com/register.aspx?did=137845 | "The Bootlegger 100 Mile Trail Race - March 20, 2027"; 5th running; 12.5-mile loop ×8 with "roughly 9000 feet of gain"; two aid stations; Western States qualifier and 2028 WSER raffle (register by October 1, 2026); 50K qualification; refunds until three months out; start times (100 Mile 6:00 AM, 50 Mile 7:30 AM Saturday, 12.5 Mile 7:30 AM Sunday); open registration $250 rising after November 26, closing March 10, 2027; the Download GPX File and visorando links; 2023-2026 results. |
| S2 | bootlegger100.com | https://www.bootlegger100.com/ | Course info (half mile of road, the 3.5-mile Indian Springs connector into Dauset Trails, longest climb near miles 9-10, two miles of gravel and paved road to close the loop, about 1,050 feet per loop); aid stations at 6.2 and 12.5 with crew at the start/finish only; the cutoff schedule (35 hours, 5:00 PM Sunday, last loop by noon); pacer rules; the Runners Packet link; contact address 678 Lake Clark Road, Flovilla, GA. |
| S3 | Runners Packet Google Doc | https://docs.google.com/document/d/1H8htzM3H2QVdtlCPtS5YxA7A4CabbLmh_pdEovRyONc/edit | Start/finish at the Group Shelter at Indian Springs State Park (parking, passes, crew setup from 2:00 PM Friday); race weekend schedule (packet pickup 3:00-6:00 PM Friday, pasta dinner 5:00 PM, race-morning pickup 5:00 AM, 100 Mile 6:00 AM, last lap by noon Sunday, all races done by 5:00 PM Sunday); the crew table (Start/Finish YES, Aid Station #2 NO); Lake Clark Road crewing ban; pacer rules; cupless-race rule; drop bags for the mile-6 station; DNF procedure. |
| S4 | Official course GPX download | https://drive.google.com/uc?export=download&id=1KFRF0BiRw6BoGRH3SfZzJo660pKX9E3l | Geometry and elevation authority ("Bootlegger Route", the listing's Download GPX File link): 905 points with elevations, 12.31 GPS miles, 18-foot closure, start 33.24824,-83.92739. `db/events/bootlegger-100.gpx` copies the points exactly and adds two station waypoints. |
| S5 | Course map on visorando | https://www.visorando.com/en/walk-90684483/ | Interactive companion map the listing embeds. |

## Claim-level decisions

- **Name.** "Bootlegger 100" — the listing's title for the 100-mile
  race; the weekend brand is the Bootlegger Trail Races.
- **Registration status.** `open` — S1 sells all three distances.
- **Lottery.** `false` — direct registration with the 50K
  qualification requirement recorded in notes.
- **Cutoffs.** Two: 87.5 = 12:00 PM (1,800 — the last-loop gate) and
  100 = 5:00 PM (2,100). `cutoff_hours` 35.
- **Station passes.** 17: the Start plus two passes on each of eight
  loops (Aid Station 2 +6.2, Group Shelter +12.5), the last recorded
  as the Finish, with "Loop N" directions.
- **Crew.** `true` at the nine Group Shelter passes; `false` at the
  eight Aid Station 2 passes (decision 5).
- **Pacers.** `true` at the seven mid-race Group Shelter passes (12.5
  through 87.5) with the after-5:00-PM condition noted; `false`
  elsewhere (decision 6).
- **Drop bags.** `true` at the eight Aid Station 2 passes; `null` at
  the hub passes (decision 7).
- **Medical.** `null` everywhere — no published medical service.
- **Elevation series.** The official GPX's elevations per nominal loop
  mile, repeated per lap (503-666 ft); station spots at the waypoints.
- **Follow.** No live tracking published; results on the listing page.

## Stale-source traps

- run100s' 32-hour cutoff and 6,000-foot climb are superseded (35
  hours; ~1,000 ft per loop).
- The gain figures disagree across the organizer's own surfaces
  (decision 2); re-check whether a canonical figure appears later.
- The GPX is undated ("Bootlegger Route" by John Pollard); re-check
  geometry before race week.
- The WSER-raffle registration deadline (October 1, 2026) and the
  price increase (November 26, 2026) will pass; re-check the listing's
  registration state near those dates.

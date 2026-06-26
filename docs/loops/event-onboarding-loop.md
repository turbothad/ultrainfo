# Loop: ultrainfo event onboarding — first run: Bighorn 100

**This is the project's first item.** A self-paced `/loop` that (A) fixes the design so it
matches the wireframe, then (B–D) turns one official race page into a real, sourced event with
its course GPX and **crew driving routes** on the map. Phases B–D are the reusable pipeline for
every future event — adding event #2 should be "run the importer with new inputs," not new code.

## How to run
```
/loop @docs/loops/event-onboarding-loop.md
```
No interval → the model self-paces: each iteration does ONE checklist item, verifies, commits,
ticks the box, and stops. It ends when every box is checked.

---

## PROMPT  (what the loop runs each iteration)

You are working in the **ultrainfo** Rails app (`~/ultrainfo`) in **ponytail mode**: lazy means
reuse what already exists (the `Race`/`AidStation` models, the `map` Stimulus controller, the
Tailwind tokens) and make the smallest change that matches the spec — but never lazy about
visual craft, safety-relevant data, or accessibility. Run Ruby/Rails via `mise exec -- …`
(a bare shell defaults to the wrong Ruby), e.g. `mise exec -- bin/rails test`.

**Each iteration:** read the checklist below, do the FIRST unchecked `[ ]` item only. Then:
1. `mise exec -- bin/rails test` and `mise exec -- bin/rubocop` (and `bin/brakeman` if you touched controllers/models) — all green.
2. Screenshot the affected page and compare it to the wireframe. Tooling is set up (Chrome for Testing installed): boot a dev server, then `mise exec -- bundle exec ruby script/shot.rb <url> <out.png> [wait]` (Selenium + real event loop — renders Leaflet/async) into `tmp/screens/`, and Read the PNG to actually look at it. `bin/shot` is a faster path for static (non-map) pages.
3. Commit with a conventional message.
4. Tick the box in THIS file (edit it) and stop. If every box is checked, print `LOOP DONE` and stop.

**Ground rules**
- The wireframe at `docs/spec/ultra-100-wireframe.html` is the visual source of truth. **Port it, don't paraphrase.** Keep the design tokens. The prior pass lost the design language (generic Tailwind instead of the spec's composition + mono "data-sheet" density) — this loop fixes that.
- Mission trims stay removed: no pricing/sales/login/Register buttons, no global multi-race list. Role-first, free, one US event for now.
- **Honesty:** data taken from the official page/PDF carries a source note; anything not yet verified is marked `[UNVERIFIED]` (data) or `[PLACEHOLDER]` (copy) and stays behind the per-race placeholder banner until verified. NEVER present an invented cutoff or crew flag as fact — a wrong "crew allowed" can strand a crew at 2 a.m.
- **Generalize for many events:** every import / GPX / routing step must be parameterized by race (a rake task or service taking a slug or URL, reading a per-event data file). No Bighorn-hardcoded branches.

### Phase A — fix the design (one-time)
- [x] Hero: port the wireframe's two-column hero. *(done — screenshot-verified vs the wireframe; also fixed a Leaflet init bug that was blanking every map)* Left = `clamp()` uppercase Archivo headline + a real Bighorn stat row (distance / vert / aid stations, mono labels) + the three role doors as the CTAs. Right = the framed Bighorn course map (reuse the `map` controller) with the floating glass info card (race name + dist/vert) and the bottom coordinate / aid-station readout bar.
- [x] Re-style the role doors with the spec's density (mono eyebrow + footer stat rule + hover; real per-role stats). *(screenshot-verified. Race-LIST cards — date badge / difficulty meter — deferred: one event has no list; revisit when event #2 lands.)*
- [x] JetBrains Mono "data-sheet" labels applied consistently (eyebrows, stat rows, table headers, captions, registration rows). *(audited — most already inherited mono; fixed the runner registration card. Screenshot-verified.)*
- [x] Elevation profile SVG rebuilt to spec: gridlines + ft labels, gradient fill, on-profile crew markers, Jaws high-point callout, place-named x-axis, x mapped by mile, distortion removed. *(screenshot-verified.)*
- [ ] Match section rhythm, the dark panels, radii, borders, and shadows to the spec; tighten the airy spacing.
- [ ] Screenshot every page and confirm it reads like the spec, not stock Tailwind.

### Phase B — Bighorn 100 real data  (reusable pipeline; first target slug: `bighorn-100`)
- [x] Real aid stations seeded — coords from the official GPX waypoints; miles, crew/pacer/drop-bag flags, cutoffs and spot elevations from the race site. *(exact date, entry fee, registration, total climb still `[UNVERIFIED]` — pull from the official PDFs.)*
- [ ] Move the import into a parameterized rake task reading a per-event data file under `db/events/`. *(Partial: `Gpx::Import` + `db/events/<slug>.gpx` are reusable; aid data still lives in `db/seeds.rb`.)*
- [x] Real cutoffs + start time on the runner/crew views (start 9:00 AM; overall cutoff 8:00 PM ≈ 35 h).
- [ ] Once data is verified against the official PDFs, drop the banner. *(Softened to name only what's unconfirmed; not dropped.)*

### Phase C — GPX on the map
- [x] Course GPX obtained (`db/events/bighorn-100.gpx`). *(ponytail: parsed with Nokogiri, not the `gpx` gem. Track is lat/lng-only + named aid-station waypoints; no elevation.)*
- [x] Parse GPX → decimated `simplified_track` (600 pts) + aid-station coords, via `Gpx::Import`. *(Elevation profile from official aid-station spot elevations since the track has no ele; total gain/loss `[UNVERIFIED]`.)*
- [x] Real course line + real aid-station coordinates render on the map + elevation profile — screenshot-verified (hero + crew).

### Phase D — crew driving routes ("show the crew driving")
- [ ] Compute road driving routes between consecutive **distinct crew-accessible trailheads** in race order (Start → Dry Fork Ridge → Sally's Footbridge → Jaws → back to Sally's → Dry Fork → Finish) using a free routing service (default: OpenRouteService free key, or OSRM). Cache the returned polylines on the DB — one fetch per event, never block page render.
- [ ] Draw them as a distinct **dashed "crew drive" layer** on the crew map with its own toggle, and show drive distance + time between crew points. Fall back to straight segments + the existing "Get directions" deep links if routing is unavailable.

### Definition of done
Pages read like the wireframe (screenshot-verified) · tests + RuboCop + Brakeman green ·
Bighorn shows REAL sourced data (placeholders clearly marked) · the real GPX course and the
crew driving routes render on the map · the importer + GPX + routing are reusable for the next event.

---

## SOURCED DATA — Bighorn 100 aid stations
Source: <https://bighorntrailrun.com/100-mile> (fetched 2026-06-26). Start 9:00 AM, overall
cutoff 8:00 PM. Start: Tongue Canyon Road (mi 0, 4,275'). Finish: Scott Park (mi 100, 3,970').
Turnaround: Jaws Trailhead (mi 48, 8,800'). The page also links a "Course description (pdf)" and
a "Bighorn 100 Aid Station Chart (pdf)" — fetch those for elevation gain, fee, date, and to
confirm everything below. Date / fee / registration / total gain: `[UNVERIFIED — get from PDFs/UltraSignup]`.

| Mile | Aid station | Elev | Cutoff | Crew | Pacer | Drop bag |
|---|---|---|---|---|---|---|
| 0 | Tongue Canyon Road (Start) | 4,275' | — | ✓ | ✓ | — |
| 1.25 | Tongue River Trailhead | 4,240' | — | ✗ | ✗ | ✗ |
| 3.5 | Lower Sheep Creek | 5,025' | — | ✗ | ✗ | ✗ |
| 8.5 | Upper Sheep Creek | 7,450' | — | ✗ | ✗ | ✗ |
| 13.5 | Dry Fork Ridge | 7,480' | 3:00 PM | ✓ | ✓ | ✓ |
| 19.5 | Kern's Cow Camp ("Bacon Station") | 6,600' | — | ✗ | ✗ | ✗ |
| 26.5 | Bear Camp | 6,800' | — | ✗ | ✗ | ✗ |
| 30 | Sally's Footbridge | 4,590' | 8:30 PM | ✓ | ✓ | ✓ |
| 33.5 | Cathedral Rock | 5,080' | — | ✗ | ✗ | ✗ |
| 40 | Spring Marsh | 6,920' | — | ✗ | ✗ | ✗ |
| 48 | Jaws Trailhead (Turnaround) | 8,800' | 4:00 AM | ✓ | ✓ | ✓ |
| 56 | Spring Marsh | 6,920' | — | ✗ | ✗ | ✗ |
| 62.5 | Cathedral Rock | 5,080' | — | ✗ | ✗ | ✗ |
| 66 | Sally's Footbridge | 4,590' | 10:00 AM | ✓ | ✓ | ✓ |
| 69.5 | Bear Camp | 6,800' | — | ✗ | ✗ | ✗ |
| 76.5 | Kern's Cow Camp | 6,600' | — | ✗ | ✗ | ✗ |
| 82.5 | Dry Fork Ridge | 7,480' | 3:00 PM | ✓ | ✓ | ✓ |
| 87.5 | Upper Sheep Creek | 7,450' | 4:30 PM | ✗ | ✗ | ✗ |
| 92.5 | Lower Sheep Creek | 5,025' | — | ✗ | ✗ | ✗ |
| 94.8 | Tongue River Trailhead | 4,240' | 6:45 PM | ✓ (foot/bike) | ✗ | ✗ |
| 98 | Home Stretch | 4,040' | — | ✓ (foot/bike) | ✗ | ✗ |
| 100 | Scott Park (Finish) | 3,970' | 8:00 PM | ✓ | ✓ | — |

Crew-drivable trailheads (Phase D route order): **Start → Dry Fork Ridge → Sally's Footbridge → Jaws → Sally's Footbridge → Dry Fork Ridge → Finish.** (Coordinates aren't on the page — geocode/confirm from the GPX + official course map; mark `[UNVERIFIED]` until then.)

## Decisions (defaults chosen — override anytime)
- **Crew-driving routing engine:** default **OpenRouteService** (free API key) or **OSRM** (no key). Mapbox/Google work but need paid keys — against the free/OSS ethos.
- **GPX source:** the 100-mile page has no GPX. The loop will search CalTopo/Strava/the PDFs; or drop a `.gpx` in `~/Downloads` and it'll use that.

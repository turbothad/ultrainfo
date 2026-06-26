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
2. Screenshot the affected page (Capybara + headless Chrome via `selenium-webdriver`, both installed) into `tmp/screens/` and compare it to the wireframe.
3. Commit with a conventional message.
4. Tick the box in THIS file (edit it) and stop. If every box is checked, print `LOOP DONE` and stop.

**Ground rules**
- The wireframe at `docs/spec/ultra-100-wireframe.html` is the visual source of truth. **Port it, don't paraphrase.** Keep the design tokens. The prior pass lost the design language (generic Tailwind instead of the spec's composition + mono "data-sheet" density) — this loop fixes that.
- Mission trims stay removed: no pricing/sales/login/Register buttons, no global multi-race list. Role-first, free, one US event for now.
- **Honesty:** data taken from the official page/PDF carries a source note; anything not yet verified is marked `[UNVERIFIED]` (data) or `[PLACEHOLDER]` (copy) and stays behind the per-race placeholder banner until verified. NEVER present an invented cutoff or crew flag as fact — a wrong "crew allowed" can strand a crew at 2 a.m.
- **Generalize for many events:** every import / GPX / routing step must be parameterized by race (a rake task or service taking a slug or URL, reading a per-event data file). No Bighorn-hardcoded branches.

### Phase A — fix the design (one-time)
- [ ] Hero: port the wireframe's two-column hero. Left = `clamp()` uppercase Archivo headline + a real Bighorn stat row (distance / vert / aid stations, mono labels) + the three role doors as the CTAs. Right = the framed Bighorn course map (reuse the `map` controller) with the floating glass info card (race name + dist/vert) and the bottom coordinate / aid-station readout bar.
- [ ] Re-style the role doors and race cards with the spec's density (mono meta, bordered date badge, stat row, difficulty/▮ meter where relevant) — not generic boxes.
- [ ] Apply the JetBrains Mono "data-sheet" label system consistently: eyebrows, stats, table headers, captions.
- [ ] Rebuild the elevation profile SVG to match the spec: gridlines, gradient fill (`linearGradient`), on-profile aid-station markers, a high-point label, place-named x-axis. Remove `preserveAspectRatio="none"` (it distorts the chart).
- [ ] Match section rhythm, the dark panels, radii, borders, and shadows to the spec; tighten the airy spacing.
- [ ] Screenshot every page and confirm it reads like the spec, not stock Tailwind.

### Phase B — Bighorn 100 real data  (reusable pipeline; first target slug: `bighorn-100`)
- [ ] Replace the placeholder seed with the REAL aid-station table in "SOURCED DATA" below (source: the official page). Fill the rest — exact date, entry fee, registration platform/URL + status, total elevation gain — from the site and its two official PDFs (Course description, Aid Station Chart); mark anything still unknown `[UNVERIFIED]`.
- [ ] Move the import into a parameterized rake task (e.g. `mise exec -- bin/rails "ultrainfo:import[bighorn-100]"`) that reads a per-event data file under `db/events/` — so future events reuse it with no new code.
- [ ] Put real cutoffs + start time on the runner and crew views (start 9:00 AM; overall cutoff 8:00 PM ≈ 35 h).
- [ ] Once data is verified against the PDFs, drop the placeholder banner for this race.

### Phase C — GPX on the map
- [ ] Obtain the Bighorn 100 course GPX: check the site's PDFs/resources and CalTopo/Strava; or use a `.gpx` the user drops in `~/Downloads`. Add the `gpx` gem.
- [ ] Parse GPX → decimated `simplified_track` + `elevation_series` + gain/loss, stored on the race (a reusable `Gpx::Import` service, race-parameterized). If no GPX yet, keep a clearly-marked placeholder track and flag it `[UNVERIFIED]`.
- [ ] Render the real course line + real aid-station coordinates on the map and the elevation profile.

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

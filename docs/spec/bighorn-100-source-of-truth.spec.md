# Bighorn 100 Source Of Truth Spec

Date: 2026-07-07
Status: Draft for approval
Primary route: `/races/bighorn-100`

## Objective

Create a clean, official-source-first Bighorn 100 page that is good enough to
share publicly with runners as a planning source of truth. The page should make
the race understandable for runners, crews and pacers, and followers at home
without forcing users through scattered official pages, PDFs, GPX files, and
map links.

This is the first event in a broader USA ultra race database. Bighorn 100 is the
pilot, but the implementation must remain event-generic.

## Success Criteria

- `/races/bighorn-100` is the canonical public page for the 2026 Bighorn 100.
- The page uses one tabbed role surface near the top: Overview, Runner, Crew,
  Follower, Map.
- Runner, crew, and follower users can immediately tell what the page is about,
  who each section is for, and how to navigate to other roles.
- Runner content covers schedule, registration, cutoffs, drop bags, aid, medical
  checks, pacer points, rules, weather/logistics links, and course basics.
- Crew content includes both crew-allowed and crew-not-allowed aid stations,
  parking/access notes, walking or foot/bike restrictions when known, bathrooms,
  road restrictions, drop bags, pacer rules, and directions.
- Follower content is for people following from home, with tracking links,
  schedule, key timing context, and finish/status links.
- Every official fact is backed by source metadata with fetched or verified
  date. Uncertain facts remain visible only with a clear warning.
- Race data has no personal opinion, no runner strategy notes, and no invented
  field intelligence.
- Emojis are removed from race data and UI copy.
- The map is a Three.js terrain experience, not a Leaflet map, and shows the
  GPX course, aid station markers, and crew driving route layers in distinct
  colors.
- Clicking an aid station opens a detail view with aid, crew rules, cutoff,
  drop bag, medical, parking, directions, and source/warning state.
- Terrain artifacts are preprocessed per race for now.
- The app remains free, open source, no ads, no accounts, and no upsell.

## Non-Goals

- No personal advice, race report, strategy layer, or subjective section notes.
- No during-race runner dashboard.
- No pace chart or projected arrival calculator yet.
- No print/export crew plan yet.
- No historical year pages yet.
- No other Bighorn distances yet.
- No admin/editor workflow yet; repo-managed YAML, GPX, and generated artifacts
  are enough.
- No mobile optimization requirement for the first Three.js terrain pass beyond
  avoiding a broken page.
- No aggressive warning styling for "do not drive here"; warnings should be
  clear, calm, and hard to miss.
- No affiliation disclaimer for now unless legal/trust review later requires it.

## Source Inputs

- User product decisions from this planning thread.
- Existing project README.
- Existing wireframe: `docs/spec/ultra-100-wireframe.html`.
- Existing race data: `db/events/bighorn-100.yml`.
- Existing GPX: `db/events/bighorn-100.gpx`.
- Existing crew route cache: `db/events/bighorn-100.crew_route.json`.
- Official Bighorn 100 page and linked official PDFs, already represented in
  the event YAML and source metadata.
- ITS YOUR RACE registration platform URL from existing event data.
- `kaolti/monolith-terrain` GitHub repo, checked 2026-07-07: MIT license,
  Three.js/Vite, real-world DEM terrain tiles, no API keys required.

## Product Requirements

### Page Frame

- Keep the canonical route as `/races/bighorn-100`.
- Keep Bighorn 100 as the only fully visible launch event, but signal that more
  USA ultras are coming.
- Show "2026" in the race facts because the current canonical data is for the
  2026 race, while keeping the page title as "Bighorn 100".
- Replace separate role destination pages as the primary UX with a single page
  and sticky or near-top tabs.
- Existing separate role routes may remain as redirects or compatibility pages,
  but the first-class experience should be the one-page tabbed interface.

### Role Tabs

- Overview: race identity, essential facts, official source status, date,
  start/finish, distance, vert, cutoff, registration state, route/map entry.
- Runner: start schedule, cutoff table with clock time and elapsed time, aid
  station table, drop bags, medical checks, pacer points, rules/logistics links,
  course/elevation facts.
- Crew: all aid stations with crew allowed/not allowed, crew driving layer,
  parking/access notes, foot/bike-only constraints, pacer rules, drop bags,
  directions, road restriction warnings.
- Follower: home-following experience with live tracking links when available,
  race schedule, key cutoff times, finish timing context, and official result or
  media links when available.
- Map: full terrain explorer with role-aware layers and selected aid station
  detail panel.

### Data Trust

- Add source metadata to race and aid station facts. Minimum supported fields:
  `source_url`, `source_label`, `verified_on`, `source_notes`,
  `verification_status`.
- Support status values equivalent to `verified`, `warning`, and `unverified`.
- Keep citations visually quiet: use a source drawer, source panel, or compact
  "Sources" affordance rather than noisy inline citations everywhere.
- Any warning/unverified state must still be visible from the relevant fact or
  station detail view.
- Do not present a crew access flag, cutoff, or rule as certain unless the
  source metadata supports it.

### Aid Station Detail

- Use an in-page detail view, not separate aid station pages.
- Details should be reachable from the aid station table and from map markers.
- Detail content should include:
  - station name, mile, elevation;
  - cutoff clock time and elapsed time when applicable;
  - aid/water/food availability;
  - medical presence;
  - drop bag status;
  - crew allowed/not allowed;
  - pacer allowed/not allowed;
  - parking/access/road notes;
  - directions link when coordinates exist;
  - source and warning state.

### Visual Direction

- Shift the palette from cream/orange toward light and dark pine green while
  preserving the clean, data-dense, Linear-like product feel.
- Keep an outdoor technical tone: calm, modern, trail-aware, and authoritative.
- Avoid generic SaaS card grids, marketing copy, busy decoration, and emoji.
- Prefer crisp role tabs, compact facts, high-quality spacing, and restrained
  surfaces over a long document page.
- Use green route and terrain language carefully so the interface does not
  become a one-note green palette. Keep neutral surfaces and one primary pine
  accent with secondary route colors for course and crew layers.

## Technical Design

### Existing App Shape

- Rails 8 app with Tailwind v4, Hotwire, Stimulus, import maps, SQLite.
- Current route already supports `/races/:slug`.
- Current page uses `_race_header`, `_role_nav`, `_map`,
  `_elevation_profile`, and `_aid_station_table` partials.
- Current map is Leaflet via `app/javascript/controllers/map_controller.js` and
  `RacesController#map`.
- Current importer reads `db/events/<slug>.yml`, `.gpx`, and optional
  `.crew_route.json`.

### Data Model Changes

Add only the smallest structured fields needed for this slice:

- Add a source metadata store to `races`, probably JSON first:
  `source_metadata`.
- Add a source metadata store to `aid_stations`, probably JSON first:
  `source_metadata`.
- Add richer station fields only where they are needed by the UI and can be
  sourced:
  `bathroom_notes`, `crew_access_notes`, `pacer_notes`, `directions_notes`,
  `road_notes`.
- Add cutoff normalization if needed:
  `cutoff_clock`, `cutoff_elapsed_minutes`, while preserving display copy when
  official sources are irregular.
- Add terrain artifact references to `races`, probably JSON first:
  `terrain_artifacts`, with paths and generation metadata.

Prefer JSON metadata over a full source/fact table until multiple races prove
the need for a normalized citation model.

### Importer Changes

- Extend `Events::Import` to read source metadata from event YAML.
- Keep Bighorn as data, not hardcoded code branches.
- Keep re-seeds idempotent.
- Fail loudly or warn clearly when required source metadata is missing for
  facts that the UI presents as verified.
- Preserve cached crew route behavior so seeding remains offline after route
  generation.

### Three.js Terrain Map

Build on the MIT `kaolti/monolith-terrain` project, preserving license and
attribution.

Implementation direction:

- Adapt the renderer into this Rails app rather than turning the app into a
  Vite project by default.
- Prefer import-map-compatible modules or vendored JavaScript under
  `app/javascript/terrain`.
- Keep only the pieces needed for the first Bighorn map:
  terrain mesh, contour/topo styling, GPX route overlay, aid station markers,
  crew driving route overlay, camera controls, marker detail panel.
- Do not include lil-gui parameter panels, procedural terrain controls, radar
  scans, cinematic tours, or sci-fi HUD controls in the MVP unless they are
  cheap to preserve without UI noise.
- Use preprocessed race artifacts from `db/events` or `public/terrain`.
- Represent course GPX and crew driving route with different colors and layer
  toggles.
- Use accessible HTML controls outside the canvas for tabs, layer toggles,
  source drawer, and selected station detail.
- Keep the map nonblank and useful if terrain loading fails: show a clear error
  state and preserve station/course tables below it.

Preprocessing should produce:

- terrain height grid or mesh payload scoped to the Bighorn course bounds;
- projected course polyline points suitable for draping onto terrain;
- projected aid station points;
- projected crew driving route points;
- metadata: bounds, source tile set, generated_at, vertical scale,
  simplification level, source attribution.

### API / Payload

Replace or extend `RacesController#map` with a terrain-ready endpoint. Candidate:

- `GET /races/:slug/map.json` remains compatible but returns richer structured
  data.
- Add a separate `GET /races/:slug/terrain.json` only if payload size or cache
  behavior needs a boundary.

Payload must include:

- race id/name/year;
- course points;
- crew route geometry and summary;
- aid stations with all station detail fields;
- layer metadata;
- terrain artifact paths;
- source and verification metadata.

### Compatibility

- Existing runner, crew, and follow routes should not break tests during the
  transition.
- They can render the canonical page with a selected tab, redirect with an
  anchor/query param, or remain as simple compatibility pages.
- Public canonical navigation should push users to `/races/bighorn-100`.

## Likely Files

- `docs/spec/bighorn-100-source-of-truth.spec.md`
- `db/events/bighorn-100.yml`
- `db/migrate/*_add_source_metadata_and_terrain_to_races.rb`
- `db/migrate/*_add_source_metadata_and_access_notes_to_aid_stations.rb`
- `app/services/events/import.rb`
- `app/services/gpx/import.rb`
- new terrain preprocessing service or task, likely under `app/services/terrain`
  or `lib/tasks/terrain.rake`
- `app/controllers/races_controller.rb`
- `app/views/races/show.html.erb`
- `app/views/races/_role_tabs.html.erb`
- `app/views/races/_source_drawer.html.erb`
- `app/views/races/_terrain_map.html.erb`
- `app/views/races/_aid_station_detail.html.erb`
- `app/views/races/_aid_station_table.html.erb`
- `app/javascript/controllers/race_tabs_controller.js`
- `app/javascript/controllers/terrain_map_controller.js`
- `app/javascript/terrain/**`
- `app/assets/tailwind/application.css`
- `test/services/events/import_test.rb`
- `test/controllers/races_controller_test.rb`
- system or screenshot test coverage where practical.

## Implementation Slices

### Slice 1: Data Trust And Role Page Shell

- Add source metadata fields.
- Extend Bighorn YAML with source metadata and warning states.
- Normalize cutoff clock and elapsed display where sourced.
- Convert show page to one canonical tabbed surface.
- Keep role routes working through selected tabs or redirects.
- Add quiet source drawer/panel.

Acceptance:

- `/races/bighorn-100` renders with Overview, Runner, Crew, Follower, Map tabs.
- Source metadata is visible from a clean source UI.
- Tests cover import and map/source payload basics.

### Slice 2: Crew/Runner/Follower Content Completeness

- Fill the Runner tab with sourced race logistics and station facts.
- Fill Crew tab with all stations and crew allowed/not allowed state.
- Add pacer rules under Crew.
- Fill Follower tab for home users.
- Remove emojis and personal/opinion copy from data and views.

Acceptance:

- Runner and crew users can answer the major planning questions without leaving
  the page except for official registration/tracking/source links.
- Crew table includes both crew and non-crew stations.
- Cutoffs display clock and elapsed time.

### Slice 3: Terrain Preprocessing Pipeline

- Add a terrain preprocessing command or service for a race slug.
- Generate Bighorn terrain artifacts from DEM/tile inputs and existing GPX.
- Commit generated metadata/artifacts only if size is reasonable; otherwise
  document the generation step and cache behavior.
- Include source attribution in generated metadata.

Acceptance:

- A reproducible command can generate Bighorn terrain artifacts.
- Generated artifacts are race-scoped and do not hardcode Bighorn in code.
- Tests or smoke checks validate artifact shape.

### Slice 4: Three.js Terrain Map

- Adapt monolith-terrain rendering into Rails/Stimulus.
- Render terrain, GPX course, aid station markers, and crew route layer.
- Add layer toggles and selected station detail panel.
- Remove Leaflet as the primary race map.
- Preserve clear fallback state if terrain fails.

Acceptance:

- Map is nonblank in browser screenshot proof.
- Course line is visible on terrain.
- Aid station click opens detail panel.
- Crew driving route can be toggled and uses a distinct color.
- Existing map JSON or replacement endpoint is covered by tests.

### Slice 5: Visual Polish And Public-Share Readiness

- Apply light/dark pine green palette.
- Tighten spacing, tab behavior, table density, and source UI.
- Check desktop-first screenshots.
- Run final verification and code review.

Acceptance:

- Page feels like a clean technical outdoor planning product, not the current
  official race page and not a generic marketing page.
- No broken text layout or incoherent overlap in desktop screenshots.
- Final report lists verified facts, warnings, remaining uncertainty, and
  commands run.

## Verification

Run after meaningful implementation slices:

```bash
mise exec -- bin/rails test
mise exec -- bin/rubocop
mise exec -- bin/brakeman
```

For visual proof:

```bash
bin/dev
mise exec -- bundle exec ruby script/shot.rb http://localhost:3000/races/bighorn-100 tmp/screens/bighorn-100.png 2
```

For the Three.js map:

- Inspect screenshot manually.
- Verify the canvas is nonblank with a simple pixel/DOM smoke check.
- Verify terrain/course/stations/crew route render on desktop.
- Verify marker click opens the station detail panel.
- Verify layer toggles change visible map state.

## Blocked Conditions

Stop and report blocked, rather than inventing data, if:

- official source pages/PDFs conflict on crew access, cutoffs, or rules;
- required Bighorn facts cannot be sourced or marked clearly as warnings;
- terrain source licensing or attribution is unclear;
- terrain artifacts are too large for the repo and no alternate hosting/cache
  boundary is approved;
- import-map integration cannot support the adapted Three.js code without
  adding a Node/Vite build step and that tradeoff has not been approved.

## Recommended /goal

Use a Codex Goal only when beginning the multi-slice build, not for this spec.

```text
/goal Build the Bighorn 100 canonical source-of-truth page at /races/bighorn-100 from docs/spec/bighorn-100-source-of-truth.spec.md, verified by Rails tests, RuboCop, Brakeman, and desktop screenshot proof showing the tabbed role surface and nonblank Three.js terrain map. Preserve official-source-only data, event-generic imports, free/no-account product constraints, and warning labels for uncertain facts. Between iterations, implement the next spec slice, record verification, and continue until all acceptance criteria pass. If blocked by source conflicts, terrain licensing, artifact size, or build-tool tradeoffs, stop with evidence and the owner decision needed.
```

## Final Report Requirements

The implementation closeout must include:

- confirmed facts added or changed;
- source/warning states still present;
- files changed;
- tests and checks run with results;
- screenshot/manual proof path;
- terrain source and attribution status;
- remaining uncertainty;
- next recommended race onboarding step.

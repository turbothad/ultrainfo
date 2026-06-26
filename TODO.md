# ultrainfo — TODO

Deferred work, captured so it doesn't get lost.

## ▶ NOW — first item: Bighorn launch loop
`/loop @docs/loops/event-onboarding-loop.md` — a self-paced loop that (A) fixes the design to
match the wireframe (`docs/spec/ultra-100-wireframe.html`), then (B–D) imports the **real**
Bighorn 100 data, its course **GPX**, and the **crew driving routes** onto the map. Phases B–D
are the reusable per-event pipeline (built for the many events coming after Bighorn). The
"Next up" items below are what that loop works through.

## Done
- Rails 8.1 + Ruby 4.0.5; Tailwind v4 design tokens; role-first landing
- Lean schema: `Race` + `AidStation` (depth fields optional)
- Bighorn 100 seeded as **PLACEHOLDER** data (`db/seeds.rb`)
- Role views: Overview / Run it / Crew or pace / Follow, on real-shaped data
- Leaflet crew-access map (crew vs non-crew, toggle, directions) + elevation profile
- `map.json` endpoint; model + controller tests; RuboCop + Brakeman green

## Next up (MVP — Bighorn 100)
- [ ] **Replace placeholder data with sourced Bighorn data** (official guide + your firsthand notes), then delete `races/_placeholder_banner`
- [ ] Real per-station cutoffs (currently nil → "—")
- [ ] Real course GPX → add the `gpx` gem, parse to `simplified_track` + `elevation_series` + gain/loss
- [ ] Verify aid-station coordinates (placeholder now — see open question)
- [ ] Official live-tracking URL for the follow page

## Later (roadmap)
- [ ] No-account "save my crew plan" (shareable URL + `localStorage`) + crew ETA splits
- [ ] Add a 2nd race end-to-end (stress-test the lean schema; refactor to Event/Edition only if year-2 / multi-distance forces it)
- [ ] Per-race scraper adapters (run100s index; RunSignup API; UltraSignup [unconfirmed]) — breadth, one source at a time
- [ ] Provenance / "last verified" (the plan's `Source` model) once aggregating from outside sources
- [ ] Privacy-first analytics (Plausible / Umami or `ahoy`) — no accounts
- [ ] Schedule / race-weekend timeline (no model yet — add when sourcing real data)

## Ops / housekeeping
- [ ] Kamal deploy to Hetzner (domain ultrainfo.org; SQLite on a persistent volume + Litestream backups)
- [ ] Shoe fund: set up GitHub Sponsors and link in footer + README
- [ ] Confirm CI is green on Ruby 4.0.5 (setup-ruby reads `.ruby-version`)

## Decisions captured
- First race: **Bighorn 100** (was Western States) — you've run it, better firsthand data
- Schema: **lean** (Race + AidStation), not the 7-model plan — provenance/adapters deferred
- No auth in the MVP (confirmed direction)
- Versions: Ruby 4.0.5 / Rails 8.1.3 (your call, done)

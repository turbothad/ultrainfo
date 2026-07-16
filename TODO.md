# ultrainfo — TODO

Deferred work, captured so it doesn't get lost.

## Done
- Rails 8.1 + Ruby 4.0.5; Tailwind v4 design tokens; role-first landing
- Lean schema: `Race` + `AidStation` (depth fields optional)
- Role views: Overview / Run it / Crew or pace / Follow, on real-shaped data
- Leaflet crew-access map (crew vs non-crew, toggle, directions) + elevation profile
- `map.json` endpoint; model + controller tests; RuboCop + Brakeman green
- Bighorn 100 fully sourced + **verified against the official PDFs** (2026-07-02): GPX course
  + aid coords, cutoffs, crew flags, gain 20,500 / loss 20,750 ft, date, registration
  (ITS YOUR RACE) — placeholder banner deleted
- De-slop pass (2026-07-02): dead PWA/mailer/hello scaffold + unused jbuilder removed

## Next up (MVP — Bighorn 100)
- [ ] Live-tracking URL: none exists to link (2026-07-02 — TrackLeaders hosted 2024
  only, no 2025/26 pages; follow page already degrades honestly). Set `tracking_url`
  when the next edition announces its tracker; don't guess.
- [ ] Post-race helpful link: official results (bhtr.itsyourrace.com/Results.aspx?id=384)
  on the follow page — needs a `results_url` column (or a links model) when justified

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

# ultrainfo — TODO

Deferred work, captured so it doesn't get lost. The current scaffold covers: brand,
role-first landing + three role pages, design tokens, a functional test, and CI.

## Next up (MVP — Western States 100)
- [ ] `Event` + related models (aid stations, crew access, schedule, splits); hand-seed Western States 100
- [ ] Runner / Crew / Follow pages: replace placeholder bullets with real, seeded content
- [ ] Course map (Leaflet + OSM / CARTO) with the GPX track
- [ ] **Crew-access overlay** on the map (which aid stations allow crew, parking, routes) — the core wedge
- [ ] Elevation profile + aid-station splits
- [ ] "Where to register" deep-link to the official / UltraSignup page

## Later
- [ ] Per-race scraper adapters (UltraSignup, RunSignup API, race sites / runner-manual PDFs) — one event at a time
- [ ] Additional US events
- [ ] Live tracking integration (per-race official feeds)
- [ ] Privacy-first analytics (Plausible / Umami or `ahoy`) — no accounts
- [ ] "Save my race / crew plan" via shareable URL + localStorage (no login)

## Ops / housekeeping
- [ ] Kamal deploy config for Hetzner (domain ultrainfo.org, registry, secrets)
- [ ] Shoe fund: set up GitHub Sponsors (or similar) and link it in the footer + README
- [ ] Decide whether a single-event site keeps the season-calendar section from the wireframe

## Open questions
- [ ] Confirm: no auth for the MVP
- [ ] Exact contributing / shoe-fund wording

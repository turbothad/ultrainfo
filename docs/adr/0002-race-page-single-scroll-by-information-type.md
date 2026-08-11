# Race page is a single scroll organized by information type

The original spec (2026-07-07) mandated a tabbed role surface (Overview /
Runner / Crew / Follower / Map), and the page was first built that way. On
2026-07-12 we decided the race page is instead one scrolling surface with no
tabs, organized by information type: Race facts → Course → Station passes →
Crew & pacers → Follow → Sources. Each dataset appears exactly once — one
station-pass table (with filter chips as the audience lenses, and the
expandable row as the canonical station-pass detail view) and one terrain canvas
(with layer toggles) — because the tabbed version rendered the same table
three times and mounted three WebGL canvases per page, and hid content from
audiences that overlap heavily.

## Considered options

- **Role tabs** (rejected): duplicated shared data per tab, hid crew facts
  from runners and vice versa, and made the page's primary audience ambiguous.
- **Audience-stacked sections** (rejected): tabs flattened into scroll — same
  duplication, longer page.
- **Race-chronology sections** (rejected): before/during/after splits the
  station-pass data across sections.

## Consequences

- Old role routes (`/races/:slug/runner|crew|follow` and the `/map` HTML
  view) become 301 redirects to section anchors; the `/map` JSON endpoint is
  unchanged. Wayfinding is a sticky anchor bar, not tabs.
- A future reader seeing "tabbed role surface" in older spec language or
  commits should treat this ADR as superseding it.

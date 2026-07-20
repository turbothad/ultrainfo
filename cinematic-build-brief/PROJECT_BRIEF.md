# Cinematic Website Project Brief — UTMB 3D Course Flythrough

Use this brief together with `PROMPT.txt` (the implementation contract) and
`assets.json` (the asset manifest). Where this brief and `PROMPT.txt` disagree,
this brief wins — see "Core mechanic adaptation" below.

## Project

- Project name: `ultrainfo — UTMB landing page`
- Subject, destination, or brand: `Ultra-Trail du Mont-Blanc (UTMB) — the ~171 km loop around the Mont Blanc massif through France, Italy, and Switzerland, starting and finishing in Chamonix`
- Audience: `Ultrarunners, their crews and pacers, and followers tracking the race from home`
- Existing repository or project path: `/Users/thadavery/ultrainfo`
- Existing stack: `Ruby on Rails 8, Hotwire (Turbo + Stimulus), import maps (no Node build step), Tailwind CSS v4 (tokens in app/assets/tailwind/application.css), Three.js already pinned and used for terrain maps with preprocessed Terrain Tiles DEM artifacts, Propshaft, SQLite, Minitest`
- Required launch or delivery date: `None fixed — quality over speed`

## Core mechanic adaptation (overrides the ASSET CONTRACT in PROMPT.txt)

This project replaces the kit's layered 2.5D image stack with a **real 3D
scene**: a Three.js terrain of the Mont Blanc massif with the UTMB course line
built from `assets/utmb-course.gpx`. Everything else in `PROMPT.txt` still
applies — the pinned sticky stage, the deterministic scroll engine writing CSS
custom properties and driving the 3D camera, the narrative enter/hold/exit
phases, the final interactive card rail, the accessibility, QA, and handoff
contract.

The scroll mechanic:

- Scroll progress `p` (0→1) drives a **camera flight along the course**,
  following a smoothed version of the GPX track around the massif —
  counter-clockwise, exactly as the race is run.
- The course line **draws itself progressively** as the camera advances, so at
  any point the runner's "story so far" is visible behind the camera.
- Checkpoint markers (Chamonix, Les Contamines, Courmayeur, Champex-Lac, …)
  rise from the terrain as the camera approaches them.
- Narrative panels are HTML overlays (per PROMPT.txt) keyed to course
  landmarks, not arbitrary scroll fractions — the timeline config should map
  each beat to a distance-along-course range.
- Subtle pointer parallax tilts the camera a few degrees; it never leaves the
  flight path.
- Lighting shifts across the flight from late-afternoon start light to dusk to
  night and back to morning — UTMB starts at ~17:45 and mid-pack runners see
  two nights. Keep it restrained: a tint/exposure shift, not a day/night toggle.

Reuse the existing Three.js terrain rendering and the project's "terrain
artifact" model (see CONTEXT.md — an immutable, preprocessed elevation grid
owned by an event bundle). Do not add GSAP, Lenis, React, or a second 3D
library. Do not fetch live terrain tiles at runtime.

## Goal

Primary message:

`One loop around Mont Blanc. Three countries, ~171 km, ~10,000 m of climbing — and everything you need to run, crew, or follow it, on one page.`

Desired user response:

`"I finally see the whole race." Then they open the full ultrainfo UTMB race guide.`

Final interaction or CTA:

`A card rail of the major checkpoints (distance, altitude, cutoff, crew access) ending in a primary CTA: "Open the full UTMB race guide" → the race's ultrainfo page.`

## Visual direction

- Overall style: `Editorial cartography — a premium topographic map come to life. Terrain reads as shaded relief with restrained hypsometric tinting; the course line is the single saturated element.`
- Mood: `Vast, calm, slightly reverent. The mountain is the hero; the UI whispers.`
- Time of day and lighting: `Starts golden late-afternoon (the 17:45 start), passes through blue-hour and night (headlamp-warm course line glowing against darkened terrain), returns to morning light for the finish.`
- Camera and lens character: `Helicopter documentary — long smooth dolly moves, gentle banking into turns, altitude breathing with the cols. Never a hard cut; never nauseating rotation.`
- Color palette: `Reuse ultrainfo's existing Tailwind design tokens for UI. Scene: desaturated slate/ice terrain, warm signal color for the course line and markers (match the app's accent token), off-white typography.`
- Display typeface: `Whatever display face the app already uses for race headings — inspect app/assets/tailwind/application.css and reuse; do not add a new font just for this page.`
- Interface typeface: `The app's existing body/UI face.`
- Styles to avoid: `Video-game HUD, neon glow, fake lens flares, gradient-heavy startup aesthetics, Google-Earth-style photorealism (we render artifacts, not satellite imagery).`

## Narrative beats

Beats are keyed to distance along the course (approximate km on the ~171 km
loop). Tune boundaries against the actual GPX arc lengths at implementation
time.

### Beat 1 — Hero (km 0, Chamonix)

- Headline: `One loop. Three countries. 171 kilometers.`
- Supporting copy: `The Ultra-Trail du Mont-Blanc circles the highest massif in Western Europe — Chamonix to Chamonix, through France, Italy, and Switzerland, with around 10,000 meters of climbing.`
- Visible visual layers: `High, wide establishing view of the full massif with the complete course loop faintly ghosted; Chamonix marker lit; title block over the valley.`
- Intended motion: `Slow push-in toward Chamonix as the title exits; the ghosted loop fades and the drawn-line-so-far mechanic takes over.`

### Beat 2 — First narrative (≈ km 30–50, Les Contamines → Col du Bonhomme)

- Headline: `The climbing starts in the dark.`
- Supporting copy: `The first night takes runners over the Col du Bonhomme at 2,329 m. From here on, the race is a rhythm of cols: climb, crest, descend, repeat — ten major ascents in all.`
- Facts or CTA: `~10,000 m total ascent · highest point Grand Col Ferret ~2,525 m · ~46.5 h overall cutoff`
- Intended transition: `Lighting has shifted to night; the course line glows headlamp-warm. Camera banks through the col as the panel holds, then descends toward Les Chapieux as it exits.`

### Beat 3 — World reveal (≈ km 60–80, Col de la Seigne → Courmayeur)

- Purpose: `The "clean panorama" beat: crossing into Italy. No text — let the crossing of the frontier col and the reveal of the Italian side of the massif land on its own.`
- Intended transition: `Camera crests the Col de la Seigne, the Italian Val Veny opens below, first morning light returns; a small country indicator ticks FR → IT.`

### Beat 4 — Second narrative (≈ km 100–125, Grand Col Ferret → Champex-Lac)

- Headline: `Crews make this race runnable.`
- Supporting copy: `Over the Grand Col Ferret into Switzerland, the race becomes a checkpoint-to-checkpoint negotiation: aid stations, cutoffs, drop bags, and the places a crew can actually reach you. ultrainfo lays all of it out on one page.`
- Facts or CTA: `Master checkpoint list · crew-access map layer · cutoff times per station`
- Intended transition: `Camera settles over Champex-Lac; panel exits as the flight resumes toward Trient and Vallorcine; second dusk begins.`

### Beat 5 — Final catalog (≈ km 125 → finish, plus the checkpoint rail)

- Catalog purpose: `A horizontal card rail of the major checkpoints around the loop — the practical spine of the race.`
- Card content: `Per checkpoint: name, km mark, altitude, cutoff time, crew access yes/no. Source the data from the ultrainfo master station list for the event bundle when it exists; otherwise hardcode the well-known set (Chamonix, Les Contamines, Les Chapieux, Courmayeur, Arnouvaz, La Fouly, Champex-Lac, Trient, Vallorcine, Chamonix) as a data-driven config and flag it in the handoff as pending real data.`
- Card action: `Each card scrolls/links to that checkpoint's section of the full race guide (or is inert and clearly non-interactive if the guide section does not exist yet — no fake links).`
- Final CTA: `"Open the full UTMB race guide" button; camera has completed the loop and holds a slowly breathing wide view of the massif with the full course line lit.`

## Assets

- Asset directory: `cinematic-build-brief/assets/`
- Asset manifest: `cinematic-build-brief/assets.json`
- Reference screencast: `None — the GPX and this brief are the reference. Follow the camera choreography described in the beats.`
- Reference screenshots: `None`
- Brand assets: `Use the app's existing logo/wordmark and design tokens`
- Fonts: `Existing app fonts only`

Key data asset: `assets/utmb-course.gpx` — 15,305 trackpoints with elevation,
bounds 45.6956–46.0585°N / 6.7067–7.1284°E, elevation 801–2,581 m.
**Provenance:** a runner's recorded trace of UTMB 2015 (VisuGPX,
https://www.visugpx.com/7rMGyMCjkT, 172.4 km). Good enough geometry for the
cinematic visual; it is NOT the current official course. Downsample it:
a simplified polyline (~2,000–3,000 pts) for the rendered line, a heavily
smoothed spline (~300 control points) for the camera path. Preprocess offline
into a committed artifact per the project's terrain-artifact conventions —
never parse the 1.9 MB GPX in the browser.

## Responsive requirements

- Desktop priority: `Primary experience — full flythrough`
- Mobile priority: `Must be excellent, not a stripped afterthought. Shorter scroll travel, reduced camera banking, larger type.`
- Mobile crop or composition notes: `Portrait framing should favor looking along the valley axis rather than wide massif views; keep narrative panels in the lower third clear of the notch/safe areas.`
- Required browsers: `Latest Safari, Chrome, Firefox, Edge; iOS Safari and Android Chrome`
- Minimum device expectations: `Smooth on an M-series MacBook and a mid-range phone from ~2023. Devices without WebGL (or that fail context creation) get the static-hero fallback described under Accessibility.`

## Accessibility

- Reduced-motion preference: `Genuine alternative, not a slowed flythrough: a static prerendered hero image of the massif with the full course line, followed by the narrative copy in normal document flow and a static SVG elevation profile of the course. All information and the checkpoint rail remain available.`
- Keyboard requirements: `Checkpoint rail fully keyboard-operable per PROMPT.txt; narrative content reachable and readable without a pointer; no scroll traps.`
- Image-description requirements: `The 3D canvas gets a concise aria description of the course; the elevation profile fallback gets meaningful alt text; decorative overlays empty alt.`
- Localization requirements: `English only for now; keep all copy in one place so a French pass is cheap later.`

## Performance

- Target initial transfer size: `≤ 1.5 MB before the terrain artifact streams in; show the composed hero (prerendered still) immediately and swap in the live scene when ready — no blank canvas, no spinner-first load.`
- Target total image transfer size: `Terrain artifact + preprocessed course data ≤ 5 MB on desktop, with a smaller mobile variant.`
- Required analytics or monitoring: `None new — keep the console clean and log nothing in production.`

## Constraints

- Dependencies that may be used: `Three.js (already in the import map), Stimulus, Turbo. Any pure-Ruby preprocessing in the existing pipeline style (bin/ or lib/tasks).`
- Dependencies that must not be added: `GSAP, Lenis, React/Vue/Svelte, mapbox/cesium/deck.gl, any Node build step, any runtime tile/API dependency.`
- Existing components that must be preserved: `Everything. This is a new landing/marketing page (e.g. a new route + controller); do not modify existing race pages, the terrain map components' public behavior, or the event-bundle pipeline beyond additive helpers.`
- Out-of-scope items: `Live race tracking, results, registration flows, CMS integration, other races' landing pages (though the scene config should be data-driven enough that a second race is mostly a new GPX + copy).`

## Acceptance criteria

- `Scrolling the page flies the camera around the full UTMB loop; scrolling back up reverses the flight deterministically with no pops or discontinuities.`
- `All five beats read cleanly at their checkpoints (per the QA checkpoint list in PROMPT.txt), with narrative text always legible against the terrain.`
- `prefers-reduced-motion and no-WebGL users get the complete content in normal flow with the static hero and elevation profile.`
- `The checkpoint card rail works with mouse, touch, and keyboard, and the final CTA links to the real race-guide route.`
- `Terrain and course data ship as preprocessed committed artifacts; no runtime fetches to third-party services; Lighthouse performance ≥ 85 on desktop for the landing page.`

## Notes

`Missing production assets to list in the handoff: (1) a Mont Blanc massif terrain artifact covering the GPX bounds — generate it with the existing Terrain Tiles DEM pipeline; use a placeholder low-res grid if blocked. (2) The current official UTMB GPX — the bundled 2015 trace must be swapped before launch; the preprocessing step should make that a one-command swap. (3) Real checkpoint/cutoff data from the event bundle once the UTMB bundle exists. Also verify quoted race facts (distance, ascent, cutoffs) against the official UTMB site at launch time — editions vary (~171–176 km, ~9,900–10,000 m).`

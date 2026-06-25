# ultrainfo

**Ultramarathon event info, made usable.**

The schedule, the course, the crew plan, and where to follow along — for races longer than a
marathon — pulled out of a dozen clunky race-website links and laid out plainly on one site.

Free, open source, no ads, no accounts, no upsell. Built by a single developer.

Live at **[ultrainfo.org](https://ultrainfo.org)** · starting with the **Western States 100**.

## Who it's for

Every page leads with *who you are*, because that decides what you need:

- **Runners** — schedule, cutoffs, lottery & registration, GPX course, what to expect.
- **Crews & pacers** — which aid stations allow crew, the crew-access map, parking, drop bags, ETA splits.
- **Followers** — live tracking, the best spots to watch, race-day schedule.

## Stack

- Ruby on Rails 8 — SQLite, Solid Queue / Cache / Cable
- Tailwind CSS v4 via `tailwindcss-rails` — global styles & design tokens live in `app/assets/tailwind/application.css`
- Hotwire (Turbo + Stimulus) with import maps — no Node build step
- Leaflet + OpenStreetMap + CARTO tiles for maps — no API keys, no cost
- Minitest for tests; RuboCop (omakase) + Brakeman for lint / security
- Deploys with Kamal (Hetzner)

## Local development

```bash
bin/setup    # install deps and prepare the database
bin/dev      # start the app + Tailwind watcher → http://localhost:3000
```

Useful commands:

```bash
bin/rails test   # run the test suite
bin/rubocop      # lint
bin/brakeman     # security scan
```

## Contributing

This is an open project and contributions are very welcome — open an issue or a PR.

**No money, ever.** ultrainfo will never charge, run ads, or sell anything. If it saved you a
headache and you want to say thanks, there's a **shoe fund** (a single developer goes through a
lot of trail shoes). Link coming soon.

## License

[MIT](LICENSE).

Maps © OpenStreetMap contributors · © CARTO · rendered with Leaflet.

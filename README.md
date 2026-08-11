# Ultrainfo

[![CI](https://github.com/turbothad/ultrainfo/actions/workflows/ci.yml/badge.svg)](https://github.com/turbothad/ultrainfo/actions/workflows/ci.yml)

Free, contributor-maintained race information for North American 100-mile ultras.

Ultrainfo brings the course, cutoffs, station passes, crew access, tracking,
results, and supporting sources into one public race record. The first complete
record is the Bighorn 100.

No ads. No accounts. No paywall.

## Getting started

The repository includes both `.ruby-version` and `mise.toml`. If you use
[mise](https://mise.jdx.dev/), run `mise install` before setup. Full development
requirements are listed in [CONTRIBUTING.md](CONTRIBUTING.md).

```bash
git clone https://github.com/turbothad/ultrainfo.git
cd ultrainfo
bin/setup --skip-server
bin/dev
```

Open [http://localhost:3000](http://localhost:3000).

This is a Rails application with import maps, so local development does not
require Node or a JavaScript build step.

## Race data

Race records live in `db/events/`. Each fact should be backed by traceable
source metadata. Organizer material can be evidence, but no single source is
automatically authoritative.

The importer reads a race YAML file, its GPX track, and an optional cached crew
route. Keep race-specific facts in those files instead of hard-coding them in
controllers or views.

## Contributing

Public contributions use GitHub:

- [Report a race-data correction or addition](https://github.com/turbothad/ultrainfo/issues/new?template=correction.yml)
- [Report a bug](https://github.com/turbothad/ultrainfo/issues/new?template=bug.yml)
- [Request a feature](https://github.com/turbothad/ultrainfo/issues/new?template=feature.yml)

Please open an issue before every pull request. Race-data changes must include
a source that another contributor can verify. See
[CONTRIBUTING.md](CONTRIBUTING.md) for the full workflow.

## Technology

- Ruby on Rails 8.1 with SQLite
- Hotwire and Stimulus
- Tailwind CSS 4
- Three.js terrain maps using public Terrain Tiles data
- Minitest, RuboCop, Brakeman, and import-map auditing

## License

Ultrainfo is available under the [MIT License](LICENSE). Third-party
attributions are recorded in [NOTICE.md](NOTICE.md).

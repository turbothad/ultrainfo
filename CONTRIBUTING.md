# Contributing to Ultrainfo

Ultrainfo is an open-source, contributor-maintained race-information project.
Contributions can improve race facts, source coverage, accessibility, product
behavior, tests, or documentation.

## Start with an issue

Choose the matching GitHub template:

- [Race correction or addition](https://github.com/turbothad/ultrainfo/issues/new?template=correction.yml)
- [Bug report](https://github.com/turbothad/ultrainfo/issues/new?template=bug.yml)
- [Feature request](https://github.com/turbothad/ultrainfo/issues/new?template=feature.yml)

Open an issue before starting any change. This prevents duplicate work and
gives maintainers a chance to confirm the intended scope. Every pull request
must link the issue it resolves.

Race-data issues must identify the race year, describe the proposed change,
and include a source another contributor can inspect. Personal recollection can
add context, but it does not replace traceable evidence.

## Set up the application

Ultrainfo requires Ruby 4.0.5, Bundler, and SQLite 3.

Fork the repository on GitHub, then clone your fork:

```bash
git clone https://github.com/YOUR-GITHUB-USERNAME/ultrainfo.git
cd ultrainfo
git remote add upstream https://github.com/turbothad/ultrainfo.git
bin/setup --skip-server
bin/dev
```

The application runs at [http://localhost:3000](http://localhost:3000).

## Make a change

1. Create a focused branch from the latest `upstream/main`.
2. Keep the change scoped to one issue.
3. Add or update tests when behavior changes.
4. Keep race-specific facts in `db/events/` with source metadata.
5. Never commit credentials, API keys, private race communications, or personal
   information.

For user-interface changes, include before-and-after screenshots at desktop and
mobile widths. For race-data changes, list every source used to verify the new
facts.

With the development server running, capture full-page desktop and mobile
screenshots with:

```bash
bundle exec ruby script/shot.rb http://localhost:3000 tmp/landing-desktop.png 4 1280
bundle exec ruby script/shot.rb http://localhost:3000 tmp/landing-mobile.png 4 390
```

The script uses an installed Chrome through Selenium Manager. Set
`ULTRAINFO_CHROME_BIN` to an executable path when Chrome is installed in a
nonstandard location or when using another Chromium-based browser.

## Verify the change

Run:

```bash
bin/rails test
bin/rubocop
bin/brakeman --no-pager
bin/importmap audit
```

Run `bin/rails test:system` when changing navigation or browser interactions.

## Open a pull request

Push your branch and open a pull request against `main`. Complete the pull
request template, link the issue with `Closes #<issue-number>`, and include the
verification you ran.

Pull requests should be small enough to review directly. If a change needs a
large refactor, split it into independently useful steps.

By contributing, you agree that your contribution is licensed under the
project's [MIT License](LICENSE).

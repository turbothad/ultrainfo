# Production releases

Ultrainfo uses Semantic Versioning tags for human release identity and the
full Git commit SHA for immutable deployment identity. For example,
`v0.1.0` identifies one annotated Git tag, while Kamal deploys the image tagged
with that tag's full commit SHA. Release tags are never moved or reused.

Before `v1.0.0`, increment MINOR for a release that may change public behavior
or interfaces and PATCH for a backward-compatible correction. After `v1.0.0`,
use the standard MAJOR/MINOR/PATCH compatibility rules.

## Release gates

A production release must come from a clean `main` checkout that exactly
matches `origin/main` and has a successful `ci.yml` run. Prepare the release:

```bash
bin/release prepare v0.1.0
```

This creates and pushes an annotated tag and opens a draft GitHub Release. It
does not deploy production.

Resolve `KAMAL_REGISTRY_PASSWORD` and `RAILS_MASTER_KEY` from their named
1Password fields into the process environment, then deploy:

```bash
op run --env-file=.env.production -- bin/release deploy v0.1.0
```

For the pre-cutover deployment only, route Kamal Proxy through the staging DNS
record:

```bash
ULTRAINFO_HOST=origin.ultrainfo.org \
  op run --env-file=.env.production -- bin/release deploy v0.1.0
```

After the public smoke check passes, publish the draft GitHub Release. The
GitHub Release is a public record, not the deployment trigger.

## Rollback

List retained application containers, select the prior full commit SHA, and
roll the application back without changing Git tags:

```bash
bin/kamal app containers -q
bin/kamal rollback FULL_COMMIT_SHA
```

Schema migrations remain forward-only; rollback changes the application image,
not the database schema.

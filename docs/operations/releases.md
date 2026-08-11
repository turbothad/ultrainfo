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

Copy the local secrets template once, then select the 1Password field that
contains a GHCR token with package write access:

```bash
cp .kamal/secrets.example .kamal/secrets
export OP_VAULT="your-vault"
export OP_GHCR_ITEM="your-ghcr-item"
export OP_GHCR_FIELD="token"
```

As in Tradia, an explicit `KAMAL_REGISTRY_PASSWORD` or `GITHUB_TOKEN` takes
precedence over 1Password. The ignored `.kamal/secrets` file also reads the
existing ignored `config/master.key`, so no second Rails secret-export step is
needed. The server already has Docker and the non-root deployment user, so
deploy directly through Kamal rather than running its server bootstrap again.

For the first deployment, route Kamal Proxy through the staging DNS record:

```bash
ULTRAINFO_HOST=origin.ultrainfo.org \
  bin/release deploy v0.1.0
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

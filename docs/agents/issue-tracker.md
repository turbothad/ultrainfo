# Work tracking

Ultrainfo has separate internal and public contribution lanes. Do not mirror an
issue between them unless the user explicitly asks.

## Internal work: Linear

Roadmap, Wayfinder, and agent-created implementation issues live in Linear —
personal workspace, team **Turbothad** (`TUR`), project **ultrainfo**.

Use the Linear MCP server. If it is unavailable, report the missing access; do
not silently create a local issue file or public GitHub issue.

- Create internal work in team Turbothad and project ultrainfo.
- Apply the triage labels documented in `triage-labels.md`.
- Reference internal work by its Linear identifier, such as `TUR-123`.
- Mark completed work Done; mark rejected work Canceled and apply `wontfix`.

Wayfinder maps are parent issues with `wayfinder:map`; decision tickets are
sub-issues with the appropriate `wayfinder:<type>` label and native blocking
relations.

`TUR-29` is the current production-readiness roadmap. It preserves the open
runtime, deployment, publication, and explicitly deferred post-MVP work that
previously lived in root TODO files.

## Public contributions: GitHub

Community race corrections, bug reports, and feature requests use the issue
templates under `.github/ISSUE_TEMPLATE/`. Pull requests are the public delivery
and review surface.

- Race-data issues must include the race year and traceable sources.
- Every pull request must link a public issue with `Closes #...`.
- Do not use pull requests as issue descriptions or roadmap placeholders.
- Do not copy private Linear discussion into a public issue or pull request.
- Do not publish a security-reporting link until GitHub Private Vulnerability
  Reporting or another monitored private channel is enabled.

Agents should work on a public GitHub issue only when the user places that issue
in scope. New internal planning remains in Linear by default.

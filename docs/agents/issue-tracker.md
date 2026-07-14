# Issue tracker: Linear

Issues and PRDs for this repo live in Linear — team **Turbothad** (key
**TUR**), project **ultrainfo**.

## Access

Use the Linear MCP server (`https://mcp.linear.app/mcp`, configured in this
project's Claude Code config). Load its tools with ToolSearch (query "linear").
If the tools aren't available, the user hasn't authenticated yet — ask them to
run `/mcp` and log in to Linear. Do not fall back to GitHub Issues or local
files.

## Conventions

- **Team**: Turbothad. **Project**: ultrainfo. File every issue for this repo
  there.
- **Create an issue**: Linear create-issue tool, with team, project, and any
  triage labels from `triage-labels.md`. Put the full body in the description
  (markdown supported).
- **Read / list / comment / label**: the corresponding Linear MCP tools.
- **Close**: move the issue to the **Done** status. For wontfix, move it to
  **Canceled** (and apply the `wontfix` label so triage state stays legible).
- Reference issues by their Linear identifier (e.g. `TRA-123`), not by URL.

## Pull requests as a triage surface

Not applicable — PRs are not a request surface for this repo. Triage reads
Linear issues only.

## When a skill says "publish to the issue tracker"

Create a Linear issue in team Turbothad, project ultrainfo.

## When a skill says "fetch the relevant ticket"

Fetch the Linear issue (including its comments) by identifier via the MCP
tools.

## Wayfinding operations

Used by `/wayfinder`. The **map** is a parent issue; tickets are its
sub-issues.

- **Map**: a Linear issue labelled `wayfinder:map`, holding the Notes /
  Decisions-so-far / Fog body.
- **Child ticket**: a Linear sub-issue of the map, labelled `wayfinder:<type>`
  (`research`/`prototype`/`grilling`/`task`). Once claimed, assign it to the
  driving dev.
- **Blocking**: Linear's native "blocked by" relation. A ticket is unblocked
  when every blocker is Done or Canceled.
- **Frontier query**: the map's open sub-issues with no open blocker and no
  assignee; first in map order wins.
- **Claim**: assign the issue to yourself. **Resolve**: comment the answer,
  mark Done, and append a context pointer to the map's Decisions-so-far.

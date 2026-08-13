# Claude Code goal workflow for Run100s onboarding

Verified against official Claude Code documentation on 2026-08-13. This note
separates documented Claude Code behavior from recommendations for Ultrainfo.
It does not treat third-party skill documentation as Anthropic documentation.

## Bottom line

Claude Code now has a built-in **`/goal` command**. It is not a bundled
"goals skill." `/goal` keeps the current session working across turns until a
separate model judges a completion condition satisfied. The repeatable
Ultrainfo procedure should live in a project skill, while `/goal` supplies the
short, measurable end condition.

For this project, use three layers:

1. A project skill defines the one-race workflow and the mandatory order:
   implement one race, run the selected Matt Pocock review, remediate it, run
   Claude Code's `/code-review`, remediate it, deploy, verify the deployment,
   then and only then select the next race.
2. The repository-backed `db/events/onboarding/run100s-queue.yml` records each
   race's durable state and evidence. Claude Code's task list can mirror this
   for session coordination, but should not be the sole source of truth.
3. One `/goal` condition keeps the session moving until every captured
   candidate has a terminal state and every completed candidate has review and
   verified-deployment evidence.

Do not use one giant `/goal` prompt as the whole specification. A goal condition
is limited to 4,000 characters, and its evaluator can only judge evidence that
Claude has surfaced in the conversation; it cannot read the queue, inspect
files, or run tests itself.

## Documented Claude Code facts

### Goals

- [`/goal`](https://code.claude.com/docs/en/goal) is a built-in command that
  starts another turn when the previous turn ends until a small, fast model
  confirms the completion condition. Only one goal can be active per session.
- A condition should state one measurable end state, the check that proves it,
  and important constraints. It may contain at most 4,000 characters and may
  include a turn or time bound.
- The evaluator does not call tools or read files. It judges only the
  conversation. Claude must therefore run the checks and surface their results.
- An active goal is restored by `--resume` or `--continue`, although its elapsed
  time, turn count, and token baseline reset. A cleared or achieved goal is not
  restored.
- `/goal` works in non-interactive mode. `claude -p "/goal ..."` runs the loop
  to completion in one invocation; `--output-format stream-json --verbose`
  exposes progress instead of remaining silent until completion.
- `/goal` does not change permissions. Anthropic documents pairing it with
  auto mode for unattended turns. It is unavailable when workspace trust has
  not been accepted or hooks are disabled/restricted by the relevant settings.
- `/goal` is implemented as a session-scoped prompt-based Stop hook. A custom
  Stop hook is the alternative when a durable, settings-level continuation
  policy or a deterministic script is needed.

### Skills and reviews

- [Skills](https://code.claude.com/docs/en/skills) are reusable procedures
  stored in `SKILL.md`; project skills live under `.claude/skills/`. Claude can
  load a skill when relevant or it can be invoked by name.
- Claude Code includes a bundled
  [`/code-review`](https://code.claude.com/docs/en/commands) skill. It reviews
  the current diff, branch, path, or PR. `--fix` may apply findings, while the
  default is review-only. `/review` is an alias.
- As of Claude Code v2.1.218, `/code-review` runs as a forked subagent. A forked
  skill ends inline skill stacking, so the Matt review and `/code-review` should
  be separate, awaited stages rather than commands stacked in one prompt.
- A third-party Matt Pocock skill is not defined by Anthropic's documentation.
  In this checkout, the enabled `mattpocock-skills` plugin exposes the review as
  `/mattpocock-skills:code-review <fixed-point>`. It checks repository standards
  and spec compliance, which is distinct from Claude Code's bundled bug-finding
  `/code-review`. The project skill must use the namespaced command so the two
  gates cannot be confused.
- `disable-model-invocation: true` makes a skill user-only. Anthropic uses
  deployment as the example because of its side effects. An unattended goal
  cannot autonomously invoke such a deploy skill; either the user must invoke
  it each time or the project must deliberately expose a narrowly scoped,
  model-invocable deployment procedure after authorizing the exact target.
- An invoked skill's instructions stay in conversation, but auto-compaction
  preserves invoked skills only within documented per-skill and combined token
  budgets. Critical invariants should therefore also be represented by machine
  checks or hooks, not solely by early conversational instructions.

### Tasks, sessions, and subagents

- Claude Code's [task list](https://code.claude.com/docs/en/interactive-mode#task-list)
  persists across context compaction. Setting `CLAUDE_CODE_TASK_LIST_ID` uses a
  named task directory under `~/.claude/tasks/` that sessions can share.
- The task tools can create, retrieve, list, and update task status,
  dependencies, and details. This is useful for coordinating the active race
  and its ordered gates, but the task list is Claude's local checklist, not a
  versioned project record.
- [`--resume` and `--continue`](https://code.claude.com/docs/en/how-claude-code-works)
  append to the same session. Instructions from early conversation can be lost
  during compaction, so Anthropic recommends persistent project rules rather
  than relying on conversation history.
- [Subagents](https://code.claude.com/docs/en/sub-agents) have isolated context
  and can be constrained by tool allowlists/denylists, preloaded skills, model,
  maximum turns, and optional worktree isolation. Their result returns to the
  parent; background subagents still obey permission handling. A read-only
  reviewer should therefore receive only read/search/test tools unless fixes
  are explicitly requested.

### Hooks, workflows, headless mode, and permissions

- [Hooks](https://code.claude.com/docs/en/hooks-guide) run on lifecycle events,
  including tool use, subagent completion, task completion, and session Stop.
  Command hooks are the documented production choice for deterministic checks;
  agent hooks are experimental. A hook can tighten a policy even in permissive
  modes, but cannot loosen an applicable deny rule.
- Post-tool hooks cannot undo an action. A deployment-order guarantee must be a
  pre-deploy check or a task-transition check, not a check that runs after the
  deployment command.
- [Dynamic workflows](https://code.claude.com/docs/en/workflows) codify
  orchestration in a JavaScript runtime and scale to many subagents, but they
  accept no mid-run user input, have no direct filesystem or shell access, and
  resume only within the same Claude Code session. If Claude Code exits, a run
  starts fresh. They are useful for bounded per-race research or audits, not as
  the durable authority for the entire research-review-deploy queue.
- [Non-interactive mode](https://code.claude.com/docs/en/headless) supports
  structured JSON/streaming output, explicit allowed tools, permission modes,
  user-invoked skills, and session IDs for later resume. In a plain `-p` run
  there is nobody to answer a new permission prompt, so every needed command or
  service must be covered by prior rules or fail closed.
- [Auto mode](https://code.claude.com/docs/en/auto-mode-config) removes routine
  permission prompts but still applies explicit ask/deny rules and its safety
  classifier. Production deploys are among its default soft-deny concerns.
  Explicit, exact user intent may clear a soft block; a `permissions.deny` rule
  cannot be overridden. The deployment target and scope therefore need to be
  named before attempting an unattended deployment loop.

## Recommended Ultrainfo state machine

Define one "bit of work" as **one race candidate**. Use a main-only serial
workflow: begin each iteration from clean local `main` equal to `origin/main`,
record that SHA as the iteration fixed point, and commit the candidate directly
on local `main`. Parallelize bounded source research or independent read-only
audits inside that candidate, but keep all repository mutation, review, push,
release, and deployment sequential. Do not create feature branches or pull
requests for this queue.

Use this ordered state machine for each race:

```text
queued
  -> researching
  -> implementing
  -> implementation_verified
  -> matt_review_running
  -> matt_review_clean
  -> claude_code_review_running
  -> claude_code_review_clean
  -> release_deploy_running
  -> deployed_smoke_verified
  -> deployed
```

Required transition rules:

1. The Matt Pocock review operates on the complete candidate diff. Resolve or
   explicitly classify every finding before recording `matt_review_clean`.
2. Invoke `/code-review` only after the Matt stage is clean. If either review
   causes a code change, rerun the affected tests, commit the change, and
   restart the two-review sequence so both reviews identify the final commit.
   Do not loop a subjective review indefinitely: one confirmation pass is the
   default, and repeated non-convergence is a recorded blocker.
3. Release/deployment may begin only when both clean-review records identify
   the exact commit being deployed. A later commit invalidates both review
   gates.
4. Mark `deployed_smoke_verified` only from a target-specific success check,
   such as a release ID plus a smoke or health check against the deployed
   version. Command exit 0 alone is not enough unless the deployment system
   contract says it is.
5. Select the next race only after the current race is `deployed`, or after it
   receives an explicit non-deploying terminal state: `already_active`,
   `duplicate`, `not_eligible`, or `blocked_needs_human`.
6. A failed review or deployment must not advance the queue. Record the exact
   failure and either repair it in the same race iteration or stop according to
   the goal's repeated-failure condition.

The repository ledger should record at least the race identifier, engine
version, source-check date, current state, commit SHA, Matt review invocation
and result, Claude `/code-review` invocation and result, deployment target,
deployment/release ID, deployed commit SHA, verification result, timestamps,
and blocker. The named Claude task list may mirror these phases, but the ledger
is what makes the loop auditable and resumable outside one local Claude setup.

## Recommended shape of the eventual Claude setup

- `.claude/skills/run100s-onboarding/SKILL.md`: the repeatable procedure and
  stage transitions. In this checkout, the Matt gate is
  `/mattpocock-skills:code-review <iteration-base-sha>` and the second gate is
  Claude Code's bundled `/code-review`.
- The checked-in `db/events/onboarding/run100s-queue.yml` snapshot plus
  `bin/validate-run100s-queue`, which checks identity, ordering, statuses,
  single-candidate activity, and terminal evidence requirements.
- Optional `PreToolUse` or task-transition command hooks that consult that
  validator before the exact deploy command and before queue advancement.
- One short `/goal` condition, under 4,000 characters, that names the terminal
  queue condition, the validator command, the stop bounds, and the requirement
  that Claude surface final validator/review/deployment evidence in its output.
- A named task list for interactive visibility, for example by launching with
  `CLAUDE_CODE_TASK_LIST_ID=ultrainfo-run100s claude`.

Ultrainfo's local release contract supplies the deployment details that
Anthropic's documentation cannot: release only clean, CI-green `main` equal to
`origin/main`; create and check an immutable SemVer tag with `bin/release
prepare` and `bin/release check`; deploy the tag to the current production host
with `ULTRAINFO_HOST=ultrainfo.org bin/release deploy`; then require both
`https://ultrainfo.org/up` and the new race page to pass public smoke checks
before publishing the draft release and advancing the queue. The production
health endpoint returned HTTP 200 when checked on 2026-08-13. Any missing
credential, failed CI run, release failure, or smoke failure blocks the current
iteration and must not advance the queue.

## Paste-ready goal condition

This condition references the checked-in workflow and frozen queue directly.
It deliberately describes the terminal state rather than repeating the whole
procedure:

```text
/goal Process `db/events/onboarding/run100s-queue.yml` by following its agent_contract and the workflow in `docs/research/claude-code-goal-workflow.md`. Run `bin/validate-run100s-queue` before selecting work and after every queue update. One race candidate is one iteration. Use only a main-only serial workflow: do not create feature branches or pull requests. Run bounded read-only source research in parallel when useful, but keep all repository mutation, review, push, release, and deployment sequential, and never start the next candidate until the current candidate is in a recorded terminal state.

At the start of every eligible candidate, require a clean local `main` whose HEAD equals `origin/main`, and record that HEAD as `<iteration-base-sha>`. Use Run100s only for discovery and current first-party race sources for publishable facts. Implement through the shared race engine, keep uncertainty and source-check dates visible, run the relevant tests, and make traceable commits directly on local `main`. Then run `/mattpocock-skills:code-review <iteration-base-sha>` and resolve or explicitly classify every actionable standards/spec finding. After that stage is accepted, run Claude Code's bundled `/code-review` against the same fixed point and resolve every actionable bug finding. Both reviews must identify the same final commit. If a review causes a code change, rerun tests, commit, and restart the two-review sequence. Stop and record a blocker instead of looping after the same review failure repeats three times.

Only after both review gates pass for the final local-main commit: push `main` to `origin`, verify `origin/main` equals that exact SHA, and wait for successful ci.yml on it. Then select the next valid SemVer under docs/operations/releases.md, run `bin/release prepare <version>` and `bin/release check <version>`, deploy with `ULTRAINFO_HOST=ultrainfo.org bin/release deploy <version>`, verify the tag and deployed revision, require HTTP success from `https://ultrainfo.org/up` and the deployed race page, and publish the draft GitHub release. A failed push, CI, permission, credential, release, deploy, revision, or smoke check blocks the current race and forbids queue advancement.

The goal is achieved only when the frozen queue has no non-terminal candidates, every completed candidate's ledger entry contains checked first-party sources, final commit SHA, passing tests, Matt review evidence, bundled code-review evidence, release tag, deployed SHA, and successful public smoke evidence, and `bin/validate-run100s-queue` passes. Surface the validator summary and the final candidate counts in the transcript so the goal evaluator can judge them. Do not claim success from plans, task status, command exit alone, or evidence that is only stored in files.
```

This is production deployment authority only for an iteration that passes every
named gate. It is not authority to bypass permissions, CI, source uncertainty,
or the repository's release contract.

## Official sources

- [Keep Claude working toward a goal](https://code.claude.com/docs/en/goal)
- [Extend Claude with skills](https://code.claude.com/docs/en/skills)
- [Commands reference](https://code.claude.com/docs/en/commands)
- [Interactive task list](https://code.claude.com/docs/en/interactive-mode#task-list)
- [Tools reference](https://code.claude.com/docs/en/tools-reference)
- [Create custom subagents](https://code.claude.com/docs/en/sub-agents)
- [Automate actions with hooks](https://code.claude.com/docs/en/hooks-guide)
- [Orchestrate subagents with dynamic workflows](https://code.claude.com/docs/en/workflows)
- [Run Claude Code programmatically](https://code.claude.com/docs/en/headless)
- [Configure auto mode](https://code.claude.com/docs/en/auto-mode-config)
- [How Claude Code works](https://code.claude.com/docs/en/how-claude-code-works)

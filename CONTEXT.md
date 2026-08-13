# ultrainfo

A free, no-account, contributor-maintained source of truth for North American
100-mile races. Each Race record evolves from traceable evidence and
corrections; no organizer or other single source is automatically authoritative.

## Language

**Race**:
One named 100-mile race in a specific year (e.g. the 2026 Bighorn 100). The
unit a race page describes.
_Avoid_: event, edition

**Race record**:
Ultrainfo's current canonical account of one Race, synthesized from traceable
evidence and contributor corrections. It may correct or disagree with an
organizer and evolves as stronger evidence arrives.
_Avoid_: organizer record, official record

**Source**:
Traceable evidence supporting a Race fact, such as organizer material,
registration pages, maps, published results, or attributable research. A
source supplies evidence; its identity alone does not make it authoritative.
_Avoid_: official source (as a guarantee of correctness)

**Contributor**:
A person who submits evidence, a correction, or an addition to a Race record.
_Avoid_: editor, administrator

**Race page**:
The single public reference page for a Race, serving runners, crew and pacers,
and followers at once.
_Avoid_: event page, race profile

**Aid station**:
A physical place on the course where aid is offered. Bighorn has 13.
_Avoid_: checkpoint

**Station pass**:
One crossing of an aid station at a specific mile, with its own direction,
cutoff, crew access, drop-bag, pacer, and medical facts. Out-and-back courses
cross most stations twice, so passes — not stations — are what runners and
crews plan against. Bighorn has 22.
_Avoid_: stop, visit, aid station (when the crossing is meant)

**Direction**:
The leg of the course a station pass belongs to: Start, Outbound, Turnaround,
Inbound, or Finish.

**Cutoff**:
The time by which a runner must leave a station pass (or finish), expressed
as both clock time (wall clock) and elapsed time (hours since the start).
_Avoid_: time limit, deadline

**Runner**:
Someone entered in (or committed to entering) a Race, planning their own
logistics.
_Avoid_: athlete, participant, entrant

**Crew**:
The people supporting a runner from the roads, driving between crew-accessible
station passes.
_Avoid_: support team

**Pacer**:
A companion runner allowed to accompany a runner from designated station
passes onward, per the Race's pacer rules.

**Follower**:
Someone following a Race remotely — family and friends watching from home.
_Avoid_: spectator, fan

**Crew route**:
The driving route connecting the start, crew-accessible station passes, and
the finish, with total distance and drive time. Distinct from the course.
_Avoid_: course (for driving), drive course

**Verification status**:
How well a fact is backed by source metadata: verified, warning, or
unverified. Uncertain facts stay visible but clearly flagged, never presented
as certain. A last-verified date records when that section or fact was most
recently checked against its cited evidence; it is not a promise that the Race
will not change afterward.
_Avoid_: confidence, trust level

**Event bundle**:
The version-controlled, self-contained inputs and generated artifacts required
to publish one Race. It is the canonical production state.
_Avoid_: seed data, database backup

**Active event catalog**:
The version-controlled list of event bundles intended to be published.
_Avoid_: seed glob, database contents

**Published race**:
A fully validated event bundle made available as one atomic runtime snapshot.
A partial import is not a published Race.
_Avoid_: seeded race, live seed

**Terrain artifact**:
An immutable, preprocessed elevation grid owned and referenced by an event
bundle.
_Avoid_: live terrain tiles, terrain cache

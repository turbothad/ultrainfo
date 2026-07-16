# ultrainfo

ultrainfo turns race-source material into a complete, trustworthy race guide.

## Language

**Event bundle**:
The version-controlled, self-contained inputs and generated artifacts required to publish one race. It is the canonical production state.
_Avoid_: Seed data, database backup

**Active event catalog**:
The version-controlled list of event bundles intended to be published.
_Avoid_: Seed glob, database contents

**Published race**:
A fully validated event bundle made available as one atomic runtime snapshot. A partial import is not a published race.
_Avoid_: Seeded race, live seed

**Terrain artifact**:
An immutable, preprocessed elevation grid owned and referenced by an event bundle.
_Avoid_: Live terrain tiles, terrain cache

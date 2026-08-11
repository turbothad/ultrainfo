# Keep the race-record schema lean until repeated races demand normalization

Ultrainfo launches with one Race record and its Station passes. Early planning
considered separate models for Race years, sources, links, schedules, routes, and
other race material. That design would encode guesses from a single example and
make each new fact cross several interfaces before the product has demonstrated
that those interfaces are stable.

## Decision

Keep `Race` and `AidStation` as the primary persisted models. Store sourced
race-specific input under `db/events/`, including compact JSON metadata where
structure is still evolving. Import those bundles into a rebuildable SQLite
projection.

Add a normalized model only after repeated races or years demonstrate a stable
concept with behavior that cannot remain local to the existing models or files
under `db/events/`. A hypothetical future requirement is not sufficient.

## Considered options

- **Normalize the full anticipated catalog now** (rejected): creates migration,
  validation, and contributor overhead around concepts proven by only one Race.
- **Store every fact as unstructured JSON** (rejected): hides stable Race and
  Station-pass behavior from Rails and weakens validation.
- **Keep one hand-authored Bighorn implementation** (rejected): prevents the
  next Race from using the same importer and public interface.

## Consequences

- A second Race should be added through data under `db/events/` before changing
  the schema.
- Source metadata can evolve without creating a premature source graph.
- Some repeated metadata is acceptable until repetition identifies the correct
  normalized boundary.
- The database remains a projection of version-controlled race material rather
  than the only copy of the record.

# ADR-0008: Use golang-migrate for database migrations

## Status

Accepted

## Context

ADR-0002 requires versioned SQL migrations but did not choose a tool. `CLAUDE.md` requires migrations to be small, ordered, reversible when safe, explicit (never applied automatically in shared environments), and runnable locally without extra host dependencies.

## Decision

Use **golang-migrate** (`migrate/migrate`, pinned image tag) with plain SQL files in `apps/api/migrations/`, named `NNNNNN_description.up.sql` / `NNNNNN_description.down.sql` (sequential numbering).

Migrations run only through explicit commands, never on API startup:

```bash
make migrate          # apply pending
make migrate-down     # revert the latest one
make migrate-status   # current version
make migrate-create name=create_species
```

Locally the tool runs as the `migrate` Compose service (profile `tools`), so no host installation is required. History is stored in the `schema_migrations` table.

## Consequences

Positive:

* plain SQL, readable by reviewers and directly usable as `sqlc` schema input;
* explicit up/down pairs make rollback a reviewed decision;
* the same binary/image can run in CI and, later, as a one-off ECS task on AWS;
* no Go code dependency in the API binary.

Negative:

* sequential numbering can collide on parallel branches; the second branch must renumber before merging;
* a failed migration leaves the version `dirty` and requires a manual `migrate force <version>` after fixing the database.

## Alternatives Considered

* **goose** — also suitable; Go-function migrations are unnecessary here, and golang-migrate's pure-SQL model is simpler.
* **Atlas** — declarative schema diffing is powerful but adds a heavier tool and workflow than this phase needs.
* **Migrations embedded and run by the API at startup** — rejected; `CLAUDE.md` forbids automatic migrations in shared environments.

## Related Decisions

* [ADR-0002](0002-use-postgresql-and-sqlc.md) — PostgreSQL and sqlc.

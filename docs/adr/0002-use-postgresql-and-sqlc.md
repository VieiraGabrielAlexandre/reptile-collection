# ADR-0002: Use PostgreSQL and sqlc

## Status

Accepted

## Context

The platform needs a relational system of record for species, taxonomy, articles, users, and roles, with strong data-integrity guarantees (constraints, foreign keys, uniqueness) and support for full-text search without adding a separate search engine. The backend also needs type-safe, reviewable database access without the indirection and runtime surprises of a full ORM.

## Decision

Use **PostgreSQL** as the sole system of record, with versioned SQL migrations, explicit constraints and indexes, and parameterized queries. Use **sqlc** to generate typed Go code from hand-written SQL queries, rather than adopting an ORM as the default data-access strategy.

## Consequences

Positive:

* strong data-integrity guarantees enforced at the database level, not only in application code;
* SQL remains explicit, reviewable, and close to actual query plans;
* PostgreSQL Full Text Search covers the initial search requirement without a separate Elasticsearch/OpenSearch deployment;
* `sqlc`-generated code is type-safe and compiles against the real schema.

Negative:

* every query requires hand-written SQL and a `sqlc generate` step, which is more upfront work than an ORM's automatic query building;
* schema changes require careful, explicit migrations rather than implicit model syncing.

## Alternatives Considered

* **A general-purpose ORM** — rejected as the default strategy; `CLAUDE.md` explicitly disallows it, preferring explicit SQL and constraints.
* **A NoSQL document store** — rejected; the domain (species, taxonomy, articles, users, roles) is relational with meaningful constraints and joins.
* **Elasticsearch/OpenSearch for search** — deferred; PostgreSQL Full Text Search is sufficient for the initial phase and avoids operating a second data store.

## Related Decisions

* [ADR-0006](0006-use-structured-article-content.md) — structured article content is stored as PostgreSQL JSONB with an application-owned schema.

# ADR-0006: Use Structured, Block-Based Article Content

## Status

Accepted

## Context

Article content needs to be safe (no arbitrary HTML), versionable, and renderable consistently across preview and public pages, while still supporting a rich authoring experience. Storing raw HTML or unvalidated rich-text editor output would create sanitization, rendering-safety, and long-term migration risks.

## Decision

Store article content as an explicit, application-owned, versioned document composed of an ordered list of typed **content blocks** (e.g. `paragraph`, `heading`, `image`, `quote`, `curiosity`, `reference`), persisted as PostgreSQL JSONB. A rich-text editor (TipTap) may be used for authoring, but the persisted contract is the application's own block schema, not raw editor state. The public renderer uses an explicit registry mapping known block types to renderers; unknown block types fail safely rather than executing arbitrary markup.

## Consequences

Positive:

* content is validated on both the frontend (Zod) and backend independently, rather than trusting client-side validation alone;
* public rendering is safe by construction — only known, validated block types are rendered;
* the schema can evolve via an explicit document version and migration strategy without silently reinterpreting old content.

Negative:

* every new block type requires coordinated schema, editor, renderer, validation, and test work across frontend and backend;
* mapping the chosen editor's internal state to the block schema adds an explicit translation layer instead of persisting editor output directly.

## Alternatives Considered

* **Persisting raw HTML** — rejected; `CLAUDE.md` explicitly prohibits storing unsanitized user-provided HTML.
* **Persisting raw TipTap JSON as the permanent contract** — rejected as the default; acceptable only if the schema is tightly controlled and application-owned, which is effectively the block-based approach with an extra translation step.

## Related Decisions

* [ADR-0002](0002-use-postgresql-and-sqlc.md) — structured content is stored in PostgreSQL JSONB.

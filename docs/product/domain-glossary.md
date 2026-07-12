# Domain Glossary

Canonical terms for the reptile knowledge platform. Each term has one preferred definition and one preferred spelling. Do not use alternative names for the same concept elsewhere in the codebase or documentation.

## Species

A biological species or subspecies documented by the platform (e.g. `Boa constrictor`). Use **species** as both the singular and plural English noun. Do not use "specie" as a singular.

## Taxon / Taxonomy

The scientific classification hierarchy (class, order, suborder, family, genus, species, subspecies). Taxonomy is a scientific concept and must never be confused with an **editorial group**.

## Taxonomic Rank

A single level within the taxonomy hierarchy (e.g. `genus`, `family`).

## Scientific Name

The canonical Latin binomial (or trinomial) name of a taxon, stored separately from common names, rendered in italics, never translated.

## Common Name

A human-readable name for a species, which may vary by language and region. A species may have multiple common names with one preferred name per locale.

## Editorial Group

A human-friendly, non-taxonomic navigation category (e.g. "snakes", "turtles and tortoises"). Editorial groups exist for reader comprehension and must never be presented as taxonomic ranks.

## Article

An editorial publication (narrative, educational, or comparative) that may reference one or more species. Independent from species pages.

## Content Block

A single structured, typed, validated unit of article content (e.g. `paragraph`, `heading`, `image`). Article content is composed of an ordered list of content blocks, not raw HTML.

## Reference

A citable source (peer-reviewed article, book, institutional database, etc.) supporting a factual or scientific claim made on a species page or article.

## Conservation Assessment

A conservation status issued by a named authority (e.g. IUCN) at a specific date. Conservation status is never treated as a timeless, sourceless fact.

## Media Asset

An image, video, illustration, map, or diagram with required metadata (alt text, caption, credit, source, license). A media asset is not part of taxonomy.

## Activity Event

A recorded user or system action (e.g. `article_viewed`) that forms the foundation for future observability and gamification. Not implemented before its corresponding phase.

## Member / Editor / Administrator

The initial application roles. A **visitor** is an unauthenticated user and is typically not a persisted role assignment.

## LocalStack

The local AWS-service emulator used in the local environment. Never used to emulate PostgreSQL.

## Keycloak

The identity provider used in the local environment for authentication. Replaced by **Cognito** in the future AWS environment; the application must not couple domain code directly to either provider.

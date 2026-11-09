# Seed data

`make seed` applies every `*.sql` file in this directory, in lexical order
(`001_taxonomy.sql`, `002_species.sql`, ...), against the local PostgreSQL
container.

Rules:

* local development data only — never production data or real personal data;
* idempotent (`INSERT ... ON CONFLICT DO NOTHING`), so `make seed` can run repeatedly;
* run after `make migrate`, since seeds depend on the current schema.

Phase 0 has no domain tables, so there are no seed files yet. The first seeds
(taxonomy, species, articles) arrive with Phase 1.

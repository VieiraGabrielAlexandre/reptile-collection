# Phase 0 — Foundation

## Status

In progress

## Objective

Establish a reproducible local foundation for the reptile knowledge platform: repository structure, Claude Code governance, documentation baseline, minimal Go backend, minimal React frontend, PostgreSQL, Redis, LocalStack, Keycloak, Mailpit, initial Terraform structure, CI, tests, lint, and health checks.

## Current State

Completed so far (this session):

* `CLAUDE.md` restored as the project governance file (previously misplaced as `README.md`).
* `README.md` rewritten as the human-facing project entry point.
* Claude Code skills and custom commands audited for internal consistency; a broken frontmatter delimiter was corrected in 9 files (see [ADR-free correction log in the audit report]).
* Minimum documentation foundation created: product vision, roadmap, domain glossary, architecture (context, containers, deployment), development (local setup, testing), a local-development runbook, and this phase plan.
* Initial ADRs created for decisions already established by `CLAUDE.md` (see `docs/adr/`).

Not started:

* `apps/api` (Go backend);
* `apps/web` (React frontend);
* `compose.yaml` / Dockerfiles / `.env.example` / `Makefile`;
* `infrastructure/terraform` (local environment);
* `infrastructure/keycloak`, `infrastructure/localstack`;
* CI workflows.

## Scope

* monorepo layout matching `CLAUDE.md` section 6;
* Claude Code configuration (skills, commands) — governance layer;
* minimal Go backend exposing `/health` and `/ready`;
* minimal React frontend shell;
* PostgreSQL with a migration workflow;
* Redis, LocalStack, Keycloak, Mailpit as Docker Compose services;
* initial Terraform structure targeting only LocalStack-supported local resources;
* CI running backend, frontend, and infrastructure quality checks;
* baseline tests, lint, and structured logging.

## Out of Scope

* the public catalog (Phase 1);
* authentication flows beyond Keycloak's local foundation (Phase 2);
* administration (Phase 3);
* advanced editorial blocks (Phase 4);
* gamification (Phase 5);
* any real AWS resource or deployment (Phase 6).

## Prerequisites

None — this is the first phase.

## Deliverables

See [`CLAUDE.md`](../../../CLAUDE.md) sections 25–26 for the authoritative deliverable list and expected initial workflow.

## Technical Workstreams

1. Repository and documentation (in progress — this session).
2. Backend foundation (not started).
3. Frontend foundation (not started).
4. Database foundation (not started).
5. Local services (Docker Compose, not started).
6. Terraform local-environment foundation (not started).
7. Quality and CI (not started).
8. Observability baseline (not started).
9. Security baseline (not started — see unresolved gap below).

## Execution Increments

1. ~~Governance and Claude Code configuration audit~~ (this session).
2. ~~Documentation foundation and initial ADRs~~ (this session).
3. Minimal Go API with `/health` and `/ready`.
4. Minimal React application shell.
5. PostgreSQL + migration workflow.
6. Docker Compose service definitions (Postgres, Redis, LocalStack, Keycloak, Mailpit, api, web).
7. LocalStack S3 bucket initialization.
8. Keycloak realm foundation (reproducible import).
9. Terraform local-environment foundation (S3 bucket only, LocalStack-backed).
10. CI workflows (backend quality, frontend quality, infrastructure quality).
11. Clean-state validation and documentation update.

## Acceptance Criteria

* `CLAUDE.md` exists at the repository root and is the file every skill/command reads for governance (met).
* `README.md` exists as the human-facing entry point (met).
* the minimum documentation foundation exists (met — this session).
* initial ADRs exist for decisions already established by `CLAUDE.md` (met — this session).
* all Claude Code skills and commands are internally consistent, with no broken frontmatter (met — this session, with one unresolved exception noted below).
* (not yet met) `cp .env.example .env && make bootstrap && make up && make migrate && make seed && make validate && make test` succeeds from a clean checkout.
* (not yet met) frontend, backend, health, Keycloak, Mailpit, and LocalStack are reachable at their documented local URLs.

## Validation Commands

Executed this session (documentation/configuration validation only — see the governance report):

```bash
wc -l .claude/commands/*.md
diff .claude/skills/security/SKILL.md .claude/skills/testing-quality/SKILL.md
for d in .claude/skills/*/; do compare frontmatter name: to directory name; done
```

Not yet applicable: `go test`, `npm run build`, `docker compose config`, `terraform validate` — no corresponding source exists yet.

## Risks

* **Critical, unresolved:** `.claude/skills/security/SKILL.md` contains a duplicate copy of `testing-quality/SKILL.md` instead of real security guidance. Every other skill and command instructs Claude Code to read the `security` skill for authentication, uploads, secrets, and general security review — none of that guidance currently exists. This should be resolved before any feature implementation that touches authentication, uploads, or public-facing input.
* Four custom commands (`create-adr`, `create-migration`, `security-review`, `update-documentation`) are empty (0 bytes) and provide no instructions when invoked.

## Decisions Required

* Should the missing `security` skill content be authored fresh, or was it lost/misplaced from elsewhere? (Blocks safe implementation of authentication and upload-handling features.)
* Should the four empty command files be authored now, or deferred until their first real use?

## Completion Evidence

### Increment: Governance and documentation foundation

Status: Complete

Implemented:

* restored `CLAUDE.md` at repository root;
* rewrote `README.md` as the human-facing entry point;
* corrected non-standard YAML frontmatter closing delimiters (`------------` → `---`) in `product-domain/SKILL.md`, `project-orchestrator/SKILL.md`, and 7 command files;
* created `docs/product/vision.md`, `docs/product/roadmap.md`, `docs/product/domain-glossary.md`;
* created `docs/architecture/context.md`, `docs/architecture/containers.md`, `docs/architecture/deployment.md`;
* created `docs/development/local-setup.md`, `docs/development/testing.md`;
* created `docs/runbooks/local-development.md`;
* created this phase plan;
* created ADRs 0001–0007 under `docs/adr/`.

Validation:

* `wc -l .claude/commands/*.md` — confirmed 4 empty command files.
* `diff .claude/skills/security/SKILL.md .claude/skills/testing-quality/SKILL.md` — confirmed byte-for-byte duplication.
* frontmatter `name:` vs directory-name comparison across all 14 skills — confirmed `security` was the only mismatch.

Limitations:

* the `security` skill content gap remains unresolved (requires a human decision, not a mechanical fix);
* the four empty commands remain unauthored;
* no application, database, Docker, or Terraform implementation was added, per task instructions.

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

Also completed (this session, `/start-phase 0`):

* minimal Go API (`apps/api`) exposing `GET /health` and `GET /ready`, with typed/validated config, structured JSON logging, correlation-ID middleware, request-logging middleware, panic recovery, and graceful shutdown;
* root `.gitignore`, `.env.example`, and `Makefile` (`help`, `build`, `run`, `test`, `fmt`, `vet` — all verified working).

Not started:

* `apps/web` (React frontend);
* `compose.yaml` / Dockerfiles;
* PostgreSQL and migrations;
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
2. Backend foundation (minimal API with health/readiness complete — this session; domain modules not started).
3. Frontend foundation (not started).
4. Database foundation (not started).
5. Local services (Docker Compose, not started).
6. Terraform local-environment foundation (not started).
7. Quality and CI (not started).
8. Observability baseline (not started).
9. Security baseline (skill content fixed; implementation not started).

## Execution Increments

1. ~~Governance and Claude Code configuration audit~~ (this session).
2. ~~Documentation foundation and initial ADRs~~ (this session).
3. ~~Minimal Go API with `/health` and `/ready`~~ (this session).
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
* all Claude Code skills and commands are internally consistent, with no broken frontmatter (met — this session).
* the `security` skill contains genuine security-standard content rather than a duplicate of `testing-quality` (met — this session, via `/fix-bug GOV-001`).
* the backend builds, tests pass, and `/health`/`/ready` return `200` locally (met — this session).
* (not yet met) `cp .env.example .env && make bootstrap && make up && make migrate && make seed && make validate && make test` succeeds from a clean checkout — `make build`/`make test`/`make run` succeed; `bootstrap`/`up`/`migrate`/`seed`/`validate` do not exist yet.
* (not yet met) frontend, backend, health, Keycloak, Mailpit, and LocalStack are reachable at their documented local URLs — backend and health/ready are reachable; the rest are not yet implemented.

## Validation Commands

Executed this session:

```bash
wc -l .claude/commands/*.md
diff .claude/skills/security/SKILL.md .claude/skills/testing-quality/SKILL.md
for d in .claude/skills/*/; do compare frontmatter name: to directory name; done
gofmt -l apps/api
go vet ./...          # (apps/api)
go build ./...         # (apps/api)
go test ./...           # (apps/api)
make help / make fmt / make vet / make test / make build   # (repository root)
curl http://localhost:<port>/health
curl http://localhost:<port>/ready
```

Not yet applicable: `npm run build`, `docker compose config`, `terraform validate`, `sqlc generate` — no corresponding source exists yet.

## Risks

* ~~`.claude/skills/security/SKILL.md` contained a duplicate copy of `testing-quality/SKILL.md`~~ — **resolved** via `/fix-bug GOV-001` (see Completion Evidence below). The authored content is a fresh synthesis, not a restored original, and should be reviewed by the project owner for completeness.
* Four custom commands (`create-adr`, `create-migration`, `security-review`, `update-documentation`) are empty (0 bytes) and provide no instructions when invoked.

## Decisions Required

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

* the four empty commands remain unauthored;
* no application, database, Docker, or Terraform implementation was added, per task instructions.

### Bug fix: GOV-001 — security skill contains the wrong content

Status: Fixed

Root cause:

`.claude/skills/security/SKILL.md` was populated from the wrong source file — a byte-for-byte copy of `testing-quality/SKILL.md`, including its frontmatter `name: testing-quality` — and never corrected.

Correction:

Replaced the file's content with genuine security-standard content (input validation, output encoding/XSS, injection, CSRF/CORS, security headers, rate limiting, secrets management, upload security, mass-assignment protection, dependency and infrastructure security review, logging rules, testing strategy, and a security review checklist), matching the structure and frontmatter conventions of the other 13 skills and consistent with `CLAUDE.md` §13.

Regression protection:

* static check: `grep '^name:' .claude/skills/security/SKILL.md` must return `security`.
* static check: `diff .claude/skills/security/SKILL.md .claude/skills/testing-quality/SKILL.md` must report differences.
* recommended future CI step (not implemented in this fix, since no CI exists yet): lint that every skill's frontmatter `name:` matches its directory name.

Validation:

* `grep -m1 '^name:' .claude/skills/security/SKILL.md` — passed, returned `security`.
* `diff -q .claude/skills/security/SKILL.md .claude/skills/testing-quality/SKILL.md` — passed, files differ.
* full 14-skill frontmatter-name-vs-directory re-scan — passed, zero mismatches.
* Claude Code skill registry now lists `security` with its own description instead of "Testing and Quality" — passed (observed via the harness's available-skills listing).

Residual risk:

* the authored content is new, not a restored original; it should be reviewed by the project owner for completeness and accuracy against any external security policy that may exist outside this repository.

### Increment: Minimal Go API with `/health` and `/ready`

Status: Complete

Implemented:

* `apps/api` Go module (`github.com/VieiraGabrielAlexandre/reptile-collection/apps/api`, go 1.24), dependency: `github.com/go-chi/chi/v5`;
* `internal/platform/config` — typed `Config` loaded from `APP_ENV`, `API_PORT`, `LOG_LEVEL`, with local-safe defaults and startup validation (fails fast on an invalid log level);
* `internal/platform/httpserver` — chi router; middleware chain: panic recovery → correlation ID → structured request logging; `Run` with signal-based graceful shutdown (`SIGINT`/`SIGTERM`, 10s timeout);
* `internal/platform/health` — `GET /health` (`{"status":"ok"}`) and `GET /ready` (`{"status":"ready"}`); `/ready` is documented in code as temporarily equivalent to `/health` until a real dependency (PostgreSQL) exists to check;
* `cmd/api/main.go` — wires config, `slog` JSON logger (service/environment fields), router, and lifecycle;
* root `.gitignore`, `.env.example` (`APP_ENV`, `API_PORT`, `LOG_LEVEL`), and `Makefile` (`help`, `build`, `run`, `test`, `fmt`, `vet`);
* updated `README.md`, `docs/development/local-setup.md`, `docs/architecture/containers.md` to describe only what is now real, distinct from what remains planned.

Validation:

* `make fmt` — passed (no output).
* `make vet` — passed.
* `make build` — passed.
* `make test` — passed (`go test ./...`: 5 tests across `config` and `health` packages, all green).
* Manual runtime check: started the binary on a free local port, `curl GET /health` → `200 {"status":"ok"}`, `curl GET /ready` → `200 {"status":"ready"}`; response included an auto-generated `X-Correlation-ID` header on `/health` and correctly echoed a supplied `X-Correlation-ID` on `/ready`; structured JSON logs observed for startup, each request, shutdown signal, and graceful-shutdown completion; `SIGTERM` produced a clean shutdown with no orphaned process.

Limitations:

* `/ready` does not yet check any dependency (none exists yet) — tracked as a known, documented limitation, not a defect;
* `golangci-lint` is not installed in this environment, so `make lint` was intentionally not added yet;
* port `8080` was found occupied by an unrelated pre-existing process in this environment during manual testing; verification was performed on alternate free ports (`8098`, `8099`) instead — this is an environment artifact, not a defect in the implementation, and does not affect `make run`'s correctness on a clean machine.

Residual risk:

* none identified for the implemented scope; the next increment (PostgreSQL + migrations) will need to update `/ready` to perform a real connectivity check.

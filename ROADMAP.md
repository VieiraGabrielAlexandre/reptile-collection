# Roadmap and Progress

The living record of **what is done, what is next, and how to continue**.
Update this file at the end of every increment (see "How to update this file").

* Phase definitions, scope, and acceptance criteria: [docs/product/roadmap.md](docs/product/roadmap.md)
* Detailed Phase 0 plan and evidence: [docs/product/phases/phase-0.md](docs/product/phases/phase-0.md)
* Governance and rules: [CLAUDE.md](CLAUDE.md) (other AI assistants: [AGENTS.md](AGENTS.md))

Legend: ✅ done and validated · 🚧 in progress · ⬜ not started

---

## Where we are

**Current phase:** Phase 0 — Foundation 🚧
**Last updated:** 2026-11-09

| Phase | Status |
|---|---|
| 0 — Foundation | 🚧 in progress |
| 1 — Public Catalog | ⬜ |
| 2 — Users and Authentication | ⬜ |
| 3 — Administration | ⬜ |
| 4 — Advanced Editorial Experience | ⬜ |
| 5 — Gamification | ⬜ |
| 6 — AWS | ⬜ |

The project never advances to the next phase without an explicit instruction.

---

## Session handoff (read this first if you are picking up the work)

Written for any person or AI assistant (Claude Code, Codex, Cursor, Gemini, Copilot, …) continuing from the last session. Keep it short and **rewrite it at the end of every session**.

**Last session ended:** 2026-11-09, after the Terraform increment and a `.gitignore` / documentation review.

**Exact next action:** Phase 0 → Next → step 1, **CI** (see below). Skills to read: `.claude/skills/testing-quality/SKILL.md`, `.claude/skills/security/SKILL.md`.

**Repository state:**
- Branch `main`. Last commit: `b37fd00` (React shell).
- **Uncommitted:** three validated increments (Docker Compose + migrations, Keycloak realm, Terraform local) plus `.gitignore` and docs. The owner has not yet asked for commits — ask before committing. Suggested split: (1) compose/migrations/readiness, (2) Keycloak, (3) Terraform, (4) gitignore/docs.

**Last validation (all passing on 2026-11-09):** `make validate`, `make keycloak-check`, `make tf-apply-local` (re-plan without drift), all 7 Compose services healthy.

**Environment facts that bite:**
- Host port 5432 is taken by a host PostgreSQL → project PostgreSQL is on **5433**.
- If port 8080 is busy (e.g. a leftover `make run`), use `make up API_PORT=18080`. Values in `.env` beat shell variables; command-line `make VAR=x` beats both.
- LocalStack loses its data on restart → `make tf-apply-local` again.
- The developer machine has **real AWS credentials in `~/.aws`**: never run Terraform or the AWS CLI without the LocalStack endpoint and dummy credentials; never create real AWS resources (CLAUDE.md §18).
- Inside containers, `localhost` may resolve to IPv6 → health checks use `127.0.0.1`.

**Conventions the owner expects:** short plan before each increment (objective, scope, files, risks, tests, done criteria), validate for real, update this file + `docs/product/phases/phase-0.md` + README/runbook when commands change, record important decisions as ADRs (next free number: **0010**). The owner writes in Portuguese; repository docs are in English.

---

## Phase 0 — Foundation

### Done

- ✅ Governance: `CLAUDE.md`, 14 skills in `.claude/skills/`, custom commands in `.claude/commands/`
- ✅ Documentation baseline: vision, roadmap, glossary, architecture (context, containers, deployment), runbook, ADRs 0001–0009
- ✅ Go API (`apps/api`): `chi`, typed config, structured JSON logs, correlation IDs, panic recovery, graceful shutdown
- ✅ `GET /health` (process alive) and `GET /ready` (pings PostgreSQL, `503` when unavailable)
- ✅ React shell (`apps/web`): Vite, TypeScript, Tailwind v4, React Router, ESLint, Vitest + Testing Library, public layout
- ✅ Docker Compose: postgres, redis, localstack (S3), keycloak (own database), mailpit, api, web — all with health checks
- ✅ Dockerfiles: API (multi-stage, non-root) and web (Vite dev server with hot reload)
- ✅ Migrations with golang-migrate (ADR-0008) + baseline migration; seed workflow (`apps/api/seeds/`)
- ✅ Makefile: `bootstrap up down restart logs ps migrate migrate-down migrate-status migrate-create seed test lint validate reset`
- ✅ Lint: gofmt, go vet, golangci-lint (pinned, via Docker), ESLint
- ✅ Terraform local environment: `modules/storage` (private, encrypted, versioned media bucket) + `environments/local` (LocalStack only, guarded endpoint); `make tf-apply-local`, `tf-plan`, `tf-fmt`, `tf-validate`, `tf-lint` (tflint pinned via Docker) — see [infrastructure/terraform/README.md](infrastructure/terraform/README.md)
- ✅ Keycloak realm as code (ADR-0009): realm `reptile-collection`, roles `member`/`editor`/`administrator`, public web client with PKCE, API audience, 3 local test users, email via Mailpit; `make keycloak-check`, `make keycloak-reimport` — see [infrastructure/keycloak/README.md](infrastructure/keycloak/README.md)

### Next (in this order)

1. ⬜ **CI** — `.github/workflows/` running backend (`fmt`, `vet`, `golangci-lint`, `go test -race`), frontend (`typecheck`, `lint`, `test`, `build`), migrations against a Postgres service, `docker compose config`, and Terraform checks.
   Skills: `testing-quality`, `security`.
2. ⬜ **OpenAPI baseline** — `docs/api/openapi.yaml` describing `/health` and `/ready`, and the standard error format.
   Skills: `go-backend`, `documentation`.
3. ⬜ **Backend security baseline** — security headers, restrictive CORS for `http://localhost:3000`, request body size limit.
   Skills: `security`, `go-backend`.
4. ⬜ **Missing ADR** — PostgreSQL Full Text Search (expected by `CLAUDE.md` §19).
5. ⬜ **Clean-state validation** — from a fresh clone: `cp .env.example .env && make bootstrap && make up && make migrate && make tf-apply-local && make seed && make validate && make test`; then mark Phase 0 ✅.

### Known gaps / decisions pending

- Four custom commands are empty: `create-adr`, `create-migration`, `security-review`, `update-documentation`.
- Frontend does not call the backend yet (first real call arrives in Phase 1).
- LocalStack (community) does not persist data: after it restarts, run `make tf-apply-local` again.
- `trivy` / `checkov` not configured yet (candidates for the CI step).
- The web image only has a `dev` target; a production static target arrives with Phase 6.

---

## Phase 1 — Public Catalog (planned)

- ⬜ Model taxonomy (class → order → suborder → family → genus → species) separately from editorial groups (snakes, lizards, …)
- ⬜ Migrations + `sqlc` queries for taxonomy, species, articles, tags
- ⬜ Seed data with real, referenced species
- ⬜ `GET /api/v1/species`, `/species/{slug}`, `/articles`, `/articles/{slug}`, `/taxonomies`, `/tags` with pagination and standard errors
- ⬜ PostgreSQL Full Text Search: `GET /api/v1/search` + filters
- ⬜ Frontend: home, species list/page, article list/page, search — with loading, error, empty and not-found states (TanStack Query)
- ⬜ Playwright for the critical browsing flow

## Phases 2–6 (planned)

See [docs/product/roadmap.md](docs/product/roadmap.md). Summary:
**2** registration, login, profile, roles/permissions via Keycloak ·
**3** admin dashboard, species/article CRUD, media upload to S3, editorial workflow ·
**4** advanced blocks, galleries, maps, SEO ·
**5** gamification (events, achievements, quizzes) ·
**6** real AWS infrastructure with Terraform.

---

## Quick start

Requirements: Docker + Docker Compose v2, Go 1.24+, Node.js 22+, Terraform 1.8+, Make.

```bash
cp .env.example .env
make bootstrap      # check tools, npm ci, pull and build images (first run takes minutes)
make up             # start everything and wait until healthy
make migrate        # apply database migrations
make tf-apply-local # create LocalStack resources (media bucket)
make seed           # load local seed data
make validate       # lint + typecheck + tests + builds
make keycloak-check # real login against the local realm
```

| Service | URL |
|---|---|
| Frontend | http://localhost:3000 |
| Backend health | http://localhost:8080/health |
| Backend readiness | http://localhost:8080/ready |
| Keycloak admin | http://localhost:8081/admin (user/password in `.env`) |
| Keycloak test users | `member@` / `editor@` / `admin@example.test`, password `KEYCLOAK_TEST_USER_PASSWORD` in `.env` |
| Mailpit | http://localhost:8025 |
| LocalStack | http://localhost:4566 (bucket `reptile-collection-local-media`) |
| PostgreSQL (host tools) | `localhost:5433` (credentials in `.env`) |

Everyday commands: `make help` lists everything. `make logs SERVICE=api`, `make ps`, `make down`.
Destructive: `make reset CONFIRM=1` deletes this project's local data.
Port already taken? Change it in `.env` (e.g. `API_PORT=18080`) or one-off: `make up API_PORT=18080`.

---

## How to continue (workflow)

Each step of "Next" is one increment. For each one:

1. Read `CLAUDE.md`, identify the phase, load only the related skills.
2. Plan: objective, scope, files, risks, tests, done criteria.
3. Implement small, validate (`make validate`, and `make up` / `make migrate` when infrastructure changes).
4. Update docs: this file, `docs/product/phases/phase-N.md`, README if commands/URLs change, ADR for important decisions.
5. Commit with a clear message.

With Claude Code, useful commands in `.claude/commands/`:
`/plan-feature`, `/implement-feature`, `/start-phase`, `/fix-bug`, `/review-code`, `/validate-project`, `/finish-task`.

Example request: *"Implement step 1 of Phase 0 Next in ROADMAP.md (CI)."*

### Conventions to remember

- New table → `make migrate-create name=...`, write `up` and `down`, never edit an applied migration.
- New dependency → justify it (in the commit or an ADR).
- New env var → add to `.env.example` (local-only values), the consumer's config validation, and docs.
- Business rules live in `domain/`/`application/`, never in handlers or React components.
- Every frontend screen handles loading, error, empty, success, no-permission, and not-found states.

### How to update this file

At the end of each increment: move the item from "Next" to "Done" (✅), adjust "Known gaps", update "Last updated", and **rewrite "Session handoff"** (next action, uncommitted work, last validation, new environment gotchas, next free ADR number).

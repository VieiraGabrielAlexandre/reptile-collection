# Local Development Setup

Status: **Partially implemented.** The Go API backend can be built, tested, and run today. Docker Compose, the database, the frontend, and every other local service remain planned.

## Prerequisites

Currently required:

* Git;
* Go 1.24+;
* Make.

Planned, not yet required:

* Docker Engine or Docker Desktop;
* Docker Compose v2;
* Node, for the frontend;
* optional: AWS CLI, for LocalStack inspection;
* optional: Terraform, for infrastructure work;
* optional: `sqlc`.

## Current Workflow (Verified)

```bash
cp .env.example .env
make build
make test
make run
```

`make run` starts the API and blocks in the foreground; stop it with `Ctrl+C` (SIGINT) or `SIGTERM`, both of which trigger a graceful shutdown. Verified this session: `make fmt`, `make vet`, `make test`, `make build` all pass, and a manually started instance answered `GET /health` and `GET /ready` with `200` and emitted structured JSON logs including a correlation ID for each request.

## Intended Full Workflow (Not Yet Functional)

```bash
make bootstrap
make up
make migrate
make seed
make validate
```

These targets do not exist yet — they depend on Docker Compose, PostgreSQL, and the frontend, none of which are implemented. Do not attempt to run them until this document is updated to confirm they work.

## Service URLs

| Service | Status | Browser / host URL | Container URL |
|---|---|---|---|
| Backend | **real** | `http://localhost:8080` (or `$API_PORT`) | — (no container yet) |
| Backend health | **real** | `http://localhost:8080/health` | — |
| Backend readiness | **real** | `http://localhost:8080/ready` | — |
| Frontend | planned | `http://localhost:3000` | `http://web:3000` |
| Keycloak | planned | `http://localhost:8081` | `http://keycloak:8080` |
| Mailpit | planned | `http://localhost:8025` | `http://mailpit:8080` |
| LocalStack | planned | `http://localhost:4566` | `http://localstack:4566` |

`/ready` currently reports the same result as `/health`, since no external dependency is wired into the application yet. It must gain a real PostgreSQL check once the database increment lands — see the `Handler` doc comment in `apps/api/internal/platform/health/handler.go`.

## Planned Local Users

Once Keycloak is initialized, local-only example accounts are expected (documented values only, never real credentials):

```text
member@example.test
editor@example.test
admin@example.test
```

## Reset Behavior (Planned)

`make reset` is expected to warn before removing local containers and volumes. Local data loss must always be explicit — see [`CLAUDE.md`](../../CLAUDE.md) section 17.

## Troubleshooting

See [docs/runbooks/local-development.md](../runbooks/local-development.md).

## Next Step

This document must be updated with verified prerequisites, commands, and URLs as soon as Phase 0 local-development work (Docker Compose, Makefile, `.env.example`) is implemented and validated from a clean state.

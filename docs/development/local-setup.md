# Local Development Setup

Status: **Planned.** No implementation exists yet. This document describes the intended setup once Phase 0 local-development work is implemented; it does not describe a currently working workflow.

## Prerequisites (Planned)

* Git;
* Docker Engine or Docker Desktop;
* Docker Compose v2;
* Make;
* optional: Go and Node, for host-based execution;
* optional: AWS CLI, for LocalStack inspection;
* optional: Terraform, for infrastructure work;
* optional: `sqlc`.

## Intended Workflow (Not Yet Functional)

```bash
cp .env.example .env
make bootstrap
make up
make migrate
make seed
make validate
make test
```

None of `.env.example`, `Makefile`, or `compose.yaml` exist in the repository yet. Do not attempt to run the commands above until they are implemented and this document is updated to confirm they work.

## Planned Service URLs

| Service | Browser / host URL | Container URL |
|---|---|---|
| Frontend | `http://localhost:3000` | `http://web:3000` |
| Backend | `http://localhost:8080` | `http://api:8080` |
| Backend health | `http://localhost:8080/health` | — |
| Backend readiness | `http://localhost:8080/ready` | — |
| Keycloak | `http://localhost:8081` | `http://keycloak:8080` |
| Mailpit | `http://localhost:8025` | `http://mailpit:8080` |
| LocalStack | `http://localhost:4566` | `http://localstack:4566` |

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

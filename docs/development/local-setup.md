# Local Development Setup

Status: **Implemented and verified** for the Phase 0 services, including the Keycloak realm import.

## Prerequisites

* Git;
* Docker Engine (or Docker Desktop) with Docker Compose v2;
* Go 1.24+ (host builds, tests, `make run`);
* Node.js 22+ and npm (host frontend tests and lint);
* Terraform 1.8+ (LocalStack resources and `make validate`);
* Make.

Optional: AWS CLI (LocalStack inspection), `psql`, `sqlc`.

## Workflow

```bash
cp .env.example .env
make bootstrap
make up
make migrate
make tf-apply-local
make seed
make validate
```

* `make bootstrap` checks the required tools, runs `npm ci` in `apps/web`, pulls pinned images, and builds the `api` and `web` images.
* `make up` runs `docker compose up -d --build --wait` and prints the service URLs. It fails if any service does not become healthy.
* `make migrate` applies `apps/api/migrations/` through the `migrate` Compose service (profile `tools`). Migrations never run on API startup — see [ADR-0008](../adr/0008-use-golang-migrate-for-migrations.md).
* `make tf-apply-local` creates the LocalStack resources (the private media bucket `reptile-collection-local-media`) with Terraform. LocalStack does not persist data: re-run it after LocalStack restarts. See [infrastructure/terraform/README.md](../../infrastructure/terraform/README.md).
* `make seed` applies `apps/api/seeds/*.sql` in order; Phase 0 has no seed files.
* `make validate` runs gofmt, go vet, golangci-lint (pinned Docker image), ESLint, TypeScript, backend and frontend tests, both builds, `terraform fmt`/`validate`, tflint, and `docker compose config`.

Verified on 2026-11-02: all services reached `healthy`; every URL below answered `200`; `migrate` up → down → up succeeded; `/ready` returned `503` with PostgreSQL stopped and `200` after it restarted; `make validate` passed.

## Running the apps on the host

```bash
make up              # PostgreSQL and the other services
make run             # API on the host; reads DATABASE_URL from .env (localhost:5433)
cd apps/web && npm run dev
```

Stop the `api`/`web` containers first (`docker compose stop api web`) or use other ports, since they publish the same ports.

## Service URLs

| Service | Host URL | Inside the Compose network |
|---|---|---|
| Frontend (Vite, hot reload) | `http://localhost:3000` | `http://web:3000` |
| Backend | `http://localhost:8080` | `http://api:8080` |
| Backend health | `http://localhost:8080/health` | — |
| Backend readiness | `http://localhost:8080/ready` | — |
| Keycloak | `http://localhost:8081` | `http://keycloak:8080` |
| Mailpit UI / SMTP | `http://localhost:8025` / `localhost:1025` | `mailpit:8025` / `mailpit:1025` |
| LocalStack (S3) | `http://localhost:4566` | `http://localstack:4566` |
| PostgreSQL | `localhost:5433` | `postgres:5432` |
| Redis | not published | `redis:6379` |

Ports come from `.env`. Infrastructure ports are bound to `127.0.0.1` only. PostgreSQL uses host port `5433` to avoid clashing with a PostgreSQL installed on the host.

## Configuration

* `.env.example` is the template; `.env` is ignored by Git. All values are local-only placeholders.
* The Makefile loads `.env`, so a value in `.env` wins over a shell environment variable. To override once, pass it on the command line: `make up API_PORT=18080`.
* Inside Compose, the API receives its own `DATABASE_URL` pointing at `postgres:5432`; the `DATABASE_URL` in `.env` is for `make run` on the host.
* The API fails fast at startup if `DATABASE_URL` is missing.

## Databases

* `reptile_collection` — application database, managed only by migrations.
* `keycloak` — Keycloak's own database and role, created by `infrastructure/postgres/initdb/01-create-keycloak-database.sh` **only when the PostgreSQL volume is first created**. If you change `KEYCLOAK_DB_PASSWORD` later, run `make reset CONFIRM=1`.

## Reset

`make reset CONFIRM=1` runs `docker compose down --volumes --remove-orphans` for this project only, deleting its PostgreSQL, Redis, and Keycloak data. Without `CONFIRM=1` it only prints a warning. It never prunes unrelated Docker resources.

## Identity (Keycloak)

The realm `reptile-collection` is imported automatically on first start. Local-only accounts (password: `KEYCLOAK_TEST_USER_PASSWORD` from `.env`):

```text
member@example.test   member
editor@example.test   member, editor
admin@example.test    member, administrator
```

`make keycloak-check` performs a real PKCE login for each user and verifies the token issuer, audience, and roles. `make keycloak-reimport` rebuilds the realm from the JSON file (local accounts created by hand are lost). Emails (verification, password reset) arrive in Mailpit. Details: [infrastructure/keycloak/README.md](../../infrastructure/keycloak/README.md).

Verified on 2026-11-09: realm imported on start and after `keycloak-reimport`; `keycloak-check` passed (3 logins, password grant / missing PKCE / foreign redirect rejected); issuer identical from host and from the `api` container; a required-actions email reached Mailpit.

## Troubleshooting

See [docs/runbooks/local-development.md](../runbooks/local-development.md).

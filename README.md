# Reptile Collection

## Project Status

**Current phase:** Phase 0 — Foundation (in progress)

**➡️ Progress, next steps, and how to continue: [ROADMAP.md](ROADMAP.md)** (start with "Session handoff")

**AI assistants:** Claude Code reads [CLAUDE.md](CLAUDE.md); other assistants start at [AGENTS.md](AGENTS.md).

As of now:

* project governance (`CLAUDE.md`), Claude Code skills, and custom commands exist;
* the documentation foundation exists (vision, architecture, ADRs 0001–0009);
* a minimal Go API exposes `/health` and `/ready` (readiness checks PostgreSQL), with structured logging, correlation IDs, and graceful shutdown;
* a minimal React frontend shell exists (public layout and a temporary home page);
* the full local environment runs with Docker Compose: PostgreSQL, Redis, LocalStack, Keycloak, Mailpit, API, and frontend;
* migrations (golang-migrate) and the seed workflow exist; there are no domain tables yet;
* Keycloak starts with the `reptile-collection` realm imported (roles, PKCE web client, local test users) — see [infrastructure/keycloak/README.md](infrastructure/keycloak/README.md);
* Terraform creates the local media bucket on LocalStack (`make tf-apply-local`) — see [infrastructure/terraform/README.md](infrastructure/terraform/README.md);
* CI does not exist yet.

---

## Overview

Reptile Collection is an editorial platform dedicated to building a structured, trustworthy knowledge base about reptiles. It will present scientific, educational, and ecological information about reptile species through species pages, articles, taxonomic classifications, categories, habitats, geographic regions, and related topics.

Initially, only administrators and editors can create content; regular users can create accounts but cannot publish; there are no comments, forums, or public social interaction. The system is designed to evolve without introducing premature complexity.

See [docs/product/vision.md](docs/product/vision.md) for the full product vision.

---

## Current Scope

Governance, documentation, the local environment, a minimal backend, and a minimal frontend exist. No product feature (species, articles, search, accounts) has been implemented. The frontend does not call the backend yet. Scope is added incrementally, phase by phase — see [ROADMAP.md](ROADMAP.md).

---

## Architecture Summary

The application is a **modular monolith** (not microservices), with a Go backend and a React frontend communicating over a versioned JSON API. See [docs/architecture/context.md](docs/architecture/context.md), [docs/architecture/containers.md](docs/architecture/containers.md), and [docs/adr/](docs/adr/).

---

## Technology Stack

**Backend:** Go, `net/http`, `chi`, PostgreSQL (`pgx`), `sqlc`, golang-migrate, OpenAPI.

**Frontend:** React, TypeScript, Vite, React Router, TanStack Query, React Hook Form, Zod, Tailwind CSS.

**Local environment:** Docker, Docker Compose, PostgreSQL, Redis, LocalStack, Keycloak, Mailpit.

**Future infrastructure (Phase 6):** Terraform targeting AWS — VPC, ECS Fargate, ECR, ALB, RDS PostgreSQL, ElastiCache, S3, CloudFront, Cognito, SES, SQS, CloudWatch, Secrets Manager, WAF, Route 53, ACM.

None of the AWS infrastructure exists today. The local environment never requires real AWS credentials.

---

## Prerequisites

Git, Docker Engine + Docker Compose v2, Go 1.24+, Node.js 22+, Terraform 1.8+, and Make.

---

## Quick Start

```bash
cp .env.example .env
make bootstrap      # check tools, npm ci, pull and build images (first run takes minutes)
make up             # start all services and wait until they are healthy
make migrate        # apply database migrations
make tf-apply-local # create LocalStack resources (media bucket)
make seed           # load local seed data (none yet in Phase 0)
make validate       # lint, typecheck, tests, builds, compose config
```

Stop with `make down` (data is kept). `make reset CONFIRM=1` removes this project's containers **and local data**.

Alternative, without containers for the apps (PostgreSQL still comes from `make up`):

```bash
make run                       # API on the host, http://localhost:8080
cd apps/web && npm run dev     # frontend on the host, http://localhost:3000
```

If a port is already in use, change it in `.env` (e.g. `API_PORT=18080`) or pass it once: `make up API_PORT=18080`.

---

## Local Services

```text
Frontend:    http://localhost:3000
Backend:     http://localhost:8080
Health:      http://localhost:8080/health
Readiness:   http://localhost:8080/ready
Keycloak:    http://localhost:8081   (realm reptile-collection; admin credentials in .env)
Mailpit:     http://localhost:8025   (SMTP on localhost:1025)
LocalStack:  http://localhost:4566   (S3 bucket reptile-collection-local-media)
PostgreSQL:  localhost:5433          (for host tools; credentials in .env)
```

Redis is reachable only inside the Compose network (`redis:6379`).

---

## Available Commands

Run `make help` for the full list.

```text
make bootstrap       Check required tools, install frontend deps, build images
make up              Start all services and wait until they are healthy
make down            Stop all services (keeps data)
make restart         Restart all services
make logs            Follow logs (all services, or SERVICE=api)
make ps              Show service status
make reset CONFIRM=1 Remove all local containers AND DATA
make migrate         Apply all pending migrations
make migrate-down    Revert the most recent migration
make migrate-status  Show the current migration version
make migrate-create name=create_species   Create a migration pair
make seed            Load local seed data (apps/api/seeds/*.sql)
make keycloak-check  Real PKCE login for each local test user + token checks
make keycloak-reimport  Re-import the realm from infrastructure/keycloak
make tf-apply-local  Create/update LocalStack resources with Terraform
make tf-plan         Preview Terraform changes (local environment)
make run             Run the API on the host
make test            Backend (go test -race) and frontend tests
make lint            gofmt, go vet, golangci-lint, ESLint, terraform fmt, tflint
make validate        Full quality gate
```

---

## Repository Structure

```text
.
├── CLAUDE.md                # governance for all work in this repository
├── README.md
├── ROADMAP.md               # progress, next steps, session handoff
├── AGENTS.md                # entry point for non-Claude AI assistants
├── Makefile
├── compose.yaml             # local services
├── compose.override.yaml    # developer conveniences (frontend hot reload)
├── .env.example
├── .claude/                 # Claude Code skills and commands
├── apps/
│   ├── api/                 # Go API
│   │   ├── cmd/api/
│   │   ├── internal/platform/{config,database,health,httpserver}/
│   │   ├── migrations/      # golang-migrate SQL files
│   │   ├── seeds/           # local seed SQL
│   │   └── Dockerfile
│   └── web/                 # React frontend
│       ├── src/
│       └── Dockerfile
├── infrastructure/
│   ├── keycloak/            # realm-as-code import + README
│   ├── terraform/           # modules/storage + environments/local (LocalStack)
│   └── postgres/initdb/     # creates the Keycloak database on first start
├── scripts/                 # helper scripts (seed, Keycloak check)
└── docs/                    # product, architecture, ADRs, development, runbooks
```

The full target structure (`.github/workflows/`, more Terraform modules and environments, etc.) is defined in `CLAUDE.md` and is created incrementally.

---

## Documentation Map

* [Progress and next steps](ROADMAP.md)
* [Product vision](docs/product/vision.md)
* [Phase roadmap](docs/product/roadmap.md)
* [Domain glossary](docs/product/domain-glossary.md)
* [Phase 0 plan](docs/product/phases/phase-0.md)
* [Architecture: context](docs/architecture/context.md)
* [Architecture: containers](docs/architecture/containers.md)
* [Architecture: deployment](docs/architecture/deployment.md)
* [Local development setup](docs/development/local-setup.md)
* [Testing strategy](docs/development/testing.md)
* [Runbook: local development](docs/runbooks/local-development.md)
* [Architecture decision records](docs/adr/)
* [Project governance (`CLAUDE.md`)](CLAUDE.md)

---

## Contributing

This project is developed with Claude Code under the governance defined in [`CLAUDE.md`](CLAUDE.md). Before making changes, read `CLAUDE.md`, identify the current phase, and identify the relevant skills under `.claude/skills/`. At the end of each increment, update [ROADMAP.md](ROADMAP.md).

---

## License

Not yet defined.

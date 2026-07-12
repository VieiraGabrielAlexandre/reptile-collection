# Reptile Collection

## Project Status

**Current phase:** Phase 0 — Foundation (in progress)

This repository is being bootstrapped incrementally. As of now:

* project governance (`CLAUDE.md`), Claude Code skills, and custom commands exist;
* the documentation foundation described below exists;
* a minimal Go API exists, exposing `/health` and `/ready`, with structured logging, correlation IDs, and graceful shutdown;
* frontend, database, Docker Compose, Keycloak, LocalStack, Mailpit, Terraform, and CI do not exist yet.

See [docs/product/phases/phase-0.md](docs/product/phases/phase-0.md) for the current phase plan and completion evidence.

---

## Overview

Reptile Collection is an editorial platform dedicated to building a structured, trustworthy knowledge base about reptiles. It will present scientific, educational, and ecological information about reptile species through species pages, articles, taxonomic classifications, categories, habitats, geographic regions, and related topics.

Initially, only administrators and editors can create content; regular users can create accounts but cannot publish; there are no comments, forums, or public social interaction. The system is designed to evolve without introducing premature complexity.

See [docs/product/vision.md](docs/product/vision.md) for the full product vision.

---

## Current Scope

Nothing beyond governance and documentation has been implemented. Application scope will be added incrementally, phase by phase — see [Roadmap](#roadmap).

---

## Architecture Summary

The application will be a **modular monolith** (not microservices), with a Go backend and a React frontend, communicating over a versioned JSON API. See [docs/architecture/context.md](docs/architecture/context.md) and [docs/architecture/containers.md](docs/architecture/containers.md) for details, and [docs/adr/](docs/adr/) for the architectural decisions already accepted.

---

## Technology Stack

**Backend:** Go, `net/http`, `chi`, PostgreSQL, `sqlc`, versioned migrations, OpenAPI.

**Frontend:** React, TypeScript, Vite, React Router, TanStack Query, React Hook Form, Zod, Tailwind CSS.

**Local environment:** Docker, Docker Compose, PostgreSQL, Redis, LocalStack, Keycloak, Mailpit.

**Future infrastructure (Phase 6):** Terraform targeting AWS — VPC, ECS Fargate, ECR, ALB, RDS PostgreSQL, ElastiCache, S3, CloudFront, Cognito, SES, SQS, CloudWatch, Secrets Manager, WAF, Route 53, ACM.

None of the future AWS infrastructure exists today. The local environment never requires real AWS credentials.

---

## Prerequisites

Currently required: Git and Go 1.24+.

Not yet required (needed once their respective increments land): Docker Engine, Docker Compose v2, Node.js, Make is already usable today for the backend targets below.

---

## Quick Start

The backend can be built and run today:

```bash
cp .env.example .env
make build
make test
make run
```

`make run` starts the API on `http://localhost:8080` (or `$API_PORT` from `.env`). The full target workflow below is **not yet functional** — `make bootstrap`, `make up`, `make migrate`, `make seed`, and `make validate` do not exist yet, since Docker Compose, the database, and the frontend have not been implemented:

```bash
# Not yet available:
make bootstrap
make up
make migrate
make seed
make validate
```

---

## Local Services

Currently real:

```text
Backend:    http://localhost:8080  (make run)
Health:     http://localhost:8080/health
Readiness:  http://localhost:8080/ready
```

Not yet implemented:

```text
Frontend:   http://localhost:3000
Keycloak:   http://localhost:8081
Mailpit:    http://localhost:8025
LocalStack: http://localhost:4566
```

---

## Available Commands

```text
make help    Show available commands
make build   Build the API binary
make run     Run the API locally
make test    Run backend tests
make fmt     Check Go formatting
make vet     Run go vet
```

---

## Testing and Validation

Currently real, run from the repository root:

```bash
make fmt
make vet
make test
make build
```

`golangci-lint` is referenced by project conventions but is not installed in this environment yet, so `make lint` is intentionally not defined until it is configured. See [docs/development/testing.md](docs/development/testing.md) for the full intended strategy once frontend, database, and infrastructure exist.

---

## Repository Structure

Current structure:

```text
.
├── CLAUDE.md
├── README.md
├── Makefile
├── .env.example
├── .gitignore
├── .claude/
│   ├── settings.local.json
│   ├── commands/
│   └── skills/
├── apps/
│   └── api/
│       ├── go.mod
│       ├── go.sum
│       ├── cmd/api/
│       └── internal/platform/
│           ├── config/
│           ├── httpserver/
│           └── health/
└── docs/
    ├── product/
    ├── architecture/
    ├── development/
    ├── runbooks/
    └── adr/
```

The full target structure (including `apps/web`, `infrastructure/`, `compose.yaml`, `.github/workflows/`, etc.) is defined in `CLAUDE.md` and will be created incrementally as Phase 0 implementation proceeds.

---

## Documentation Map

* [Product vision](docs/product/vision.md)
* [Roadmap](docs/product/roadmap.md)
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

## Roadmap

```text
Phase 0 — Foundation (current)
Phase 1 — Public Catalog
Phase 2 — Users and Authentication
Phase 3 — Administration
Phase 4 — Advanced Editorial Experience
Phase 5 — Gamification
Phase 6 — AWS Deployment
```

See [docs/product/roadmap.md](docs/product/roadmap.md) for objectives, scope, and acceptance criteria per phase. The project does not advance to a new phase without explicit instruction.

---

## Contributing

This project is developed with Claude Code under the governance defined in [`CLAUDE.md`](CLAUDE.md). Before making changes, read `CLAUDE.md`, identify the current phase, and identify the relevant skills under `.claude/skills/`.

---

## License

Not yet defined.

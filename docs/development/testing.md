# Testing Strategy

Status: **Planned.** No test suite exists yet (Phase 0 in progress). This document describes the intended test strategy, per [`CLAUDE.md`](../../CLAUDE.md) and the `testing-quality` skill; it does not describe currently passing tests.

## Test Pyramid (Planned)

* **Unit tests** — domain invariants, value objects, validation, pure utilities. Fast, no network, no Docker.
* **Integration tests** — PostgreSQL repositories, migrations, Redis behavior, LocalStack storage, Keycloak integration.
* **End-to-end tests** — critical user journeys only (e.g. public species browsing once it exists), using Playwright.

## Planned Commands

### Backend

```bash
go test ./...
go test -race ./...
go vet ./...
golangci-lint run
```

### Frontend

```bash
npm run typecheck
npm run lint
npm run test
npm run build
```

### Infrastructure

```bash
terraform fmt -check -recursive
terraform validate
tflint
```

None of these commands can currently be run — no `apps/api`, `apps/web`, or `infrastructure/terraform` directory exists yet.

## Phase 0 Quality Baseline (Target)

* at least one backend health-handler test;
* Go formatting, `go vet`, lint configuration, build validation;
* at least one frontend application-shell test;
* TypeScript checking, ESLint, frontend build;
* Docker Compose config validation;
* Terraform format and validate;
* backend, frontend, and infrastructure CI quality workflows.

## General Rules

* tests must be behavior-oriented, deterministic, and isolated;
* do not remove or disable tests to make validation pass;
* do not point tests at a shared or production-like database;
* regression tests are required for every bug fix when practical.

## Next Step

This document must be updated with real, verified commands and CI job names once Phase 0 backend, frontend, and CI foundations are implemented.

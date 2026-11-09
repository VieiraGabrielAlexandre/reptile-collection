# Testing Strategy

Status: **Active (Phase 0 baseline).** Commands below run today. Strategy per [`CLAUDE.md`](../../CLAUDE.md) §15 and the `testing-quality` skill.

## Test Pyramid

* **Unit tests** — domain invariants, value objects, validation, handlers with in-memory fakes. Fast, no network, no Docker. *Exists:* config and health handler tests (Go), layout and home page tests (Vitest + Testing Library).
* **Integration tests** — PostgreSQL repositories, migrations, Redis, LocalStack storage, Keycloak. *Exists as scripted smoke checks:* `make keycloak-check`; migrations verified up/down/up manually. Go integration tests arrive with the first repository (Phase 1).
* **End-to-end tests** — critical user journeys only, using Playwright. *Not started* (first journey: public species browsing, Phase 1).

## Commands

Everything at once:

```bash
make validate     # lint + typecheck + terraform validate + tests + builds + compose config
```

Individually:

| Area | Command | Runs |
|---|---|---|
| Backend | `make test-api` | `go test -race ./...` |
| Backend | `make fmt` / `make vet` | `gofmt -l` (fails on diff) / `go vet ./...` |
| Backend | `make lint-api` | `golangci-lint run` (pinned image, via Docker) |
| Frontend | `make test-web` | `npm run test` (Vitest) |
| Frontend | `make lint-web` / `make typecheck-web` / `make build-web` | ESLint / `tsc -b` / Vite build |
| Infrastructure | `make tf-fmt` / `make tf-validate` / `make tf-lint` | `terraform fmt -check -recursive` / `terraform validate` / tflint |
| Local environment | `docker compose config -q` | part of `make validate` |
| Identity | `make keycloak-check` | real PKCE login + token claims (needs `make up`) |

## Phase 0 Quality Baseline

* ✅ backend health/readiness handler tests (incl. `503` without leaking errors);
* ✅ Go formatting, `go vet`, golangci-lint, build;
* ✅ frontend shell tests, TypeScript, ESLint, build;
* ✅ Docker Compose config validation;
* ✅ Terraform fmt, validate, tflint;
* ⬜ CI workflows running all of the above (next ROADMAP step);
* ⬜ `trivy` / `checkov` (when configured).

## General Rules

* tests must be behavior-oriented, deterministic, and isolated;
* prefer simple in-memory fakes over mocks;
* do not remove or disable tests to make validation pass;
* do not point tests at a shared or production-like database;
* regression tests are required for every bug fix when practical.

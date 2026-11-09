SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

# Load local configuration (KEY=VALUE lines) and export it to every recipe,
# so `make run` and the scripts see the same values as Docker Compose.
-include .env
export

COMPOSE := docker compose
MIGRATE_IMAGE := migrate/migrate:v4.18.3
GOLANGCI_LINT_IMAGE := golangci/golangci-lint:v2.4.0-alpine
TFLINT_IMAGE := ghcr.io/terraform-linters/tflint:v0.59.1
TF_DIR := infrastructure/terraform
TF_LOCAL := $(TF_DIR)/environments/local

.PHONY: help bootstrap up down restart logs ps migrate migrate-down migrate-status \
        migrate-create seed keycloak-check keycloak-reimport tf-init tf-plan tf-apply-local tf-fmt tf-validate tf-lint build run test test-api test-web fmt vet lint lint-api \
        lint-web typecheck-web build-web validate reset check-env

help: ## Show available commands
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  %-16s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check-env:
	@if [ ! -f .env ]; then echo "error: .env not found. Run: cp .env.example .env" >&2; exit 1; fi

# ---------------------------------------------------------------------------
# Local environment (Docker Compose)
# ---------------------------------------------------------------------------

bootstrap: check-env ## Check required tools, install frontend deps, build images
	@for tool in docker go node npm terraform; do
	  command -v $$tool >/dev/null || { echo "error: '$$tool' is required but not installed" >&2; exit 1; }
	done
	$(COMPOSE) version >/dev/null || { echo "error: Docker Compose v2 is required" >&2; exit 1; }
	cd apps/web && npm ci
	cd ../..
	$(COMPOSE) pull --ignore-buildable
	$(COMPOSE) --profile tools pull migrate
	$(COMPOSE) build
	docker pull -q $(TFLINT_IMAGE) >/dev/null
	terraform -chdir=$(TF_LOCAL) init -input=false
	@echo "bootstrap: done. Next: make up"

up: check-env ## Start all services and wait until they are healthy
	@$(COMPOSE) up -d --build --wait
	@echo ""
	@echo "Frontend:   http://localhost:$${WEB_PORT:-3000}"
	@echo "Backend:    http://localhost:$${API_PORT:-8080}/health"
	@echo "Keycloak:   http://localhost:$${KEYCLOAK_PORT:-8081}"
	@echo "Mailpit:    http://localhost:$${MAILPIT_UI_PORT:-8025}"
	@echo "LocalStack: http://localhost:$${LOCALSTACK_PORT:-4566}"

down: ## Stop all services (keeps data)
	$(COMPOSE) down --remove-orphans

restart: down up ## Restart all services

logs: ## Follow logs (all services, or SERVICE=api)
	$(COMPOSE) logs -f $(SERVICE)

ps: ## Show service status
	$(COMPOSE) ps

reset: ## Remove all local containers AND DATA (requires CONFIRM=1)
	@if [ "$(CONFIRM)" != "1" ]; then
	  echo "WARNING: this deletes the local PostgreSQL, Redis and Keycloak data of this project."
	  echo "Run again with: make reset CONFIRM=1"
	  exit 1
	fi
	$(COMPOSE) --profile tools down --volumes --remove-orphans
	@echo "reset: local environment removed. Next: make up && make migrate && make seed"

# ---------------------------------------------------------------------------
# Database
# ---------------------------------------------------------------------------

migrate: check-env ## Apply all pending migrations
	$(COMPOSE) run --rm migrate up

migrate-down: check-env ## Revert the most recent migration
	$(COMPOSE) run --rm migrate down 1

migrate-status: check-env ## Show the current migration version
	$(COMPOSE) run --rm migrate version

migrate-create: ## Create a migration pair: make migrate-create name=create_species
	@if [ -z "$(name)" ]; then echo "usage: make migrate-create name=<snake_case_name>" >&2; exit 1; fi
	docker run --rm --user "$$(id -u):$$(id -g)" \
	  -v "$$(pwd)/apps/api/migrations:/migrations" \
	  $(MIGRATE_IMAGE) create -ext sql -dir /migrations -seq "$(name)"

seed: check-env ## Load local seed data (apps/api/seeds/*.sql)
	./scripts/seed.sh

# ---------------------------------------------------------------------------
# Identity (Keycloak)
# ---------------------------------------------------------------------------

keycloak-check: check-env ## Smoke-test the Keycloak realm (PKCE login, token claims)
	./scripts/check-keycloak.sh

keycloak-reimport: check-env ## Delete the local realm and re-import it from infrastructure/keycloak
	$(COMPOSE) exec -T keycloak sh -c '
	  /opt/keycloak/bin/kcadm.sh config credentials --config /tmp/kcadm.config \
	    --server http://localhost:8080 --realm master \
	    --user "$$KC_BOOTSTRAP_ADMIN_USERNAME" --password "$$KC_BOOTSTRAP_ADMIN_PASSWORD" >/dev/null &&
	  /opt/keycloak/bin/kcadm.sh delete realms/$(KEYCLOAK_REALM) --config /tmp/kcadm.config;
	  rm -f /tmp/kcadm.config'
	$(COMPOSE) restart keycloak
	$(COMPOSE) up -d --wait keycloak
	@echo "keycloak-reimport: realm $(KEYCLOAK_REALM) re-imported."

# ---------------------------------------------------------------------------
# Infrastructure (Terraform). The local environment targets LocalStack only.
# ---------------------------------------------------------------------------

tf-init: ## Initialize the local Terraform environment
	terraform -chdir=$(TF_LOCAL) init -input=false

tf-plan: tf-init ## Show planned changes to LocalStack resources
	terraform -chdir=$(TF_LOCAL) plan -input=false

tf-apply-local: tf-init ## Create/update LocalStack resources (media bucket); re-run after LocalStack restarts
	terraform -chdir=$(TF_LOCAL) apply -input=false -auto-approve

tf-fmt: ## Fail if Terraform files are not formatted
	terraform fmt -check -recursive $(TF_DIR)

tf-validate: ## Validate every Terraform root (no backend, no cloud access)
	@for dir in $(TF_DIR)/environments/*/; do
	  echo "terraform validate: $$dir"
	  terraform -chdir="$$dir" init -input=false -backend=false >/dev/null
	  terraform -chdir="$$dir" validate -no-color
	done

tf-lint: ## Run tflint (pinned, via Docker)
	docker run --rm --user "$$(id -u):$$(id -g)" -v "$$(pwd)/$(TF_DIR):/data" -w /data \
	  $(TFLINT_IMAGE) --config /data/.tflint.hcl --recursive

# ---------------------------------------------------------------------------
# Backend (host)
# ---------------------------------------------------------------------------

build: ## Build the API binary
	cd apps/api && go build -o bin/api ./cmd/api

run: check-env ## Run the API on the host (needs `make up` for PostgreSQL)
	cd apps/api && go run ./cmd/api

test-api: ## Run backend tests (with the race detector)
	cd apps/api && go test -race ./...

fmt: ## Fail if Go files are not gofmt-formatted
	@cd apps/api
	unformatted="$$(gofmt -l .)"
	if [ -n "$$unformatted" ]; then echo "gofmt needed:"; echo "$$unformatted"; exit 1; fi

vet: ## Run go vet
	cd apps/api && go vet ./...

lint-api: ## Run golangci-lint (pinned, via Docker)
	docker run --rm -v "$$(pwd)/apps/api:/app" -w /app \
	  -v reptile-collection-golangci-cache:/root/.cache \
	  $(GOLANGCI_LINT_IMAGE) golangci-lint run ./...

# ---------------------------------------------------------------------------
# Frontend (host)
# ---------------------------------------------------------------------------

test-web: ## Run frontend tests
	cd apps/web && npm run test

lint-web: ## Run ESLint
	cd apps/web && npm run lint

typecheck-web: ## Type-check the frontend
	cd apps/web && npm run typecheck

build-web: ## Build the frontend
	cd apps/web && npm run build

# ---------------------------------------------------------------------------
# Aggregates
# ---------------------------------------------------------------------------

test: test-api test-web ## Run backend and frontend tests

lint: fmt vet lint-api lint-web tf-fmt tf-lint ## Run all linters

validate: lint typecheck-web tf-validate test build build-web ## Full quality gate (lint, types, tests, builds, terraform, compose)
	@$(COMPOSE) config -q
	@echo "validate: all checks passed."

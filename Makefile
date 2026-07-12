SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

.PHONY: help build run test fmt vet

help: ## Show available commands
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build the API binary
	cd apps/api && go build -o bin/api ./cmd/api

run: ## Run the API locally (reads .env if present)
	cd apps/api && go run ./cmd/api

test: ## Run backend tests
	cd apps/api && go test ./...

fmt: ## Check Go formatting
	cd apps/api && gofmt -l .

vet: ## Run go vet
	cd apps/api && go vet ./...

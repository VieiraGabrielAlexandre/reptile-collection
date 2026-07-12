---

name: local-development
description: Defines local development standards for the reptile knowledge platform. Use this skill for Docker, Docker Compose, LocalStack, PostgreSQL, Redis, Keycloak, Mailpit, Makefile targets, environment variables, bootstrap scripts, service health checks, local troubleshooting, and safe reset workflows.
when_to_use: Use whenever a task creates, changes, reviews, debugs, or validates the local development environment, container orchestration, service initialization, environment setup, local AWS emulation, developer commands, or reproducibility.
argument-hint: "[local-development-task]"
disable-model-invocation: false
user-invocable: true
model: inherit
effort: high
paths:

* "compose*.{yaml,yml}"
* "Dockerfile"
* "**/Dockerfile"
* "Makefile"
* ".env.example"
* ".dockerignore"
* "scripts/**"
* "infrastructure/localstack/**"
* "infrastructure/keycloak/**"
* "apps/api/**"
* "apps/web/**"
* "docs/development/**"
* "docs/runbooks/**"

---

# Local Development

## Objective

Define and enforce a reproducible, secure, and developer-friendly local environment for the reptile knowledge platform.

Use this skill to guide:

* Dockerfiles;
* Docker Compose;
* PostgreSQL;
* Redis;
* LocalStack;
* Keycloak;
* Mailpit;
* backend and frontend containers;
* environment variables;
* bootstrap scripts;
* migrations;
* seed data;
* health checks;
* Makefile commands;
* service dependencies;
* safe reset workflows;
* troubleshooting documentation.

The current task is:

```text
$ARGUMENTS
```

If no arguments were provided, infer the task from the current conversation.

---

## Mandatory Context

Before changing the local environment:

1. Read `${CLAUDE_PROJECT_DIR}/CLAUDE.md`.
2. Read the relevant backend, frontend, database, authentication, Terraform, security, and observability skills.
3. Inspect existing Compose files.
4. Inspect Dockerfiles.
5. Inspect `.env.example`.
6. Inspect the Makefile.
7. Inspect startup and initialization scripts.
8. Inspect current service health checks.
9. Identify the current project phase.
10. Identify which services are required for the requested task.
11. Preserve existing developer workflows unless a change is necessary.
12. Verify that no real AWS or production credentials are required.

Do not replace a functioning local setup without understanding why it exists.

Do not add services that are not required by the current phase.

---

## Core Principles

The local environment must be:

* reproducible;
* isolated;
* deterministic;
* documented;
* safe to reset;
* close enough to future production behavior;
* simple to start;
* simple to stop;
* observable;
* free from paid external dependencies;
* independent from real cloud credentials;
* suitable for automated tests.

A new developer should be able to run the project with minimal manual configuration.

The target workflow is:

```bash
cp .env.example .env
make bootstrap
make up
make migrate
make seed
make validate
make test
```

Do not require undocumented manual steps.

---

## Required Local Services

The initial local environment should support:

```text
frontend
backend
postgres
redis
localstack
keycloak
mailpit
```

Not every service must block startup if it is optional for the current phase.

### Frontend

Expected URL:

```text
http://localhost:3000
```

### Backend

Expected URL:

```text
http://localhost:8080
```

### Backend health

Expected URL:

```text
http://localhost:8080/health
```

### Keycloak

Expected URL:

```text
http://localhost:8081
```

### Mailpit

Expected URL:

```text
http://localhost:8025
```

### LocalStack

Expected URL:

```text
http://localhost:4566
```

PostgreSQL and Redis should normally be exposed only as needed for local tooling.

Do not expose unnecessary service ports by default.

---

## Compose File Strategy

Use a clear Compose structure.

Recommended files:

```text
compose.yaml
compose.override.yaml
```

Possible responsibilities:

### `compose.yaml`

Contains the standard reproducible service definition.

### `compose.override.yaml`

Contains developer conveniences such as:

* source mounts;
* hot reload;
* debug ports;
* local command overrides.

Do not put production deployment configuration in Docker Compose.

Do not create many environment-specific Compose files without a real need.

---

## Compose Version

Use modern Docker Compose syntax.

Do not add the obsolete top-level `version` property unless compatibility requires it.

Use:

```bash
docker compose
```

instead of relying on the legacy:

```bash
docker-compose
```

Makefile targets should use one consistent command.

---

## Project Naming

Set or document a stable Compose project name when useful.

Example environment variable:

```text
COMPOSE_PROJECT_NAME=reptile-archive
```

This helps keep:

* containers;
* volumes;
* networks

grouped consistently.

Do not hardcode names that prevent multiple checkouts from running when multi-instance support is required.

---

## Network Design

Use a dedicated application network.

Example:

```yaml
networks:
  app-network:
    driver: bridge
```

Containers should reach each other through service names.

Examples:

```text
postgres:5432
redis:6379
localstack:4566
keycloak:8080
```

Do not use `localhost` for container-to-container communication.

Inside a container, `localhost` refers to that same container.

---

## Service Dependencies

Use `depends_on` with health conditions when supported and useful.

Example:

```yaml
depends_on:
  postgres:
    condition: service_healthy
```

However, application startup must still tolerate temporary dependency unavailability when appropriate.

`depends_on` is not a complete readiness strategy.

Do not rely only on container startup order.

Use retries, health checks, or explicit wait scripts where needed.

---

## Health Checks

Every long-running service should have a meaningful health check where practical.

### PostgreSQL

Example:

```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
  interval: 5s
  timeout: 3s
  retries: 10
```

### Redis

Example:

```yaml
healthcheck:
  test: ["CMD", "redis-cli", "ping"]
  interval: 5s
  timeout: 3s
  retries: 10
```

### Backend

Example:

```yaml
healthcheck:
  test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:8080/health"]
  interval: 10s
  timeout: 3s
  retries: 10
```

Use a health-check command that exists in the image.

Do not assume `curl` is installed.

Do not create health checks that perform expensive operations.

---

## Health vs Readiness

Use:

```text
/health
/ready
```

### `/health`

Checks whether the application process is alive.

### `/ready`

Checks whether essential dependencies are available.

Compose health checks may use `/health` during early foundation work.

Integration tests may use `/ready` when dependency availability matters.

Do not make `/health` fail because an optional dependency is unavailable.

---

## Restart Policies

For local development, use restart policies deliberately.

Possible choice:

```yaml
restart: unless-stopped
```

or no restart policy for easier debugging.

Do not use aggressive automatic restart behavior that hides crash loops.

A crashing process should remain diagnosable.

---

## Container Naming

Avoid explicit `container_name` unless required.

Compose-generated names support:

* multiple project instances;
* fewer naming collisions;
* simpler isolation.

Do not hardcode container names merely for convenience.

Use service names in commands and networking.

---

## Volumes

Use named volumes for persistent development data.

Potential volumes:

```text
postgres-data
redis-data
localstack-data
keycloak-data
```

Use bind mounts for source code and configuration.

Do not mount the entire host filesystem.

Do not mount secrets into broadly accessible locations.

### Persistence Policy

Persist:

* local PostgreSQL data;
* Keycloak local data when not imported fresh;
* LocalStack state when useful;
* package caches when useful.

Do not persist temporary build output unnecessarily.

---

## Reset Behavior

`make reset` must clearly remove local state.

It should:

1. display a warning;
2. stop the environment;
3. remove project containers;
4. remove project volumes;
5. optionally remove generated local artifacts;
6. restart or leave the environment stopped according to documented behavior.

Example behavior:

```bash
docker compose down --volumes --remove-orphans
```

Do not remove unrelated Docker volumes.

Do not run:

```bash
docker system prune -a
```

as part of project reset.

That command affects unrelated projects.

---

## Safe Confirmation

For destructive commands, either:

* require an explicit confirmation;
* require an environment flag;
* use a clearly named command such as `reset-local`;
* make the destructive scope obvious.

Example:

```bash
make reset CONFIRM=1
```

Do not make destructive actions easy to trigger accidentally in shared environments.

---

## Environment Variables

Use `.env.example` as the documented template.

The real `.env` must be ignored by Git.

Group variables by service.

Example:

```text
# Application
APP_ENV=local
APP_NAME=reptile-archive

# Backend
API_PORT=8080
LOG_LEVEL=debug

# Frontend
WEB_PORT=3000
VITE_API_BASE_URL=http://localhost:8080

# PostgreSQL
POSTGRES_DB=reptile_archive
POSTGRES_USER=reptile
POSTGRES_PASSWORD=local-development-password
DATABASE_URL=postgres://reptile:local-development-password@postgres:5432/reptile_archive?sslmode=disable

# Redis
REDIS_URL=redis://redis:6379/0

# LocalStack
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=test
AWS_SECRET_ACCESS_KEY=test
LOCALSTACK_ENDPOINT=http://localstack:4566

# Keycloak
KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=local-admin-password
KEYCLOAK_REALM=reptile-archive

# Mailpit
SMTP_HOST=mailpit
SMTP_PORT=1025
```

Values are directional and may evolve.

Do not place real secrets in `.env.example`.

---

## Variable Ownership

Define where each variable is consumed.

Examples:

* backend variables belong to backend configuration;
* frontend `VITE_` variables are public;
* Compose-only variables control local orchestration;
* Keycloak variables initialize the identity provider;
* Terraform variables should not be reused blindly as application variables.

Do not expose backend credentials through `VITE_` variables.

Anything beginning with `VITE_` is bundled into the frontend.

---

## Environment Validation

Applications must validate required variables at startup.

The bootstrap process should validate:

* required files;
* required tools;
* required directories;
* `.env` presence;
* port availability when practical.

Do not allow missing values to fail later with unclear errors.

---

## Local-Only Credentials

Local credentials may be simple and deterministic.

They must be:

* clearly marked as local;
* stored in `.env`;
* absent from production configuration;
* unsuitable for reuse outside local development.

Do not use values such as:

```text
password
admin123
```

without clearly local context and documentation.

Do not reuse local credentials in Terraform production examples.

---

## Dockerfiles

Use separate Dockerfiles for backend and frontend.

Suggested paths:

```text
apps/api/Dockerfile
apps/web/Dockerfile
```

Development and production needs may use:

* build targets;
* separate Dockerfiles;
* command overrides.

Prefer multi-stage builds.

Do not build final images with compilers and package managers unless required.

---

## Backend Dockerfile

A production-oriented Go Dockerfile may use:

```text
builder stage
runtime stage
```

Requirements:

* deterministic Go version;
* dependency caching;
* non-root runtime user;
* minimal runtime image;
* copied CA certificates when needed;
* explicit entrypoint;
* health-check compatibility.

Development may use a target with hot reload.

Do not use `latest` tags.

---

## Frontend Dockerfile

A production-oriented frontend Dockerfile may use:

```text
Node build stage
static runtime stage
```

During local development, Vite may run inside a Node container.

Requirements:

* deterministic Node version;
* lockfile-based installation;
* non-root user when practical;
* cached dependencies;
* source mount;
* host binding to `0.0.0.0`.

Vite must listen on:

```text
0.0.0.0
```

inside the container.

Do not bind only to `localhost` inside the container.

---

## Image Pinning

Use explicit versions.

Prefer:

```text
postgres:17-alpine
redis:7-alpine
localstack/localstack:<pinned-version>
quay.io/keycloak/keycloak:<pinned-version>
axllent/mailpit:<pinned-version>
golang:<pinned-version>
node:<pinned-version>
```

Do not use `latest`.

Version upgrades must be deliberate and validated.

---

## Multi-Architecture Support

Avoid architecture-specific assumptions when practical.

The environment should ideally support:

* Linux AMD64;
* Linux ARM64;
* macOS with Docker Desktop.

Do not force `platform: linux/amd64` unless a dependency requires it.

If forced, document the performance and compatibility impact.

---

## Backend Hot Reload

A local development tool such as Air may be used.

Requirements:

* configuration is versioned;
* source directories are watched;
* generated and temporary directories are excluded;
* rebuild loops are avoided;
* termination signals are propagated.

Do not make hot reload a requirement for CI or production.

The backend must also run with standard:

```bash
go run
```

or built binaries.

---

## Frontend Hot Reload

Vite should work through mounted source files.

Depending on host environment, polling may be required.

Possible variable:

```text
CHOKIDAR_USEPOLLING=true
```

Use polling only when necessary because it increases resource usage.

Do not enable aggressive polling for every environment without need.

---

## Package Installation

Use the repository-selected package manager consistently.

If using npm:

```bash
npm ci
```

should be preferred in deterministic builds.

Do not mix:

* npm;
* pnpm;
* Yarn

within the same project.

Only one lockfile should be committed.

---

## PostgreSQL

Run PostgreSQL directly as a container.

Do not emulate RDS locally.

Responsibilities:

* persistent named volume;
* health check;
* documented credentials;
* migration support;
* test isolation;
* sensible port exposure.

A local host port may be exposed:

```text
5432
```

only if developers need host tools.

If exposed, allow configuration to avoid collisions.

---

## PostgreSQL Initialization

Prefer migrations as the schema source of truth.

Initialization scripts may create:

* extensions;
* test databases;
* roles needed before migrations.

Do not duplicate application schema creation across:

* init SQL;
* migrations;
* application startup.

Schema changes belong to migrations.

---

## Migrations

Migrations should be executed through explicit commands.

Expected:

```bash
make migrate
make migrate-down
make migration-status
```

Do not run application migrations implicitly on every backend startup unless explicitly decided.

Explicit migration commands make failures clearer.

Local bootstrap may call migrations, but the behavior must be documented.

---

## Seed Data

Seed execution should be explicit:

```bash
make seed
```

It should:

* wait for PostgreSQL;
* run deterministically;
* avoid duplicate data when designed as idempotent;
* create representative local records;
* avoid unsafe or unlicensed content.

Do not couple backend startup to seed completion.

---

## Redis

Redis should be available for future or current technical needs.

Initial uses may include:

* rate limiting;
* temporary cache;
* idempotency;
* worker coordination.

Do not make the backend fail readiness because Redis is unavailable unless Redis is essential to current behavior.

Do not persist core content only in Redis.

---

## LocalStack

Use LocalStack for supported AWS service emulation.

Initial services may include:

```text
s3
sqs
ses
```

Do not enable every LocalStack service.

Configure only required services.

Example:

```text
SERVICES=s3,sqs,ses
```

Exact configuration depends on the selected LocalStack version.

---

## LocalStack Credentials

Use dummy local credentials:

```text
AWS_ACCESS_KEY_ID=test
AWS_SECRET_ACCESS_KEY=test
AWS_REGION=us-east-1
```

Do not require real AWS credentials.

Do not allow local scripts to fall back silently to a real AWS account.

Always configure an explicit LocalStack endpoint.

---

## LocalStack Initialization

Use initialization hooks under:

```text
infrastructure/localstack/init/
```

Possible structure:

```text
infrastructure/localstack/init/ready.d/
├── 10-create-buckets.sh
├── 20-create-queues.sh
└── 30-configure-ses.sh
```

Scripts should be:

* executable;
* idempotent;
* deterministic;
* fail-fast;
* safe for local use.

Do not create real cloud resources from LocalStack scripts.

---

## S3 Local Resources

Potential local bucket:

```text
reptile-archive-media-local
```

Initialization should configure:

* bucket creation;
* CORS only if browser direct upload is used;
* lifecycle only if needed;
* deterministic naming.

Do not make local code depend on globally unique real-AWS naming behavior.

Do not expose the bucket publicly by default.

---

## SQS Local Resources

Queues should only be created when a concrete worker exists.

Potential future queues:

```text
article-publication
media-processing
activity-events
```

Do not create queues during Phase 0 merely because AWS may use them later.

Prepare scripts only when the current phase needs them.

---

## SES and Mailpit

Mailpit captures local email.

Expected ports:

```text
SMTP: 1025
UI: 8025
```

Application or Keycloak email should route to Mailpit.

Do not send real email from local development.

Do not require SES emulation if SMTP through Mailpit is sufficient for the current phase.

Use LocalStack SES only when testing AWS-specific integration behavior.

---

## Keycloak

Keycloak must be reproducibly initialized.

Possible strategies:

* realm import;
* admin API initialization script;
* Terraform against local Keycloak only if justified.

Preferred initial direction:

* versioned realm export;
* environment-driven local credentials;
* deterministic local users and roles.

Expected local URL:

```text
http://localhost:8081
```

Inside Compose, Keycloak may listen on port `8080`.

Do not confuse host and container ports.

---

## Keycloak Database

Possible approaches:

### Dedicated PostgreSQL database

Use the same PostgreSQL server with a separate database and credentials.

### Development database

Use Keycloak's development database for the earliest foundation only.

Preferred durable local setup: PostgreSQL-backed Keycloak with separate database ownership.

Do not mix Keycloak tables into the application database schema.

Do not run application migrations against the Keycloak database.

---

## Keycloak Startup

Modern Keycloak containers may use commands such as:

```text
start-dev
```

Realm imports may require a documented startup option.

Use version-appropriate commands.

Do not copy commands from older Keycloak distributions without validation.

---

## Mail Configuration for Keycloak

When email confirmation or recovery is tested, configure Keycloak SMTP to use:

```text
host: mailpit
port: 1025
```

Do not use TLS locally unless the test specifically requires it.

Do not point local Keycloak to a real SMTP server.

---

## Backend Service

The backend container should depend on:

* PostgreSQL readiness;
* authentication configuration;
* required LocalStack resources when essential.

It should expose:

```text
8080
```

It should support:

* graceful shutdown;
* structured logs;
* health endpoint;
* readiness endpoint.

Do not run migrations automatically inside the backend container without a documented decision.

---

## Frontend Service

The frontend container should expose:

```text
3000
```

It should use the browser-accessible backend URL:

```text
http://localhost:8080
```

The browser cannot resolve Compose service names such as:

```text
http://api:8080
```

unless a proxy strategy is used.

Distinguish:

* URLs used inside containers;
* URLs used by the user's browser.

---

## Reverse Proxy

A local reverse proxy is optional.

Possible advantages:

* single origin;
* simplified CORS;
* path-based routing;
* closer production behavior.

Potential routes:

```text
/ -> frontend
/api -> backend
/auth -> Keycloak
```

Do not add a reverse proxy in Phase 0 unless it simplifies real requirements.

Direct ports are acceptable initially.

---

## CORS

When frontend and backend use separate local origins, backend CORS should allow:

```text
http://localhost:3000
```

Do not use wildcard origins with credentials.

Local CORS must be configurable separately from production.

---

## Makefile

The Makefile is the primary developer command interface.

Expected targets:

```text
help
bootstrap
up
down
restart
logs
ps
build
migrate
migrate-down
migration-status
seed
test
test-integration
test-e2e
lint
format
generate
validate
reset
clean
```

Only add targets that have real implementations.

Do not include placeholders that appear functional but fail silently.

---

## Makefile Help

Use self-documenting help where practical.

Example:

```make
help: ## Show available commands
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  %-24s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
```

Each public target should have a description.

Do not require developers to inspect the Makefile to understand basic usage.

---

## Makefile Shell Safety

Use deliberate shell settings.

Possible:

```make
SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
```

Validate portability before using advanced features.

Do not hide errors using leading `-` unless failure is intentionally ignored.

Do not use shell constructs that work only in one undocumented shell.

---

## Bootstrap

`make bootstrap` should prepare the project for first use.

Potential responsibilities:

1. verify Docker;
2. verify Docker Compose;
3. create `.env` from `.env.example` if missing, or instruct the user;
4. create required directories;
5. ensure scripts are executable;
6. build images;
7. initialize generated configuration;
8. report next commands.

Bootstrap should be idempotent.

Do not overwrite an existing `.env`.

Do not silently modify user configuration.

---

## `make up`

Expected behavior:

```bash
docker compose up -d --build
```

or an equivalent strategy.

It should:

* start required services;
* build changed images;
* return useful status;
* fail when Compose fails.

Do not automatically reset data.

Do not hide unhealthy services.

---

## `make down`

Expected behavior:

```bash
docker compose down --remove-orphans
```

It should preserve volumes by default.

Stopping the environment must not delete local data.

---

## `make logs`

Support all logs and optionally service-specific logs.

Possible interface:

```bash
make logs
make logs SERVICE=api
```

Do not require raw container names.

Use Compose service names.

---

## `make ps`

Show service status:

```bash
docker compose ps
```

This helps diagnose unhealthy services.

---

## `make validate`

`make validate` should aggregate non-destructive validation.

Potential checks:

* Docker Compose config;
* backend format and lint;
* backend tests;
* frontend typecheck;
* frontend lint;
* frontend tests;
* frontend build;
* Terraform format and validate;
* shell script lint when configured;
* environment template checks.

Do not make `validate` mutate persistent data.

Do not run destructive reset operations.

---

## `make test`

`make test` should execute the standard test suite.

Separate slow tests when needed:

```text
make test
make test-integration
make test-e2e
```

Document which services must be running.

Do not make unit tests require the entire Compose stack.

---

## `make reset`

Expected behavior:

* warn about local data deletion;
* stop services;
* remove project volumes;
* recreate or leave stopped according to documented behavior;
* never affect unrelated Docker resources.

Possible:

```bash
docker compose down --volumes --remove-orphans
```

Do not call global Docker prune commands.

---

## Scripts

Place scripts under:

```text
scripts/
```

Potential scripts:

```text
bootstrap.sh
wait-for-services.sh
seed.sh
reset-local.sh
validate.sh
```

Scripts must:

* use a portable shebang;
* enable strict mode;
* quote variables;
* fail with useful messages;
* be idempotent when expected;
* avoid destructive global operations.

Recommended Bash header:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```

Do not use unquoted variable expansions.

---

## Waiting for Services

Prefer health-aware waiting.

Potential checks:

* `pg_isready`;
* Redis `PING`;
* HTTP health endpoints;
* LocalStack health endpoint;
* Keycloak readiness endpoint.

Use timeouts.

Example behavior:

```text
wait up to 60 seconds
poll every 2 seconds
report the service that failed
exit non-zero
```

Do not use only fixed sleeps such as:

```bash
sleep 30
```

Fixed sleeps are slow and unreliable.

---

## Port Conflicts

Document default ports and allow overrides.

Possible variables:

```text
WEB_PORT=3000
API_PORT=8080
KEYCLOAK_PORT=8081
MAILPIT_UI_PORT=8025
LOCALSTACK_PORT=4566
POSTGRES_PORT=5432
REDIS_PORT=6379
```

Compose mappings may use:

```yaml
ports:
  - "${API_PORT:-8080}:8080"
```

Do not hardcode every host port if collisions are likely.

---

## Linux File Permissions

Bind mounts and generated files may create ownership issues.

Containers should use non-root users when practical.

For development, consider matching host UID and GID only when needed.

Do not add complex UID mapping before an actual problem exists.

Document any generated-file ownership workaround.

---

## Rootless Containers

Prefer non-root runtime users.

Some development images may temporarily run as root for package installation or mounted-volume compatibility.

Do not run production-like application processes as root without justification.

Local convenience must not silently shape unsafe production images.

---

## `.dockerignore`

Add `.dockerignore` files to reduce build context.

Exclude:

```text
.git
.env
node_modules
dist
coverage
tmp
*.log
Terraform state
IDE files
```

Do not exclude source files required by the build.

Do not send secrets in Docker build contexts.

---

## Build Secrets

Do not pass secrets using Docker build arguments.

Build arguments may remain visible in image history.

Local application secrets should be runtime environment variables or mounted secret files.

Do not bake `.env` into images.

---

## Logging

Container logs should go to stdout and stderr.

Do not write application logs only to files inside ephemeral containers.

Use:

```bash
docker compose logs
```

for local diagnostics.

Log output should identify:

* service;
* environment;
* severity;
* correlation ID when applicable.

---

## Observability for Local Services

The initial environment should provide:

* service health;
* container status;
* structured backend logs;
* visible Mailpit messages;
* LocalStack resource inspection;
* Keycloak admin UI.

Do not add Prometheus, Grafana, Loki, or Jaeger in Phase 0 without a current requirement.

Prepare future compatibility, but keep the initial stack lean.

---

## LocalStack Inspection

Provide documented commands.

Examples:

```bash
aws --endpoint-url=http://localhost:4566 s3 ls
aws --endpoint-url=http://localhost:4566 sqs list-queues
```

Set dummy credentials explicitly.

Do not let AWS CLI commands use the user's default real AWS endpoint accidentally.

A helper wrapper may be safer:

```bash
make awslocal ARGS="s3 ls"
```

---

## AWS CLI Safety

If local scripts use AWS CLI, always pass:

* endpoint URL;
* region;
* dummy credentials or profile;
* expected service command.

Do not rely on the developer's default AWS profile.

Do not execute commands against real AWS during local bootstrap.

---

## Terraform with LocalStack

The local Terraform environment may point supported AWS providers to LocalStack.

Use explicit endpoints.

Do not configure the production environment to use LocalStack endpoints.

Do not use Terraform to manage Docker Compose services.

Terraform local scope should be limited to AWS-like resources emulated by LocalStack.

---

## LocalStack Limitations

LocalStack does not perfectly reproduce AWS.

Document differences such as:

* IAM enforcement;
* service behavior;
* event timing;
* unsupported features;
* URL formats;
* CloudFront limitations;
* Cognito availability.

Do not claim local success guarantees identical AWS behavior.

Use real AWS validation only in the future authorized phase.

---

## Development vs Test Environments

Local interactive development and automated tests may use different Compose profiles.

Possible profiles:

```text
default
test
tools
```

Examples:

* default: application services;
* test: isolated test database;
* tools: database UI or optional utilities.

Do not introduce profiles until they simplify a real workflow.

---

## Compose Profiles

When used, document commands such as:

```bash
docker compose --profile test up
```

Do not hide required services behind an undocumented profile.

---

## Testcontainers

Backend integration tests may use Testcontainers.

If adopted:

* Docker must be available;
* tests must isolate state;
* images must be pinned;
* cleanup must be reliable;
* CI compatibility must be verified.

Do not require both a manually running Compose database and Testcontainers for the same test suite without clear separation.

---

## CI Compatibility

Local commands should align with CI.

Prefer CI to call the same commands:

```bash
make lint
make test
make validate
```

Do not maintain separate undocumented validation logic only in CI.

Local success should closely predict CI success.

---

## Cross-Platform Scripts

The primary supported environment may be Linux.

Avoid unnecessary dependence on GNU-only behavior when simple portable alternatives exist.

When using Linux-specific tools, document them.

Do not claim full Windows-native support if only WSL or Docker Desktop is supported.

---

## Developer Prerequisites

Document minimum requirements:

* Git;
* Docker Engine or Docker Desktop;
* Docker Compose v2;
* Make;
* optional Go and Node for host execution;
* optional AWS CLI for LocalStack inspection;
* optional Terraform;
* optional sqlc.

If all development commands run in containers, host Go and Node may be optional.

Do not require undeclared tools.

---

## Host vs Container Development

Choose and document a primary workflow.

Possible strategy:

### Container-first

* services run in Docker;
* source is mounted;
* commands execute through Compose.

Advantages:

* reproducibility;
* fewer host dependencies.

### Hybrid

* dependencies run in Docker;
* backend and frontend run on host.

Advantages:

* faster debugging;
* native tooling.

The project may support both, but one must be primary.

Do not create two incomplete workflows.

Recommended initial direction: container-first with optional host execution documented later.

---

## Local URLs

Document browser-facing URLs separately from internal service URLs.

Example:

| Service    | Browser/host URL        | Container URL            |
| ---------- | ----------------------- | ------------------------ |
| Frontend   | `http://localhost:3000` | `http://web:3000`        |
| Backend    | `http://localhost:8080` | `http://api:8080`        |
| Keycloak   | `http://localhost:8081` | `http://keycloak:8080`   |
| LocalStack | `http://localhost:4566` | `http://localstack:4566` |
| Mailpit    | `http://localhost:8025` | `http://mailpit:8025`    |

Do not place internal Compose hostnames into browser configuration.

---

## Troubleshooting

Create a local troubleshooting guide.

Recommended path:

```text
docs/runbooks/local-development.md
```

Include common problems:

* port already in use;
* unhealthy PostgreSQL;
* Keycloak realm not imported;
* backend cannot reach database;
* frontend cannot reach backend;
* LocalStack bucket missing;
* Mailpit not receiving email;
* stale volumes;
* permission errors;
* hot reload not detecting changes;
* invalid `.env`.

Do not rely on developers to infer solutions from raw container logs.

---

## Troubleshooting Commands

Useful commands:

```bash
docker compose ps
docker compose logs api
docker compose logs postgres
docker compose config
docker compose exec postgres pg_isready
docker compose exec redis redis-cli ping
docker compose exec api env
```

Be cautious when displaying environment variables because they may contain secrets.

Do not instruct users to paste secret-bearing output publicly.

---

## Diagnostics

A diagnostic command may summarize:

* Docker version;
* Compose version;
* service status;
* failed health checks;
* expected ports;
* missing files;
* LocalStack resource list.

Potential:

```bash
make doctor
```

Add it only when implemented.

Do not create a command that silently changes the environment while diagnosing.

---

## Security

The local environment must still follow safe practices.

Verify:

* no real secrets are required;
* no production database is referenced;
* AWS endpoint is LocalStack;
* admin interfaces bind only as needed;
* default credentials are documented as local;
* uploaded files remain inside local volumes;
* containers do not run privileged;
* Docker socket is not mounted unnecessarily;
* secrets are not baked into images.

Do not use:

```yaml
privileged: true
```

unless there is a concrete, documented requirement.

Do not mount:

```text
/var/run/docker.sock
```

into application containers without strong justification.

---

## Local Data Privacy

Developers may use real content later.

Do not seed real personal data.

Do not copy production databases into local environments by default.

If sanitized production-like data is ever introduced, document:

* sanitization;
* access control;
* retention;
* deletion.

---

## Backup and Restore

Phase 0 does not require production backup infrastructure.

A local convenience backup command may be added later.

Potential commands:

```bash
make db-dump
make db-restore FILE=...
```

Do not implement restore without clear validation and overwrite warnings.

Do not confuse local backups with production disaster recovery.

---

## Resource Limits

Optional Compose resource limits may protect developer machines.

Do not set limits so low that services become unreliable.

Keycloak and LocalStack may require more memory than simpler services.

Document expected resource usage when it becomes relevant.

---

## Cleanup

`make clean` may remove:

* temporary files;
* build artifacts;
* frontend build output;
* Go coverage files.

It should not remove persistent database volumes unless explicitly documented.

Keep:

```text
clean
reset
```

semantically distinct.

---

## Dependency Updates

Container image and tool upgrades must be deliberate.

When upgrading:

1. update the pinned version;
2. read release notes;
3. validate configuration compatibility;
4. rebuild without stale cache when necessary;
5. test initialization;
6. update documentation.

Do not batch unrelated major version upgrades into feature work.

---

## Expected Initial Compose Services

Directional example:

```yaml
services:
  postgres:
    image: postgres:17-alpine

  redis:
    image: redis:7-alpine

  localstack:
    image: localstack/localstack:<pinned-version>

  keycloak:
    image: quay.io/keycloak/keycloak:<pinned-version>

  mailpit:
    image: axllent/mailpit:<pinned-version>

  api:
    build:
      context: ./apps/api

  web:
    build:
      context: ./apps/web
```

Exact values and configuration must be validated against current versions.

Do not copy this example without implementing health checks, environment, volumes, and networks.

---

## Phase 0 Acceptance Criteria

The local-development portion of Phase 0 is complete when:

```bash
cp .env.example .env
make bootstrap
make up
make migrate
make seed
make validate
make test
```

can be executed according to project documentation.

The following should be reachable:

```text
Frontend:   http://localhost:3000
Backend:    http://localhost:8080
Health:     http://localhost:8080/health
Keycloak:   http://localhost:8081
Mailpit:    http://localhost:8025
LocalStack: http://localhost:4566
```

Additionally:

* PostgreSQL is healthy;
* Redis responds;
* LocalStack initializes required resources;
* Keycloak initializes reproducibly;
* backend can connect to required dependencies;
* frontend can reach backend;
* reset removes only project-local data;
* no real AWS credentials are needed.

---

## Validation Commands

Run relevant commands:

```bash
docker compose config
docker compose build
docker compose up -d
docker compose ps
```

Check logs:

```bash
docker compose logs --no-color
```

Validate local endpoints:

```bash
curl --fail http://localhost:8080/health
curl --fail http://localhost:8080/ready
curl --fail http://localhost:3000
curl --fail http://localhost:4566/_localstack/health
```

Keycloak health paths depend on version and configuration; validate the supported endpoint rather than assuming one.

Mailpit UI may be checked through:

```bash
curl --fail http://localhost:8025
```

Run project commands:

```bash
make migrate
make seed
make validate
make test
```

Do not claim a command succeeded unless it was actually executed.

---

## Documentation Requirements

When the local environment changes, evaluate updates to:

```text
README.md
.env.example
docs/development/local-setup.md
docs/runbooks/local-development.md
docs/architecture/deployment.md
infrastructure/localstack/README.md
infrastructure/keycloak/README.md
```

Document:

* prerequisites;
* setup commands;
* service URLs;
* ports;
* local users;
* environment variables;
* reset behavior;
* troubleshooting;
* LocalStack resources;
* known emulation differences.

Do not leave environment knowledge only in Compose comments.

---

## Implementation Workflow

When using this skill:

1. identify the developer workflow being changed;
2. inspect existing services and commands;
3. identify required dependencies;
4. define host and container URLs;
5. define environment variables;
6. define health and readiness behavior;
7. define initialization order;
8. define persistent volumes;
9. define safe reset behavior;
10. implement Compose, Dockerfile, Makefile, or scripts;
11. validate from a clean local state;
12. update documentation;
13. report known limitations.

Implement the smallest reproducible environment that supports the current phase.

---

## Expected Deliverables

Depending on the task, deliverables may include:

* `compose.yaml`;
* `compose.override.yaml`;
* Dockerfiles;
* `.dockerignore`;
* `.env.example`;
* Makefile targets;
* bootstrap scripts;
* wait scripts;
* reset scripts;
* LocalStack initialization;
* Keycloak realm configuration;
* health checks;
* seed commands;
* troubleshooting documentation;
* validation commands.

Do not create unrelated cloud deployment resources.

---

## Definition of Done

A local-development task is complete only when:

* the environment is reproducible;
* required services start;
* dependencies become healthy;
* environment variables are documented;
* no real cloud credentials are needed;
* service URLs are clear;
* migrations can run;
* seed data can run;
* reset behavior is safe;
* local scripts are idempotent where expected;
* relevant validation commands pass;
* documentation is updated;
* no unrelated Docker resources are removed;
* no success is claimed without execution evidence.

---

## Prohibited Practices

Do not:

* use unpinned `latest` images;
* use `localhost` for container-to-container communication;
* require real AWS credentials;
* let AWS commands fall back to a real account;
* run migrations from multiple competing mechanisms;
* duplicate schema initialization outside migrations;
* use fixed sleeps instead of health-aware waiting;
* use global Docker prune commands;
* remove volumes during normal `make down`;
* overwrite an existing `.env`;
* bake secrets into images;
* expose backend secrets through frontend variables;
* mount the Docker socket unnecessarily;
* run containers as privileged without justification;
* hardcode browser configuration to Compose-only hostnames;
* add services for future phases without current need;
* hide unhealthy services;
* declare the local environment complete without testing from a clean state.

---

## Completion Report

After completing a local-development task, report:

```markdown
## Local environment scope

## Services and ports

## Docker and Compose changes

## Environment variables

## Initialization and dependencies

## Makefile and scripts

## Health and readiness

## Data persistence and reset behavior

## Security considerations

## Validation performed

## Documentation updates

## Known limitations
```

Keep the report factual and based on actual work performed.

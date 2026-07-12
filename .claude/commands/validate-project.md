---

name: validate-project
description: Audits the reptile knowledge platform across architecture, backend, frontend, database, infrastructure, security, testing, observability, accessibility, performance, documentation, and project governance. Executes safe validation commands and produces a prioritized technical report without modifying implementation files.
argument-hint: "[scope: full|phase-N|backend|frontend|database|infrastructure|security|documentation]"
disable-model-invocation: true
user-invocable: true
model: inherit
effort: high
---

# Validate Project

Audit the project and determine whether its current implementation, documentation, contracts, and development workflows are consistent, functional, secure, and ready for continued work.

Requested validation scope:

```text
$ARGUMENTS
```

If no argument was provided, use:

```text
full
```

This command is validation-only.

Do not implement features.

Do not fix findings automatically.

Do not rewrite files merely to improve style.

Do not create migrations.

Do not update dependencies.

Do not commit, push, reset, clean, stash, or discard changes.

Documentation may be updated only when explicitly requested. The default behavior is to report documentation findings without modifying files.

---

# Primary Objective

Produce an evidence-based technical assessment of the repository.

The validation must answer:

1. What currently exists?
2. What is working?
3. What is incomplete?
4. What is inconsistent?
5. What is unsafe?
6. Which validation commands pass?
7. Which validation commands fail?
8. Which failures were already present?
9. What blocks the current phase?
10. What is the highest-priority next action?
11. Is the project ready to start or complete the requested phase?

The report must distinguish:

```text
verified
partially_verified
not_verified
not_applicable
blocked
```

Do not present assumptions as verified facts.

---

# Mandatory Context

Before performing validation:

1. Read `CLAUDE.md`.
2. Inspect `.claude/skills/`.
3. Inspect `.claude/commands/`.
4. Read `.claude/skills/project-orchestrator/SKILL.md`.
5. Read `.claude/skills/testing-quality/SKILL.md`.
6. Read `.claude/skills/security/SKILL.md`.
7. Read `.claude/skills/documentation/SKILL.md`.
8. Identify and read every specialized skill relevant to the selected scope.
9. Inspect the repository structure.
10. Inspect `README.md`.
11. Inspect the current phase documentation.
12. Inspect feature plans when relevant.
13. Inspect accepted ADRs.
14. Inspect API specifications.
15. Inspect the Makefile.
16. Inspect Docker Compose.
17. Inspect `.env.example`.
18. Inspect CI workflows.
19. Inspect `git status --short`.
20. Inspect `git diff --stat`.
21. Inspect relevant uncommitted diffs.
22. Preserve all existing work.
23. Identify the current project phase.
24. Identify which validation tools and commands actually exist.

Do not assume the repository is complete.

Do not assume a documented command exists without checking.

Do not execute commands merely because they are listed in this file.

---

# Validation Scopes

Normalize the requested scope.

Supported values:

```text
full
governance
phase-0
phase-1
phase-2
phase-3
phase-4
phase-5
phase-6
backend
frontend
database
infrastructure
local-development
terraform
authentication
security
observability
testing
accessibility
performance
documentation
api
```

Accepted aliases:

```text
all -> full
project -> full
infra -> infrastructure
docker -> local-development
aws -> terraform
auth -> authentication
docs -> documentation
tests -> testing
ux -> accessibility
```

If the provided scope is unknown:

1. report the supported values;
2. do not execute validation commands;
3. stop.

---

# Validation Modes

The command should infer one of these modes:

## Static Validation

Inspects files and runs commands that do not require the application stack.

Examples:

* formatting;
* lint;
* type checking;
* build;
* Terraform validation;
* OpenAPI validation;
* Markdown inspection;
* configuration inspection.

## Local Integration Validation

Requires local services.

Examples:

* migrations;
* repository tests;
* API health;
* frontend connectivity;
* Keycloak integration;
* LocalStack resources.

## Full Environment Validation

Requires starting the complete local stack.

Examples:

* Docker Compose health;
* API readiness;
* frontend response;
* Keycloak availability;
* Mailpit availability;
* LocalStack initialization;
* end-to-end tests.

Do not start or mutate the full local environment unless it is necessary for the selected scope.

Running standard test setup and local containers is permitted when non-destructive and expected by the repository.

Do not reset volumes or delete data.

---

# Required Skill Selection

Always load:

```text
project-orchestrator
testing-quality
security
documentation
```

Load additional skills by scope.

## Governance

```text
documentation
project-orchestrator
```

## Backend

```text
go-backend
database
security
observability
testing-quality
```

## Frontend

```text
react-frontend
ux-design-system
security
testing-quality
```

## Database

```text
database
go-backend
security
testing-quality
```

## Infrastructure

```text
local-development
terraform-aws
security
observability
testing-quality
```

## Authentication

```text
authentication
security
go-backend
react-frontend
database
testing-quality
```

## Editorial Content

```text
content-editor
product-domain
security
react-frontend
go-backend
database
testing-quality
```

## Product Domain

```text
product-domain
documentation
database
go-backend
react-frontend
```

## Full

Use all relevant project skills, but do not re-read unrelated large files repeatedly.

---

# Repository Baseline

Inspect whether these paths exist:

```text
CLAUDE.md
README.md
.claude/skills/
.claude/commands/
apps/api/
apps/web/
infrastructure/
infrastructure/keycloak/
infrastructure/localstack/
infrastructure/terraform/
docs/
docs/product/
docs/architecture/
docs/development/
docs/runbooks/
docs/adr/
scripts/
test/
Makefile
compose.yaml
.env.example
.gitignore
.editorconfig
.github/workflows/
```

Classify each expected path as:

```text
present
missing
not_required_for_current_phase
```

Do not penalize a future-phase path for being absent when it is explicitly outside the current phase.

---

# Git Safety and Repository State

Inspect:

```bash
git status --short
git diff --stat
```

When needed, inspect relevant diffs.

Report:

* modified files;
* untracked files;
* staged files;
* merge conflicts;
* generated artifacts;
* suspicious secret-like files;
* unrelated pending changes.

Do not run:

```bash
git reset
git checkout
git restore
git clean
git stash
git commit
git push
git rebase
```

Do not mark a repository invalid merely because it contains intentional uncommitted work.

Do identify when uncommitted work makes a validation result uncertain.

---

# Project Governance Validation

Validate:

* `CLAUDE.md` exists;
* stack definitions are consistent;
* project phases are defined;
* prohibited practices are clear;
* commands reference existing skills;
* skills have distinct responsibilities;
* no skill contradicts `CLAUDE.md`;
* command names do not conflict unexpectedly;
* paths referenced by skills are reasonable;
* validation requirements are achievable;
* current and future behavior are distinguished.

Inspect every skill frontmatter for:

```text
name
description
argument-hint
disable-model-invocation
user-invocable
model
effort
paths
```

Not every field is mandatory, but metadata must be internally consistent.

Report:

* duplicate skill names;
* duplicate command names;
* ambiguous responsibilities;
* contradictory instructions;
* invalid or stale paths;
* commands invoking nonexistent skills;
* circular workflows;
* commands that could mutate real AWS unexpectedly;
* commands that falsely promise unsupported behavior.

Do not fail a skill merely because one optional metadata field is absent.

---

# Phase Validation

Identify the current phase from:

* roadmap;
* phase documents;
* implemented capabilities;
* completion evidence;
* repository structure;
* test and validation status.

Do not trust only a status label.

For the requested phase, evaluate:

```text
prerequisites
deliverables
acceptance criteria
validation evidence
documentation
known blockers
```

Classify phase status as:

```text
not_started
in_progress
blocked
complete
```

A phase is complete only when its acceptance criteria are both implemented and validated.

---

# Phase 0 Validation

Validate the foundation.

Expected capabilities:

```text
project structure
Claude Code configuration
documentation foundation
Go API foundation
React foundation
PostgreSQL
migrations
sqlc
Redis
LocalStack
Keycloak
Mailpit
Docker Compose
Terraform local foundation
structured logs
correlation IDs
health
readiness
tests
lint
build
CI
Makefile workflows
safe reset behavior
```

Expected commands may include:

```text
make bootstrap
make up
make down
make migrate
make seed
make validate
make test
```

Only validate commands that exist.

Expected URLs when the stack is running:

```text
http://localhost:3000
http://localhost:8080
http://localhost:8080/health
http://localhost:8080/ready
http://localhost:8081
http://localhost:8025
http://localhost:4566
```

Do not require the catalog, administration, gamification, or real AWS deployment during Phase 0.

---

# Phase 1 Validation

Validate the public catalog.

Expected capabilities:

```text
public home page
published species listing
published species detail
published article listing
published article detail
taxonomy presentation
editorial groups
search
filters
pagination
seed content
responsive public layout
loading states
empty states
error states
not-found states
references
media presentation
```

Verify that public responses exclude:

```text
draft content
internal notes
administrative metadata
unpublished media
private user data
```

Do not require authentication or administration.

---

# Phase 2 Validation

Validate users and authentication.

Expected capabilities:

```text
Keycloak local authentication
registration
login
logout
account recovery
account confirmation
user synchronization
profile
roles
permissions
protected APIs
protected frontend routes
backend authorization
access-control documentation
```

Verify:

* JWT signature validation;
* issuer validation;
* audience validation;
* expiration;
* provider-neutral identity;
* no password storage;
* no frontend-only authorization;
* profile mass-assignment protection;
* role-management separation.

---

# Phase 3 Validation

Validate administration.

Expected capabilities:

```text
admin layout
species management
article management
taxonomy management
media upload
drafts
editorial workflow
preview
publishing
permission-aware actions
audit events
```

Verify:

* public and admin routes are separated;
* draft content remains private;
* publishing is explicit;
* media uploads are validated;
* preview is protected;
* permissions are enforced by the backend;
* audit events exist for privileged actions.

---

# Phase 4 Validation

Validate the advanced editorial experience.

Expected capabilities may include:

```text
content schema versioning
advanced blocks
revisions
galleries
maps
comparisons
advanced SEO
conflict protection
editorial warnings
improved preview
```

Verify each block has:

```text
schema
backend validation
frontend editor
public renderer
tests
migration strategy
documentation
```

Do not require unplanned blocks.

---

# Phase 5 Validation

Validate gamification.

Expected capabilities may include:

```text
activity events
reading progress
achievements
collections
quizzes
levels
idempotency
anti-abuse
privacy controls
user progress UI
```

Verify:

* points are backend-derived;
* event replay is controlled;
* idempotency exists;
* user-submitted scores are not authoritative;
* activity data has retention and privacy considerations;
* abuse controls exist.

---

# Phase 6 Validation

Validate AWS deployment readiness or implementation.

Expected areas:

```text
Terraform environments
remote state
networking
ECR
ECS Fargate
S3
CloudFront
RDS
ElastiCache when required
Cognito
SES
SQS when required
CloudWatch
WAF
Route 53
ACM
Secrets Manager
CI/CD
backups
deployment runbooks
rollback
```

Do not run real AWS mutation.

Allowed by default:

```text
terraform fmt
terraform init -backend=false
terraform validate
terraform plan when safe and credentials are explicitly configured for read-only planning
```

Do not run:

```text
terraform apply
terraform destroy
```

against real AWS.

---

# Backend Validation

Inspect:

```text
apps/api/go.mod
apps/api/go.sum
apps/api/cmd/
apps/api/internal/
apps/api/migrations/
apps/api/queries/
apps/api/openapi/
apps/api/tests/
```

Validate:

* idiomatic Go;
* modular-monolith boundaries;
* package ownership;
* dependency direction;
* handler size;
* application use cases;
* domain rules;
* repository boundaries;
* explicit DTOs;
* error handling;
* context propagation;
* configuration;
* graceful shutdown;
* health;
* readiness;
* logging;
* correlation IDs;
* request limits;
* pagination;
* generated-code boundaries.

Look for:

```text
ignored errors
panic for expected behavior
global mutable state
context stored in structs
context.Background inside request flows
SQL in handlers
business logic in handlers
generic repository abstractions
unbounded goroutines
unbounded pagination
database models exposed as API responses
string comparisons for errors
unsafe reflection
duplicated validation
```

Do not fail code merely because it uses a pattern different from a preferred example when the actual architecture remains coherent.

---

# Backend Validation Commands

From the backend directory, run available commands such as:

```bash
gofmt -l .
go test ./...
go vet ./...
go build ./...
go mod verify
```

When configured:

```bash
golangci-lint run
govulncheck ./...
go test -race ./...
```

Use the race detector when concurrency is relevant or when the requested scope is `full`.

Do not run tools that are not installed or configured without first identifying their availability.

Classify unavailable tools as:

```text
not_configured
not_installed
```

Do not classify them automatically as implementation failures.

---

# Frontend Validation

Inspect:

```text
apps/web/package.json
apps/web/package-lock.json
apps/web/src/
apps/web/src/app/
apps/web/src/components/
apps/web/src/features/
apps/web/src/services/
apps/web/src/types/
apps/web/public/
apps/web/vite.config.*
apps/web/tsconfig*.json
apps/web/eslint.config.*
apps/web/vitest.config.*
apps/web/playwright.config.*
```

Validate:

* strict TypeScript;
* React structure;
* route organization;
* layout reuse;
* server-state ownership;
* TanStack Query usage;
* API-client centralization;
* form validation;
* semantic HTML;
* responsive behavior;
* loading states;
* empty states;
* error states;
* not-found behavior;
* forbidden states;
* accessibility;
* safe content rendering;
* design-token usage;
* bundle discipline.

Look for:

```text
any
unsafe assertions
fetch scattered through components
server data copied unnecessarily into local state
business rules in React
large components
missing keys
index keys for reorderable items
dangerouslySetInnerHTML
clickable div elements
placeholder-only labels
missing focus styles
missing error states
hardcoded secrets
raw environment access throughout code
```

Do not report `dangerouslySetInnerHTML` as exploitable without checking whether the content is trusted and sanitized. It should still be reviewed.

---

# Frontend Validation Commands

Use the selected package manager.

When npm is used, run available commands:

```bash
npm ci
npm run typecheck
npm run lint
npm run test
npm run build
```

Do not run `npm ci` if it would unnecessarily replace a developer's working dependency state unless dependency installation is required.

Prefer inspecting whether dependencies are already installed.

For E2E when configured and relevant:

```bash
npm run test:e2e
```

Do not claim E2E validation if required services were unavailable.

---

# Database Validation

Inspect:

```text
migrations
queries
sqlc configuration
generated sqlc code
repository mappings
seed data
integration tests
```

Validate:

* migration order;
* naming convention;
* up migrations;
* down migrations when meaningful;
* primary keys;
* foreign keys;
* nullability;
* check constraints;
* unique constraints;
* indexes;
* timestamps;
* deletion behavior;
* JSONB usage;
* query parameterization;
* pagination;
* deterministic sorting;
* generated-code freshness;
* repository error mapping.

Look for:

```text
SELECT *
string-concatenated SQL
missing foreign-key indexes
unbounded list queries
comma-separated multi-value fields
empty strings replacing null
soft delete everywhere
cascade deletion without analysis
missing publication filters
missing unique constraints
manually edited generated code
```

Do not recommend indexes without identifying a query pattern.

---

# Database Validation Commands

When configured and safe:

```bash
sqlc generate
```

Then inspect whether generation changes tracked files.

Run:

```bash
go test ./...
go build ./...
```

For migration validation, use only local or isolated PostgreSQL.

Possible commands:

```bash
make migrate
make migration-status
make seed
make test-integration
```

Do not reset or drop a database.

Do not run destructive down migrations unless the test environment is isolated and the command is explicitly designed for validation.

---

# API Validation

Inspect OpenAPI and implementation consistency.

Validate:

* specification syntax;
* API version;
* paths;
* methods;
* operation IDs;
* request schemas;
* response schemas;
* error schemas;
* authentication;
* permissions;
* pagination;
* filters;
* examples;
* public versus admin routes;
* content visibility.

Compare:

```text
OpenAPI path
router registration
handler request DTO
handler response DTO
frontend API function
frontend types
tests
```

Report contract drift.

Do not assume the OpenAPI file is authoritative when implementation clearly differs. Report the conflict and identify both sides.

---

# Authentication Validation

Validate:

* local Keycloak setup;
* realm import;
* public frontend client;
* authorization code flow;
* PKCE;
* redirect URIs;
* web origins;
* backend audience;
* JWT validation;
* JWKS caching;
* claim mapping;
* local user provisioning;
* role ownership;
* permissions;
* account status;
* profile security;
* logout behavior;
* recovery behavior.

Look for:

```text
client secrets in frontend
tokens in localStorage without documented decision
JWT decode without verification
missing issuer validation
missing audience validation
email used as only identity key
frontend role checks used as authorization
profile DTO containing roles
wildcard redirect URIs
wildcard CORS with credentials
raw tokens in logs
```

Do not require Cognito implementation before Phase 6.

Do verify that provider coupling is controlled if future Cognito compatibility is a project requirement.

---

# Content Editor Validation

Validate:

* explicit content document version;
* supported block types;
* frontend schema;
* backend schema;
* safe serialization;
* block IDs;
* heading rules;
* media references;
* link validation;
* public rendering;
* preview;
* draft behavior;
* publication validation;
* revisions when implemented;
* conflict handling when implemented.

Look for:

```text
arbitrary HTML
unvalidated TipTap JSON
unknown block deletion
base64 media
unsupported heading levels
unsafe links
arbitrary iframe embeds
public draft previews
article body logs
missing payload limits
```

Do not require advanced editor behavior before its phase.

---

# Local Development Validation

Inspect:

```text
compose.yaml
compose.override.yaml
Dockerfiles
.dockerignore
.env.example
Makefile
scripts/
LocalStack initialization
Keycloak initialization
Mailpit configuration
```

Validate:

* pinned image versions;
* service health checks;
* service dependencies;
* container-to-container URLs;
* browser-facing URLs;
* environment-variable ownership;
* named volumes;
* reset safety;
* startup reproducibility;
* no real AWS credentials;
* explicit LocalStack endpoints;
* deterministic initialization;
* local-only credentials;
* non-root execution where practical;
* logging to stdout and stderr.

Look for:

```text
latest image tags
localhost used between containers
global Docker prune
volumes removed by normal down
real AWS profile fallback
Docker socket mounts
privileged containers
secrets in image build
frontend secrets in VITE variables
fixed sleeps instead of readiness checks
manual realm setup
```

---

# Docker Compose Validation Commands

Run:

```bash
docker compose config
```

When full local validation is requested and safe:

```bash
docker compose build
docker compose up -d
docker compose ps
```

Do not use:

```bash
docker compose down --volumes
docker system prune
```

during validation.

If services are started, do not remove existing volumes.

Inspect health and logs without mutating data.

---

# Service Validation

When the local stack is running, validate available endpoints.

Potential checks:

```bash
curl --fail http://localhost:8080/health
curl --fail http://localhost:8080/ready
curl --fail http://localhost:3000
curl --fail http://localhost:4566/_localstack/health
curl --fail http://localhost:8025
```

Keycloak health paths vary by version.

Inspect the configured version and supported path before checking it.

Report:

* HTTP status;
* response behavior;
* connection failure;
* dependency failure;
* timeout.

Do not expose full response bodies if they contain sensitive data.

---

# LocalStack Validation

Validate:

* explicit dummy credentials;
* explicit endpoint;
* configured services;
* initialization scripts;
* deterministic resource names;
* idempotent resource creation;
* required buckets;
* required queues when implemented;
* no real-AWS fallback.

Possible safe inspection:

```bash
aws --endpoint-url=http://localhost:4566 s3 ls
```

Only run if the AWS CLI is available and dummy credentials are configured explicitly.

Do not use the developer's default AWS profile.

---

# Terraform Validation

Inspect:

```text
infrastructure/terraform/modules/
infrastructure/terraform/environments/
versions.tf
providers
variables
outputs
state configuration
lock files
tfvars examples
```

Validate:

* Terraform version constraint;
* provider pinning;
* environment isolation;
* module boundaries;
* typed variables;
* useful descriptions;
* validations;
* outputs;
* sensitive outputs;
* explicit LocalStack endpoints;
* no credentials in source;
* no state files committed;
* no empty speculative modules;
* resource naming;
* tags;
* IAM;
* encryption;
* public exposure;
* lifecycle protections;
* cost considerations.

Look for:

```text
unbounded provider versions
hardcoded access keys
committed tfstate
secret tfvars
one state for all environments
LocalStack endpoints in production
wildcard IAM
public databases
public Redis
0.0.0.0/0 internal ingress
generic apply commands
terraform provisioners for migrations
```

---

# Terraform Validation Commands

From the appropriate Terraform root:

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

When configured:

```bash
tflint
checkov -d .
trivy config .
terraform test
```

Do not run real AWS apply.

Do not run real AWS destroy.

Do not run a real AWS plan unless the target account, credentials, backend, and scope are explicitly known and safe.

A LocalStack plan may run when endpoints are explicit.

---

# Security Validation

Perform a risk-based review.

Evaluate:

```text
authentication
authorization
object-level access
input validation
output encoding
XSS
SQL injection
CSRF
CORS
CSP
security headers
rate limiting
file uploads
SSRF
path traversal
mass assignment
open redirects
secrets
logging
dependency security
Docker security
Terraform security
CI security
privacy
data retention
```

Classify findings by:

```text
critical
high
medium
low
informational
```

Every security finding must include:

```text
asset
threat
evidence
impact
likelihood
recommended mitigation
```

Do not report a generic OWASP category without repository evidence.

Do not describe a theoretical issue as currently exploitable unless the required conditions exist.

---

# Secret Validation

Inspect tracked and untracked project files for likely secret exposure.

Check:

* `.env`;
* Terraform variables;
* access keys;
* private keys;
* JWTs;
* client secrets;
* database passwords;
* GitHub tokens;
* API keys.

Do not print secret values in the report.

Redact evidence.

Example:

```text
AWS access key pattern found in infrastructure/example.tfvars.
Value redacted.
```

Do not scan unrelated user directories.

Do not transmit file contents externally.

---

# Upload Security Validation

When uploads exist, validate:

* permission;
* size limits;
* MIME allowlist;
* extension checks;
* detected file type;
* SVG policy;
* generated object keys;
* path safety;
* private storage;
* metadata;
* image dimensions;
* orphan cleanup;
* signed URL expiration;
* public delivery rules.

Do not require malware scanning before it is part of the approved architecture, but identify the risk when appropriate.

---

# Security Header Validation

When HTTP services run, inspect headers where practical.

Potential headers:

```text
Content-Security-Policy
X-Content-Type-Options
Referrer-Policy
Permissions-Policy
Strict-Transport-Security
Cross-Origin-Opener-Policy
Cross-Origin-Resource-Policy
```

Do not require HSTS for local HTTP.

Evaluate production configuration separately.

---

# Observability Validation

Validate:

* structured logs;
* stable field names;
* service and environment fields;
* correlation IDs;
* request logging;
* error logging;
* health;
* readiness;
* dependency criticality;
* startup logs;
* shutdown logs;
* audit events;
* metrics when implemented;
* traces when implemented;
* CloudWatch resources when implemented;
* runbooks.

Look for:

```text
raw tokens in logs
request bodies logged by default
article bodies logged
search terms logged
high-cardinality metric labels
raw paths as metric labels
health depending on optional services
readiness performing expensive operations
duplicate error logging
error messages used as metric dimensions
```

Do not require metrics or tracing during Phase 0 unless the project explicitly included them.

---

# Testing Validation

Inspect:

```text
unit tests
integration tests
E2E tests
fixtures
test builders
mocking strategy
test database
CI workflows
coverage configuration
lint configuration
```

Validate:

* behavior-oriented tests;
* positive and negative paths;
* isolation;
* deterministic time;
* deterministic data;
* no real credentials;
* no test-order dependency;
* no arbitrary sleeps;
* appropriate test level;
* critical authorization failures;
* migration tests;
* repository integration tests;
* frontend accessibility behavior;
* E2E critical journeys.

Look for:

```text
tests removed or skipped without reason
large snapshots
CSS selectors in behavior tests
real shared database use
hardcoded production URLs
flaky retries
waitForTimeout
time.Sleep
mocking the system under test completely
```

Do not penalize missing E2E tests before a critical user journey exists.

---

# CI Validation

Inspect workflows for:

* backend quality;
* frontend quality;
* infrastructure quality;
* integration tests;
* E2E;
* security scans;
* artifact handling;
* permissions;
* caching;
* tool pinning;
* secret safety;
* deployment approvals.

Validate:

* workflows call real repository commands;
* lockfiles are respected;
* privileged credentials are restricted;
* untrusted pull requests do not receive production secrets;
* action permissions are minimal;
* deployment and validation are separated.

Look for:

```text
actions using mutable master branches
broad write permissions
long-lived AWS keys
production secrets exposed to pull requests
npm install instead of deterministic install
missing Terraform validation
different commands locally and in CI
```

Do not require deployment workflows before Phase 6.

---

# Accessibility Validation

Validate:

* semantic HTML;
* landmarks;
* heading hierarchy;
* labels;
* keyboard access;
* visible focus;
* dialogs;
* focus restoration;
* form errors;
* live regions;
* touch targets;
* alternative text;
* status communication;
* reduced motion;
* responsive behavior.

Look for:

```text
clickable div
missing button names
placeholder-only labels
outline-none without replacement
color-only status
autoplay carousels
hover-only actions
missing alt text
multiple h1 headings
skipped heading levels
inaccessible drag-and-drop
```

Automated checks may assist.

Do not claim full accessibility compliance from static inspection alone.

Classify accessibility as:

```text
static_reviewed
automated_tested
keyboard_tested
screen_reader_tested
not_verified
```

---

# UX and Design-System Validation

Validate:

* semantic tokens;
* typography;
* content widths;
* spacing consistency;
* component variants;
* public versus admin distinction;
* mobile-first behavior;
* loading and error primitives;
* status consistency;
* responsible wildlife presentation.

Look for:

```text
repeated arbitrary colors
every section as a card
article text spanning full width
critical actions hidden on mobile
generic SaaS dashboard public design
sensational danger presentation
inconsistent scientific-name styling
```

Do not reduce design quality to subjective preference.

Tie findings to consistency, usability, accessibility, or product principles.

---

# Performance Validation

Review only evidence-supported performance risks.

## Backend

Check:

* N+1 queries;
* unbounded result sets;
* missing pagination;
* repeated serialization;
* external calls without timeout;
* long transactions;
* unnecessary concurrency;
* inefficient regex;
* excessive allocations in hot paths.

## Database

Check:

* query patterns;
* indexes;
* deterministic sorting;
* full-table scans when evidence exists;
* excessive joins;
* count-query cost;
* connection-pool configuration.

## Frontend

Check:

* oversized dependencies;
* route splitting;
* image loading;
* missing dimensions;
* unnecessary rerenders;
* duplicate requests;
* bundle size;
* full-dataset browser pagination.

## Infrastructure

Check:

* excessive services;
* unnecessary NAT or VPC endpoints;
* uncontrolled logs;
* oversized resources;
* missing cache headers.

Do not claim an N+1 problem solely because a loop contains repository calls without inspecting execution flow.

Do not recommend caching without a measured or obvious repeated-cost problem.

---

# Dependency Validation

Inspect:

* Go modules;
* frontend packages;
* Terraform providers;
* container images;
* GitHub Actions.

Validate:

* pinned versions;
* lockfiles;
* unused dependencies;
* overlapping libraries;
* abandoned packages;
* suspicious forks;
* known scanner findings when tools are available.

Potential commands:

```bash
go mod verify
govulncheck ./...
npm audit
```

Use the repository's selected policy.

Do not make dependency changes.

Do not treat every low-severity advisory as exploitable.

---

# Documentation Validation

Inspect:

```text
README.md
product vision
roadmap
domain glossary
phase plans
feature plans
architecture documents
C4 diagrams
ADRs
OpenAPI
development guides
testing guide
security documents
runbooks
Terraform documentation
Keycloak documentation
LocalStack documentation
```

Validate:

* commands exist;
* paths exist;
* ports match configuration;
* environment variables match `.env.example`;
* current and planned behavior are distinct;
* links work;
* terminology is consistent;
* diagrams match implementation;
* ADR statuses are valid;
* OpenAPI matches routes;
* destructive commands contain warnings;
* no secrets appear;
* phase status reflects evidence.

Look for:

```text
unimplemented features documented as current
invented commands
broken relative links
future AWS shown as deployed
duplicate sources of truth
obsolete ADRs appearing active
runbooks with no diagnostic commands
```

Do not fail the project merely because planned documentation is intentionally marked as planned.

---

# Dead Code and Repository Hygiene

Inspect for:

```text
TODO
FIXME
HACK
XXX
deprecated code
unused packages
orphan files
duplicate configuration
stale generated code
temporary files
debug logs
commented-out implementation
old migrations
backup files
```

Classify each finding.

A TODO is not automatically a defect.

Report whether it:

```text
blocks current phase
creates risk
is ordinary backlog
is stale
```

Do not remove anything.

---

# Makefile Validation

Inspect public targets.

Validate:

* help output;
* command existence;
* safe shell behavior;
* failure propagation;
* target naming;
* destructive warnings;
* consistent Docker Compose command;
* consistent package manager;
* local versus real AWS separation.

Potential safe command:

```bash
make help
```

Do not run destructive targets.

Report targets that reference nonexistent files or commands.

Do not penalize the project for not having every optional target.

---

# Environment Variable Validation

Compare:

```text
.env.example
Compose variables
backend configuration
frontend environment schema
Keycloak configuration
Terraform variables
CI variables
documentation
```

Validate:

* required values documented;
* no real secrets;
* no backend secrets prefixed with `VITE_`;
* internal and browser URLs distinguished;
* LocalStack endpoints explicit;
* production-only variables identified;
* unused variables identified;
* missing variables identified.

Do not print actual `.env` values.

---

# Validation Command Discovery

Before executing commands:

1. inspect the Makefile;
2. inspect `package.json`;
3. inspect Go module location;
4. inspect Terraform roots;
5. inspect scripts;
6. inspect CI commands;
7. check whether required binaries exist.

Build a command matrix:

```text
command
purpose
working directory
exists
safe
requires services
destructive
selected for execution
```

Do not execute a command marked destructive.

Do not execute a command against real infrastructure.

---

# Recommended Validation Order

Use this order when scope is `full`.

## 1. Repository inspection

```text
Git state
structure
documentation
configuration
```

## 2. Static configuration

```text
Docker Compose config
OpenAPI
Terraform format
Terraform validate
```

## 3. Backend

```text
format
tests
vet
lint
build
dependency verification
```

## 4. Frontend

```text
typecheck
lint
tests
build
```

## 5. Database

```text
sqlc generation
migration validation
repository integration
```

## 6. Local services

```text
Compose health
application endpoints
LocalStack
Keycloak
Mailpit
```

## 7. E2E

Only when configured and prerequisites are healthy.

## 8. Consolidated assessment

Do not continue running dependent checks after a foundational blocker makes their results meaningless.

Example:

If dependencies cannot install, record frontend validation as blocked rather than running every script.

---

# Command Result Classification

For every command, classify:

```text
passed
failed
blocked
skipped
not_configured
not_installed
not_applicable
```

Record:

* command;
* working directory;
* result;
* concise evidence;
* relevant output summary;
* whether failure appears pre-existing;
* affected category.

Do not paste excessively long logs.

Include the most relevant error lines.

---

# Finding Severity

Use:

## Critical

A finding that may cause:

* secret compromise;
* unauthorized administrative access;
* public exposure of private content;
* destructive real-cloud behavior;
* remote code execution;
* irrecoverable data loss.

## High

A finding that may cause:

* authorization bypass;
* significant data-integrity failure;
* broken production deployment;
* unsafe upload behavior;
* failed required migrations;
* unusable critical user flow.

## Medium

A finding that may cause:

* maintainability risk;
* missing failure handling;
* incomplete test coverage for important behavior;
* contract drift;
* accessibility barrier;
* operational diagnosis difficulty.

## Low

A finding involving:

* minor consistency;
* limited maintainability issue;
* non-blocking documentation gap;
* small UX defect;
* localized technical debt.

## Informational

Observation without an immediate defect.

Do not inflate severity.

A failed formatting check is normally not critical.

A committed real credential is critical.

---

# Finding Confidence

Classify confidence as:

```text
confirmed
high_confidence
possible
requires_runtime_verification
```

Use `confirmed` only when evidence is direct.

Examples:

```text
confirmed:
A route returns draft records without a publication filter.

possible:
A query may need an index based on expected future volume.
```

Do not present speculative findings as confirmed.

---

# Finding Format

Each finding must include:

```markdown
### FINDING-ID — Title

Severity:
Confidence:
Category:
Phase impact:

Evidence:

Impact:

Recommended action:

Validation:
```

Example:

```markdown
### SEC-001 — Frontend client secret is exposed

Severity: Critical  
Confidence: Confirmed  
Category: Security  
Phase impact: Blocks Phase 2 completion

Evidence:

`VITE_AUTH_CLIENT_SECRET` is present in `.env.example` and consumed by the frontend.

Impact:

Any browser user can retrieve the client secret from the compiled JavaScript bundle.

Recommended action:

Use a public OIDC client with Authorization Code Flow and PKCE. Remove the client secret from frontend configuration.

Validation:

Rebuild the frontend and confirm no client secret is present in generated assets.
```

Do not include secret values in evidence.

---

# Scoring Model

Produce category scores only when enough evidence exists.

Categories:

```text
Governance
Architecture
Backend
Frontend
Database
API
Local Development
Infrastructure
Security
Authentication
Testing
Observability
Accessibility
Performance
Documentation
```

Score each applicable category from:

```text
0 to 100
```

Use these bands:

```text
90–100 Excellent
80–89 Good
70–79 Acceptable with gaps
60–69 Needs improvement
40–59 High risk
0–39 Critical condition
```

Do not fabricate numerical precision.

Scores are comparative indicators, not formal certification.

---

# Scoring Guidance

Start from `100` for an applicable category.

Suggested deductions:

```text
Critical finding: 20–40 points
High finding: 10–20 points
Medium finding: 3–10 points
Low finding: 1–3 points
Missing required foundation: up to 25 points
Unverified required behavior: up to 15 points
```

Apply judgment.

Avoid double-deducting the same root cause across several findings.

Example:

A missing backend test suite may affect both Backend and Testing, but deductions should reflect different consequences without exaggeration.

---

# Overall Score

Calculate an overall score only from applicable and sufficiently reviewed categories.

Weight areas according to current phase.

Suggested Phase 0 weighting:

```text
Governance: 10%
Backend: 10%
Frontend: 10%
Database: 8%
Local Development: 15%
Infrastructure: 10%
Security: 12%
Testing: 12%
Observability: 5%
Documentation: 8%
```

Later phases may assign greater weight to:

```text
Product Domain
API
Authentication
Accessibility
Performance
```

Do not score future-phase capabilities as zero.

Mark them:

```text
not_applicable
```

---

# Readiness Classification

Classify project readiness.

## Not Ready

Critical blockers or missing foundational requirements exist.

## Ready with Blockers

Some work can continue, but the requested phase cannot be completed safely.

## Ready with Warnings

No blocking issue exists, but medium-risk gaps remain.

## Ready

Required current-phase capabilities exist and validation passes.

## Fully Validated

All required static, integration, and end-to-end checks for the selected scope were executed successfully.

Do not use `Fully Validated` when runtime or E2E checks were skipped.

---

# Phase Gate Rules

A phase must not be marked complete when any of these applies:

```text
required build fails
required tests fail
required migration fails
required service is unhealthy
critical security finding exists
high authorization finding exists
public contract is inconsistent
required documentation is missing
completion evidence is false or absent
```

A phase may remain `in_progress` with medium or low findings when acceptance criteria are still satisfied and risks are documented.

---

# Recommended Next Action

Select exactly one highest-priority next action.

Selection order:

1. critical security or data issue;
2. blocker for the current phase;
3. failed required validation;
4. broken contract;
5. missing foundational dependency;
6. highest-risk maintainability or accessibility issue;
7. next incomplete planned increment.

The recommendation must be:

* specific;
* executable;
* limited in scope;
* tied to evidence.

Good example:

```text
Run `/fix-bug API readiness returns 200 when PostgreSQL is unavailable`.
```

Bad example:

```text
Improve security.
```

Do not implement the recommendation automatically.

---

# Validation Report File

By default, return the report in the response only.

Create a persistent report only when:

* the user explicitly requests it;
* the repository already maintains validation reports;
* the current phase document requires completion evidence;
* the command is invoked with a report-oriented scope.

Recommended path:

```text
docs/reports/project-validation.md
```

Or timestamped reports when the project adopts that convention:

```text
docs/reports/project-validation-YYYY-MM-DD.md
```

Do not create a new report file on every ordinary execution without a maintenance strategy.

---

# Validation Report Structure

Use:

```markdown
# Project Validation Report

## Validation metadata

## Executive summary

## Project readiness

## Current phase

## Scope

## Git and repository state

## Validation command results

## Category scores

## Critical findings

## High findings

## Medium findings

## Low findings

## Informational observations

## Phase acceptance assessment

## Security assessment

## Test and quality assessment

## Documentation and contract assessment

## Blocked or skipped validation

## Recommended next action

## Remaining uncertainty
```

Do not hide skipped checks.

---

# Executive Summary

The summary should include:

```text
overall score when available
readiness classification
current phase
findings by severity
passed validations
failed validations
blocked validations
highest-priority risk
recommended next action
```

Example:

```text
Overall score: 84/100
Readiness: Ready with warnings
Current phase: Phase 0 — Foundation

Critical: 0
High: 1
Medium: 4
Low: 7

Primary blocker:
Keycloak realm import is not reproducible.

Recommended next action:
Create a versioned local realm configuration and validate clean startup.
```

Do not overstate precision.

---

# Compact Scorecard

When enough evidence exists, include:

```text
PROJECT SCORE

Overall: 84/100

Governance:        92
Architecture:      88
Backend:           86
Frontend:          84
Database:          80
Local Development: 76
Infrastructure:    82
Security:          79
Testing:           81
Observability:     85
Accessibility:     78
Documentation:     91
```

Use `N/A` for non-applicable or unverified categories.

Do not use zero for unverified categories.

---

# Validation Evidence

For every positive conclusion, identify evidence.

Examples:

```text
Backend build verified by `go build ./...`.
Frontend types verified by `npm run typecheck`.
Docker Compose syntax verified by `docker compose config`.
Terraform syntax verified by `terraform validate`.
```

Static file existence alone is not sufficient evidence that runtime behavior works.

---

# Pre-Existing Failures

When a command fails:

1. inspect current uncommitted changes;
2. inspect relevant history only when readily available;
3. determine whether the failure appears related to current work;
4. classify as:

```text
likely_introduced_by_current_changes
likely_pre_existing
uncertain
```

Do not blame current work without evidence.

Do not attempt broad repairs.

---

# Blocked Validation

When validation cannot run, explain:

```text
what was blocked
why
what prerequisite is missing
what risk remains
how to validate later
```

Example:

```text
Playwright E2E tests were not executed because Keycloak was unhealthy.
Authentication flow remains unverified.
```

Do not convert blocked validation into failure unless the missing prerequisite itself is a required defect.

---

# Runtime Safety

Do not execute requests or commands that:

* delete data;
* publish content;
* assign roles;
* send real email;
* invoke real AWS;
* modify DNS;
* alter user accounts;
* perform infrastructure apply;
* reset local volumes.

Read-only API requests are allowed.

Test-created data is allowed only in an isolated test environment and through documented test commands.

---

# Real AWS Safety

Before any AWS CLI or Terraform interaction, determine whether the target is:

```text
LocalStack
real AWS
unknown
```

If unknown:

* do not execute;
* report the uncertainty.

For LocalStack:

* require explicit endpoint;
* require dummy credentials.

For real AWS:

* default to read-only validation;
* do not mutate;
* report account, principal, and region only when safely available;
* do not expose credentials.

Do not run apply or destroy.

---

# Validation Integrity

Do not:

* alter tests to obtain a pass;
* disable lint rules;
* delete failing files;
* modify implementation;
* change configuration;
* regenerate and commit files silently;
* update dependencies;
* start fixing findings;
* downgrade findings to improve the score;
* claim commands passed without execution.

If a generator is run and changes files, report the generated diff and leave it uncommitted.

Do not automatically revert it.

---

# Completion Criteria

This command execution is complete only when:

* the scope was normalized;
* mandatory context was inspected;
* relevant skills were selected;
* repository state was preserved;
* safe validation commands were discovered;
* applicable validation commands were executed;
* skipped and blocked checks were identified;
* findings were evidence-based;
* severity and confidence were assigned;
* current phase was assessed;
* category scores were calculated only when justified;
* readiness was classified;
* one recommended next action was selected;
* no implementation correction was performed;
* no destructive operation occurred;
* no result was falsely reported.

---

# Final Response Format

Use:

```markdown
## Validation summary

## Project readiness

## Current phase

## Scope validated

## Command results

## Scorecard

## Critical findings

## High findings

## Medium findings

## Low findings

## Phase acceptance assessment

## Blocked or skipped validation

## Recommended next action

## Remaining uncertainty
```

When there are no findings in a severity category, state:

```text
None identified.
```

Do not omit failed or blocked validations.

---

# Prohibited Behavior

Do not:

* implement fixes;
* refactor code;
* update dependencies;
* create migrations;
* modify application behavior;
* rewrite documentation by default;
* start the next phase;
* reset Git;
* discard user changes;
* clean the repository;
* remove Docker volumes;
* prune Docker globally;
* run destructive database operations;
* apply or destroy real AWS infrastructure;
* expose secrets;
* print full `.env` files;
* print raw tokens;
* claim accessibility compliance from static checks;
* claim production readiness from local validation alone;
* treat LocalStack as proof of AWS parity;
* score unimplemented future-phase features as failures;
* invent validation evidence;
* automatically invoke `/fix-bug` or `/implement-feature`.

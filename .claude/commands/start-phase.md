---

name: start-phase
description: Starts or resumes a project phase by inspecting the repository, validating prerequisites, selecting the required skills, creating a scoped execution plan, and implementing the next complete increment.
argument-hint: "[phase-number-or-phase-name]"
disable-model-invocation: true
user-invocable: true
model: inherit
effort: high
------------

# Start Project Phase

Start or resume the requested project phase.

Requested phase:

```text
$ARGUMENTS
```

If no phase argument was provided, inspect the repository and identify the earliest incomplete phase.

This command must not automatically implement an entire phase in one uncontrolled operation.

Its responsibility is to:

1. identify the requested phase;
2. inspect the current repository state;
3. verify prerequisites;
4. determine what is already complete;
5. identify gaps;
6. select the required project skills;
7. create or update the phase execution plan;
8. implement the smallest complete next increment;
9. validate the increment;
10. report progress without advancing to another phase.

---

## Mandatory Context

Before planning or changing files:

1. Read `CLAUDE.md`.
2. Inspect `.claude/skills/`.
3. Read the `project-orchestrator` skill.
4. Read the `documentation` skill.
5. Read the `testing-quality` skill.
6. Identify additional technical skills required by the phase.
7. Inspect the repository structure.
8. Inspect current documentation.
9. Inspect the Git working tree.
10. Identify uncommitted user changes.
11. Preserve all unrelated changes.
12. Identify the current project phase and completion status.

Do not assume the repository is empty.

Do not overwrite uncommitted work.

Do not advance to another phase.

---

## Official Project Phases

### Phase 0 — Foundation

Scope:

* repository structure;
* Claude Code configuration;
* project skills;
* custom commands;
* Docker Compose;
* minimal Go backend;
* minimal React frontend;
* PostgreSQL;
* Redis;
* LocalStack;
* Keycloak;
* Mailpit;
* Terraform foundation;
* CI;
* tests;
* lint;
* structured logs;
* health and readiness;
* development documentation.

Expected local workflow:

```bash
cp .env.example .env
make bootstrap
make up
make migrate
make seed
make validate
make test
```

Expected services:

```text
Frontend:   http://localhost:3000
Backend:    http://localhost:8080
Health:     http://localhost:8080/health
Readiness:  http://localhost:8080/ready
Keycloak:   http://localhost:8081
Mailpit:    http://localhost:8025
LocalStack: http://localhost:4566
```

Do not implement the complete reptile catalog during Phase 0.

---

### Phase 1 — Public Catalog

Scope:

* public home page;
* species listing;
* species detail page;
* article listing;
* article detail page;
* taxonomy;
* editorial groups;
* public search;
* filters;
* pagination;
* seed content;
* responsive public layout;
* public error and empty states;
* references and media presentation.

Dependencies:

* Phase 0 must be complete;
* backend, frontend, database, and local environment must run;
* migrations and seed commands must work.

Do not implement authentication or administration unless required only as a harmless extension point.

---

### Phase 2 — Users and Authentication

Scope:

* Keycloak-backed registration;
* login;
* logout;
* account confirmation;
* account recovery;
* local user synchronization;
* user profile;
* roles;
* permissions;
* protected backend routes;
* protected frontend routes;
* access-control documentation.

Dependencies:

* Phase 0 complete;
* public application running;
* Keycloak initialized reproducibly;
* user schema and migrations available.

Do not implement the administration dashboard during this phase.

---

### Phase 3 — Administration

Scope:

* admin layout;
* species management;
* article management;
* taxonomy management;
* media upload;
* drafts;
* editorial workflow;
* preview;
* publishing;
* permission-aware actions;
* audit events.

Dependencies:

* Phase 2 authentication and authorization complete;
* editor and administrator roles available;
* media storage available;
* public content contracts established.

Do not implement advanced gamification.

---

### Phase 4 — Advanced Editorial Experience

Scope:

* advanced content blocks;
* article revisions;
* rich media;
* galleries;
* maps;
* comparisons;
* advanced SEO;
* social metadata;
* improved preview;
* conflict protection;
* editorial quality warnings.

Dependencies:

* Phase 3 administration complete;
* article editor operational;
* content schema versioned;
* publication flow stable.

Do not add features without migration and compatibility strategies.

---

### Phase 5 — Gamification

Scope:

* activity events;
* reading progress;
* achievements;
* collections;
* quizzes;
* levels;
* anti-abuse rules;
* idempotency;
* user-facing progress interface.

Dependencies:

* authentication complete;
* public content stable;
* event model defined;
* privacy and security review complete.

Do not accept client-submitted points as authoritative.

---

### Phase 6 — AWS Deployment

Scope:

* real AWS infrastructure;
* isolated Terraform environments;
* S3 and CloudFront;
* ECS Fargate;
* ECR;
* RDS PostgreSQL;
* ElastiCache when required;
* Cognito;
* SES;
* SQS when required;
* CloudWatch;
* WAF;
* Route 53;
* ACM;
* secrets;
* CI/CD;
* backups;
* deployment and rollback runbooks.

Dependencies:

* application behavior stable locally;
* security review complete;
* Terraform modules validated;
* deployment explicitly authorized.

Do not execute `terraform apply` against real AWS without explicit authorization.

---

## Phase Identification

Normalize the provided argument.

Accepted examples:

```text
0
phase 0
foundation
Phase 0 — Foundation

1
phase 1
public catalog
Phase 1 — Public Catalog
```

Map the request to exactly one official phase.

If the argument does not match a known phase:

1. report the accepted phases;
2. do not modify files;
3. stop execution.

Do not silently choose a phase when the argument is invalid.

---

## Phase Status Classification

Classify the requested phase as:

```text
not_started
in_progress
blocked
complete
```

### Not Started

No meaningful phase deliverables exist.

### In Progress

Some deliverables exist, but acceptance criteria are not fully met.

### Blocked

The phase cannot proceed because prerequisites are missing or invalid.

### Complete

All acceptance criteria are satisfied and validated.

Do not classify a phase as complete based only on file existence.

Validation evidence is required.

---

## Prerequisite Validation

Before starting the requested phase:

1. inspect preceding phases;
2. verify their acceptance criteria;
3. verify required contracts;
4. verify required services;
5. verify migrations and tests;
6. identify missing prerequisites.

If a previous phase is incomplete:

* classify the requested phase as blocked;
* report the missing prerequisite;
* propose the smallest prerequisite increment;
* do not implement later-phase features.

Exception:

A harmless documentation or planning task may proceed without implementation, but must remain clearly marked as preparatory.

---

## Repository Inspection

Inspect at least:

```text
CLAUDE.md
README.md
.claude/skills/
.claude/commands/
apps/api/
apps/web/
infrastructure/
docs/
scripts/
test/
Makefile
compose.yaml
.env.example
.github/workflows/
```

Inspect only paths that exist.

Also inspect:

```bash
git status --short
git diff --stat
git diff
```

Do not discard or modify unrelated user changes.

---

## Required Skill Selection

Always load:

```text
project-orchestrator
testing-quality
documentation
```

Load additional skills according to the phase.

### Phase 0

Use:

```text
go-backend
react-frontend
database
local-development
terraform-aws
security
observability
ux-design-system
documentation
testing-quality
```

Authentication may be used for Keycloak foundation only.

Do not implement complete Phase 2 authentication.

### Phase 1

Use:

```text
product-domain
go-backend
react-frontend
database
ux-design-system
testing-quality
security
documentation
```

Use `content-editor` only for public content rendering contracts, not administrative editing.

### Phase 2

Use:

```text
authentication
go-backend
react-frontend
database
security
testing-quality
documentation
observability
local-development
```

### Phase 3

Use:

```text
product-domain
authentication
content-editor
go-backend
react-frontend
database
security
observability
ux-design-system
testing-quality
documentation
```

### Phase 4

Use:

```text
content-editor
product-domain
go-backend
react-frontend
database
security
observability
ux-design-system
testing-quality
documentation
```

### Phase 5

Use:

```text
product-domain
authentication
go-backend
react-frontend
database
security
observability
testing-quality
documentation
```

### Phase 6

Use:

```text
terraform-aws
local-development
security
observability
authentication
database
testing-quality
documentation
```

Do not load unrelated skills.

---

## Phase Planning Document

Create or update:

```text
docs/product/phases/phase-<number>.md
```

Example:

```text
docs/product/phases/phase-0.md
```

If the directory does not exist, create it only when writing the first phase plan.

The document should contain:

```markdown
# Phase N — Phase Name

## Status

## Objective

## Current state

## Scope

## Out of scope

## Prerequisites

## Deliverables

## Technical workstreams

## Execution increments

## Acceptance criteria

## Validation commands

## Risks

## Decisions required

## Completion evidence
```

Do not mark incomplete items as completed.

Preserve previous completion evidence.

---

## Workstream Definition

Break the phase into coherent workstreams.

Possible Phase 0 workstreams:

```text
repository and documentation
backend foundation
frontend foundation
database foundation
local services
authentication foundation
LocalStack resources
Terraform foundation
quality and CI
observability
security baseline
```

Possible Phase 1 workstreams:

```text
domain model
species API
articles API
public frontend
search and filters
seed content
responsive design
public testing
```

Do not create one large workstream named “implement phase.”

---

## Execution Increments

Break each workstream into small vertical increments.

A good increment:

* produces observable behavior;
* has clear files and contracts;
* can be validated;
* leaves the repository usable;
* does not depend on unimplemented future functionality.

Example Phase 0 increments:

```text
1. Create repository foundation and developer commands.
2. Create minimal Go API with health and readiness.
3. Create minimal React application shell.
4. Add PostgreSQL and migration workflow.
5. Add Docker Compose dependencies.
6. Add LocalStack S3 initialization.
7. Add Keycloak realm foundation.
8. Add Terraform local environment.
9. Add CI and quality gates.
10. Complete documentation and clean-state validation.
```

Do not implement all increments in one step unless the repository is extremely small and validation remains reliable.

---

## Next Increment Selection

Select exactly one next increment.

Choose the increment that:

1. satisfies missing prerequisites;
2. is the earliest incomplete dependency;
3. produces a complete and testable result;
4. has manageable scope;
5. minimizes unrelated changes.

Do not select work merely because it is visually interesting.

Foundation and contracts come before dependent UI.

---

## Implementation Plan

Before modifying files, present:

### Requested phase

The normalized phase.

### Phase status

One of:

```text
not_started
in_progress
blocked
complete
```

### Current evidence

What exists and what is missing.

### Required skills

Only relevant skills.

### Selected increment

The one increment that will be implemented now.

### Affected areas

Expected files, modules, contracts, and services.

### Risks

Technical, security, migration, compatibility, or scope risks.

### Validation

Commands and manual checks.

### Acceptance criteria

Observable completion requirements for the selected increment.

Do not begin implementation before establishing this plan.

---

## Implementation Rules

During implementation:

1. implement only the selected increment;
2. preserve unrelated changes;
3. use existing project conventions;
4. avoid speculative abstractions;
5. avoid future-phase features;
6. add tests proportional to risk;
7. keep contracts synchronized;
8. update phase documentation;
9. run progressive validation;
10. stop when the increment is complete.

Do not automatically continue to the next increment.

---

## Phase 0 Special Rules

Phase 0 must remain minimal.

Allowed:

* application skeletons;
* health endpoints;
* basic public layout;
* Docker services;
* migrations;
* local infrastructure;
* CI;
* logging;
* configuration;
* documentation.

Not allowed:

* complete species CRUD;
* complete article editor;
* gamification;
* production AWS deployment;
* complex event architecture;
* advanced search;
* advanced admin dashboard.

Do not turn foundation work into feature implementation.

---

## Phase 1 Special Rules

Public endpoints must return only published content.

Public pages must handle:

* loading;
* empty;
* error;
* not found;
* responsive behavior.

Species and taxonomy terminology must follow the product-domain skill.

Do not introduce user-specific behavior before Phase 2.

---

## Phase 2 Special Rules

Authentication must use Keycloak locally.

The architecture must remain compatible with future Cognito.

Backend authorization is mandatory.

Frontend route protection is not sufficient.

Do not store passwords in the application database.

---

## Phase 3 Special Rules

Administrative actions require explicit permissions.

Publishing must use explicit workflow commands.

Media uploads must remain private until approved for public use.

Draft preview must not be publicly accessible.

Do not expose unpublished content through public endpoints or caches.

---

## Phase 4 Special Rules

Every new content block requires:

* schema;
* frontend editor;
* backend validation;
* public renderer;
* migration strategy;
* tests;
* documentation.

Do not add editor-only formats that the public renderer cannot handle.

---

## Phase 5 Special Rules

Gamification rules must be backend-owned.

Activity events require:

* idempotency;
* abuse controls;
* privacy review;
* explicit event schema;
* validation;
* observability.

Do not trust client-provided scores.

---

## Phase 6 Special Rules

Before any real AWS operation:

1. verify the target AWS account;
2. verify principal;
3. verify region;
4. verify Terraform backend;
5. inspect the saved plan;
6. identify destructive actions;
7. require explicit authorization.

Preparation, planning, and validation do not imply permission to deploy.

Never run real AWS apply or destroy automatically.

---

## Validation Strategy

Run validation appropriate to the selected increment.

### Backend

```bash
go test ./...
go vet ./...
golangci-lint run
go build ./...
```

### Frontend

```bash
npm run typecheck
npm run lint
npm run test
npm run build
```

### Database

```bash
sqlc generate
make migrate
make seed
```

Use isolated or local development databases only.

### Docker

```bash
docker compose config
docker compose build
docker compose up -d
docker compose ps
```

### Terraform

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
tflint
```

### Full project

```bash
make validate
make test
```

Only run commands that exist.

Do not invent missing Makefile targets.

Do not claim commands were run when they were not.

---

## Completion Evidence

Record evidence in the phase document.

Example:

```markdown
## Completion evidence

### Increment: Minimal API foundation

Status: Complete

Validation:

- `go test ./...` — passed
- `go vet ./...` — passed
- `curl http://localhost:8080/health` — returned `200`
- `curl http://localhost:8080/ready` — returned `200`

Files:

- `apps/api/cmd/api/main.go`
- `apps/api/internal/platform/http/server.go`
- `apps/api/internal/platform/health/handler.go`
```

Do not record hypothetical evidence.

---

## Phase Completion Assessment

After implementing the selected increment, reassess the phase.

Possible result:

```text
phase remains in_progress
phase is now blocked
phase is now complete
```

A phase is complete only when:

* every required deliverable exists;
* all acceptance criteria are met;
* required validation passes;
* documentation is current;
* known blockers are resolved;
* completion evidence is recorded.

Do not mark the phase complete because one increment passed.

---

## Git Behavior

Do not automatically commit unless explicitly requested.

Do not:

* stage unrelated changes;
* reset the working tree;
* discard user modifications;
* rewrite history;
* force push;
* amend existing commits.

You may suggest a focused commit message after implementation.

---

## Failure Handling

If implementation fails:

1. stop expanding the change;
2. preserve the repository in the safest available state;
3. identify the exact failing validation;
4. explain whether the failure existed before the task;
5. document the remaining risk;
6. avoid marking the increment complete;
7. update the phase plan honestly.

Do not hide failures.

Do not remove tests to make validation pass.

---

## Final Report

Use:

```markdown
## Requested phase

## Phase status

## Selected increment

## Implemented changes

## Files changed

## Skills used

## Validation performed

## Acceptance criteria

## Phase progress

## Blockers and risks

## Recommended next increment

## Suggested commit
```

The recommended next increment is informational only.

Do not begin it automatically.

---

## Definition of Done

This command execution is complete only when:

* the requested phase was normalized;
* prerequisites were inspected;
* phase status was identified;
* relevant skills were selected;
* the phase plan was created or updated;
* exactly one coherent increment was selected;
* the increment was implemented or a blocker was documented;
* relevant validation was executed;
* completion evidence was recorded;
* the phase was not advanced beyond its scope;
* no unrelated changes were discarded;
* results were reported honestly.

---

## Prohibited Behavior

Do not:

* implement an entire phase without incremental control;
* skip prerequisite validation;
* advance to a later phase;
* create future-phase infrastructure;
* deploy to real AWS;
* discard uncommitted work;
* overwrite unrelated files;
* create empty architectural layers;
* create placeholder commands that falsely appear functional;
* mark incomplete criteria as complete;
* report unexecuted validation as passed;
* remove tests to obtain a green result;
* hide blockers;
* automatically commit;
* automatically continue to the next increment.

---

name: project-orchestrator
description: Coordinates implementation work across the reptile knowledge platform. Use this skill for new features, project phases, architectural changes, cross-module work, technical planning, scope control, dependency identification, and validation of completion criteria.
when_to_use: Use whenever a task affects multiple modules, introduces a feature, changes architecture, starts or completes a project phase, requires several technical skills, or needs an implementation plan and final validation.
argument-hint: "[task-or-feature-description]"
disable-model-invocation: false
user-invocable: true
model: inherit
effort: high
------------

# Project Orchestrator

## Objective

Coordinate technical work across the reptile knowledge platform while preserving project scope, architecture, quality, security, and phased delivery.

Use this skill as the entry point for relevant implementation tasks.

The orchestrator must:

* identify the current project phase;
* understand the requested outcome;
* inspect the current repository state;
* select the required specialized skills;
* identify affected modules and contracts;
* define a small and executable implementation plan;
* prevent unnecessary scope expansion;
* coordinate implementation and validation;
* confirm the definition of done;
* report results and remaining risks.

The current task or feature request is:

```text
$ARGUMENTS
```

If no arguments were provided, infer the task from the current conversation.

---

## Mandatory Initial Context

Before planning or modifying files:

1. Read `${CLAUDE_PROJECT_DIR}/CLAUDE.md`.
2. Inspect the repository structure.
3. Identify the current development phase.
4. Inspect relevant documentation under `docs/`.
5. Inspect existing implementation before proposing structural changes.
6. Identify public contracts that may be affected.
7. Determine which specialized skills are required.
8. Load only the skills relevant to the task.

Do not begin implementation before understanding the current state.

---

## Project Phases

The official project phases are:

### Phase 0 — Foundation

Includes:

* repository structure;
* Claude Code configuration;
* project skills;
* Docker Compose;
* minimal Go backend;
* minimal React frontend;
* PostgreSQL;
* Redis;
* LocalStack;
* Keycloak;
* Mailpit;
* Terraform structure;
* CI;
* lint;
* tests;
* health checks;
* development documentation.

### Phase 1 — Public Catalog

Includes:

* public species listing;
* species detail pages;
* public article listing;
* article pages;
* taxonomy;
* search;
* filters;
* seed data;
* public responsive layout.

### Phase 2 — Users and Authentication

Includes:

* registration;
* login;
* account confirmation;
* password recovery;
* user profile;
* roles;
* permissions;
* identity synchronization.

### Phase 3 — Administration

Includes:

* administration dashboard;
* species management;
* article management;
* taxonomy management;
* media upload;
* editorial workflow;
* preview;
* publishing.

### Phase 4 — Advanced Editorial Experience

Includes:

* advanced article blocks;
* galleries;
* maps;
* tables;
* related content;
* advanced SEO;
* social sharing metadata.

### Phase 5 — Gamification

Includes:

* activity tracking;
* reading progress;
* achievements;
* collections;
* quizzes;
* user levels.

### Phase 6 — AWS Deployment

Includes:

* real AWS infrastructure;
* deployment pipelines;
* production security;
* observability;
* backups;
* domain;
* CDN;
* disaster recovery considerations.

Never advance to another phase without explicit user instruction.

A task may prepare an extension point for a future phase, but it must not implement the future feature.

---

## Skill Selection

Select skills according to the task.

### Product and domain

Use `product-domain` when the task involves:

* reptiles;
* species;
* taxonomy;
* scientific classification;
* conservation;
* ecological importance;
* editorial terminology;
* article and species information structure.

### Backend

Use `go-backend` when the task involves:

* Go code;
* HTTP handlers;
* use cases;
* domain entities;
* repositories;
* middleware;
* API contracts;
* backend architecture.

### Frontend

Use `react-frontend` when the task involves:

* React;
* TypeScript;
* pages;
* routing;
* data fetching;
* forms;
* client-side validation;
* frontend architecture.

### Database

Use `database` when the task involves:

* PostgreSQL;
* migrations;
* schema changes;
* SQL queries;
* indexes;
* constraints;
* transactions;
* sqlc.

### Authentication

Use `authentication` when the task involves:

* Keycloak;
* Cognito;
* JWT;
* users;
* roles;
* permissions;
* authentication flows;
* identity synchronization.

### Content editing

Use `content-editor` when the task involves:

* articles;
* rich-text editing;
* structured content blocks;
* TipTap;
* content sanitization;
* revisions;
* publishing workflow.

### Local development

Use `local-development` when the task involves:

* Docker;
* Docker Compose;
* LocalStack;
* Mailpit;
* Keycloak containers;
* Makefile;
* environment variables;
* bootstrap scripts;
* local setup.

### Terraform and AWS

Use `terraform-aws` when the task involves:

* Terraform;
* LocalStack infrastructure;
* AWS architecture;
* infrastructure modules;
* environments;
* state;
* cloud security.

### Testing and quality

Use `testing-quality` when the task involves:

* unit tests;
* integration tests;
* end-to-end tests;
* lint;
* static analysis;
* CI;
* quality gates;
* coverage.

### Security

Use `security` when the task involves:

* authentication;
* authorization;
* uploads;
* secrets;
* input validation;
* sanitization;
* rate limiting;
* security headers;
* threat analysis.

Security must also be considered for every externally accessible feature, even when the user does not explicitly request it.

### Observability

Use `observability` when the task involves:

* logs;
* health checks;
* readiness checks;
* correlation IDs;
* metrics;
* traces;
* operational diagnostics.

### UX and design system

Use `ux-design-system` when the task involves:

* layouts;
* components;
* design tokens;
* typography;
* accessibility;
* responsive behavior;
* user experience;
* visual consistency.

### Documentation

Use `documentation` when the task involves:

* README;
* ADRs;
* C4 diagrams;
* OpenAPI;
* runbooks;
* architecture documentation;
* development instructions.

Documentation must also be evaluated for every significant technical change.

---

## Scope Control

Before implementation, classify requested work into one of these categories:

### Foundation

Technical structure required to support future work.

Examples:

* Docker Compose;
* application skeleton;
* health endpoints;
* initial lint configuration.

### Feature

A user-visible or administrative capability.

Examples:

* species listing;
* article page;
* login flow;
* media upload.

### Refactoring

An internal structural improvement that must preserve behavior.

Examples:

* moving validation into a domain type;
* extracting a repository;
* simplifying a React component.

### Bug Fix

Correction of unintended behavior.

### Infrastructure

Local or cloud environment changes.

### Documentation

Changes to guides, architecture, decisions, or contracts.

Explicitly state the category in the implementation plan.

Reject or reduce work that:

* belongs to a future phase;
* creates speculative abstractions;
* introduces microservices;
* requires infrastructure not needed by the current phase;
* adds dependencies without immediate use;
* changes unrelated modules;
* expands the feature beyond its acceptance criteria.

When a request contains multiple phases, implement only the current requested phase and document future work separately.

---

## Repository Inspection

Before making changes, inspect at least:

* relevant source directories;
* related tests;
* configuration files;
* current API contracts;
* database migrations when applicable;
* documentation related to the task;
* version control status.

Determine:

* what already exists;
* what can be reused;
* what contracts must remain stable;
* whether there are uncommitted changes;
* whether the requested task conflicts with existing decisions.

Never assume the repository is empty.

Never overwrite user changes.

Never discard existing uncommitted work.

---

## Dependency Analysis

Identify dependencies in these categories:

### Internal dependencies

Examples:

* article module depends on media metadata;
* species page depends on taxonomy;
* admin interface depends on authentication;
* publishing depends on editorial status rules.

### External dependencies

Examples:

* Go modules;
* npm packages;
* container images;
* Terraform providers.

### Operational dependencies

Examples:

* PostgreSQL;
* Redis;
* LocalStack;
* Keycloak;
* Mailpit.

### Contract dependencies

Examples:

* OpenAPI;
* frontend API clients;
* migrations;
* generated sqlc code;
* environment variables;
* Docker health checks.

Do not add a dependency unless:

1. the current task requires it;
2. the dependency is actively maintained;
3. the dependency does not duplicate existing functionality;
4. the dependency can run locally;
5. security and licensing implications are acceptable;
6. the adoption is documented when architecturally significant.

---

## Implementation Plan

Before modifying files, produce a concise plan containing:

### Objective

What outcome will be delivered.

### Current phase

The project phase to which the task belongs.

### Task category

One of:

* foundation;
* feature;
* refactoring;
* bug fix;
* infrastructure;
* documentation.

### Skills required

List only relevant skills.

### Affected areas

Identify:

* modules;
* directories;
* public contracts;
* database structures;
* infrastructure;
* documentation.

### Implementation steps

Provide small, ordered, verifiable steps.

Each step should leave the project in a valid or recoverable state.

### Risks

Identify technical, security, data, compatibility, or scope risks.

### Validation

List the commands and checks that prove completion.

### Acceptance criteria

Define observable completion conditions.

Do not provide an excessively long plan.

Do not begin implementation before the plan is established.

---

## Implementation Rules

During implementation:

1. Make the smallest complete change that satisfies the task.
2. Preserve existing behavior unless a change is explicitly required.
3. Keep the project compilable after each meaningful increment.
4. Avoid unrelated formatting or renaming.
5. Do not replace complete files when a targeted edit is sufficient.
6. Do not introduce future-phase functionality.
7. Do not create empty architectural layers.
8. Do not create unused interfaces.
9. Do not create generic utilities without multiple real consumers.
10. Keep business rules outside transport and UI layers.
11. Update tests with behavior changes.
12. Update documentation with contract or architectural changes.
13. Execute validations progressively.
14. Report blockers honestly.

If the implementation reveals that the original plan is invalid:

1. stop expanding the incorrect approach;
2. explain the discovered constraint;
3. revise the plan;
4. continue with the smallest safe solution.

---

## Cross-Cutting Requirements

Every task must evaluate the following concerns.

### Security

Check:

* input validation;
* authentication;
* authorization;
* sensitive data;
* secrets;
* error exposure;
* payload limits;
* upload safety;
* dependency risks.

### Testing

Determine which tests are necessary:

* domain unit tests;
* use-case tests;
* handler tests;
* repository integration tests;
* component tests;
* end-to-end tests;
* infrastructure validation.

### Observability

Check whether the change needs:

* structured logs;
* correlation IDs;
* metrics;
* health checks;
* readiness behavior;
* audit events.

### Accessibility

For user interfaces, verify:

* semantic HTML;
* keyboard access;
* focus states;
* labels;
* contrast;
* responsive behavior;
* screen reader support.

### Documentation

Check whether the change requires:

* README update;
* ADR;
* OpenAPI update;
* C4 update;
* runbook update;
* environment variable documentation;
* migration notes.

---

## Contract Change Checklist

### API contract

When changing an API:

* update the handler;
* update request and response models;
* update validation;
* update OpenAPI;
* update frontend clients;
* update tests;
* document compatibility impact.

### Database contract

When changing the database:

* create a migration;
* update SQL queries;
* regenerate sqlc output;
* update seed data;
* update tests;
* evaluate indexes;
* evaluate rollback behavior.

### Authentication contract

When changing authentication:

* evaluate token claims;
* update Keycloak configuration;
* update backend middleware;
* update roles and permissions;
* update frontend session handling;
* update tests;
* update documentation.

### Infrastructure contract

When changing infrastructure:

* update Docker Compose when local behavior changes;
* update Terraform when cloud behavior changes;
* update environment variables;
* update health checks;
* update bootstrap scripts;
* update local documentation.

---

## Validation Strategy

Run only commands relevant to changed areas, but never skip required validation.

### Backend

```bash
go test ./...
go vet ./...
golangci-lint run
```

Use the race detector when concurrency or shared state is involved:

```bash
go test -race ./...
```

### Frontend

```bash
npm run typecheck
npm run lint
npm run test
npm run build
```

Run end-to-end tests for critical user flows:

```bash
npm run test:e2e
```

### Database

Validate:

* migrations apply successfully;
* migrations rollback when supported;
* sqlc generation succeeds;
* integration tests pass;
* constraints work as expected.

### Docker and local services

Validate:

```bash
docker compose config
docker compose up -d
docker compose ps
```

Check health endpoints and dependent services.

### Terraform

Validate:

```bash
terraform fmt -check -recursive
terraform validate
tflint
```

Never run a real AWS apply without explicit authorization.

### Full project

When the change is cross-cutting, prefer:

```bash
make validate
make test
```

Do not claim a command was executed if it was not executed.

---

## Definition of Done

The task is complete only when:

* requested behavior is implemented;
* scope remains within the current phase;
* backend compiles when affected;
* frontend compiles when affected;
* relevant tests pass;
* lint passes;
* migrations are valid when affected;
* Terraform is valid when affected;
* Docker configuration is valid when affected;
* API contracts are synchronized;
* documentation is updated;
* no secrets are committed;
* no known failure is ignored;
* acceptance criteria are verified.

If any validation could not be executed, report:

* the missing validation;
* the reason;
* the exact command required;
* the remaining risk.

Never state that work is complete based only on code inspection.

---

## Final Report

At the end of the task, report:

### Summary

What was delivered.

### Phase and scope

Which project phase and task category were addressed.

### Changed files

Group by:

* backend;
* frontend;
* database;
* infrastructure;
* tests;
* documentation.

### Technical decisions

Explain relevant decisions without repeating obvious implementation details.

### Validation performed

List commands that were actually executed and their results.

### Acceptance criteria

Show which criteria were verified.

### Limitations

State what was intentionally not implemented.

### Remaining risks

State unresolved technical or operational risks.

### Recommended next step

Provide one focused next step aligned with the current phase.

Do not automatically begin the next phase.

---

## Prohibited Behavior

Do not:

* advance project phases automatically;
* implement unrelated features;
* create microservices;
* add speculative abstractions;
* create unused code;
* add dependencies without justification;
* overwrite uncommitted user changes;
* silently change contracts;
* ignore failing tests;
* remove tests to make validation pass;
* expose secrets;
* execute real AWS deployments without permission;
* treat documentation as optional;
* declare completion without verification;
* hide incomplete work;
* claim successful execution without evidence.

---

## Completion Response Format

Use the following structure after implementation:

```markdown
## Summary

## Phase and scope

## Changed files

## Technical decisions

## Validation performed

## Acceptance criteria

## Limitations

## Remaining risks

## Recommended next step
```

Keep the report factual, concise, and based on actual work performed.

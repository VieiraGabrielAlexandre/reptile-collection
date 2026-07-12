---

name: implement-feature
description: Implements the next complete increment of a planned feature by inspecting the repository, loading the required skills, preserving existing work, updating contracts, adding tests, validating behavior, and recording implementation evidence.
argument-hint: "[feature-plan-path-or-feature-description]"
disable-model-invocation: true
user-invocable: true
model: inherit
effort: high
------------

# Implement Feature

Implement the next complete and verifiable increment of the requested feature.

Requested feature or plan:

```text
$ARGUMENTS
```

This command must implement only one coherent increment per execution.

Do not automatically implement the entire feature.

Do not automatically advance to another project phase.

Do not automatically commit changes.

---

## Objective

Deliver the smallest complete implementation increment that:

* belongs to the current project phase;
* follows the approved feature plan;
* preserves existing contracts unless change is required;
* updates affected layers consistently;
* includes tests proportional to risk;
* updates documentation;
* passes relevant validation;
* leaves the repository in a usable state.

The command must prefer an existing feature plan.

When no plan exists, it may derive a minimal implementation scope from the request, but it must not replace `/plan-feature` for a large or ambiguous feature.

---

## Mandatory Context

Before changing files:

1. Read `CLAUDE.md`.
2. Read `.claude/skills/project-orchestrator/SKILL.md`.
3. Read `.claude/skills/testing-quality/SKILL.md`.
4. Read `.claude/skills/security/SKILL.md`.
5. Read `.claude/skills/documentation/SKILL.md`.
6. Identify and read all specialized skills relevant to the feature.
7. Inspect the current repository structure.
8. Inspect related implementation files.
9. Inspect related tests.
10. Inspect OpenAPI when API behavior is affected.
11. Inspect migrations, queries, and sqlc configuration when persistence is affected.
12. Inspect frontend routes, query hooks, forms, and components when frontend behavior is affected.
13. Inspect current feature and phase documentation.
14. Inspect accepted ADRs.
15. Inspect `git status --short`.
16. Inspect `git diff --stat`.
17. Inspect relevant uncommitted diffs.
18. Preserve all unrelated user changes.
19. Identify the current project phase.
20. Confirm that the requested implementation belongs to the current phase.

Do not assume the repository is empty.

Do not overwrite uncommitted work.

Do not silently change an accepted architectural decision.

---

## Input Resolution

The argument may be:

```text
feature plan path
feature name
feature description
next increment request
specific increment description
```

Examples:

```text
docs/product/features/public-species-catalog.md
public species catalog
implement the next increment of species search
add the species list API endpoint
```

Resolve the input using this order:

1. exact feature-plan file path;
2. matching feature plan under `docs/product/features/`;
3. matching phase plan;
4. existing implementation context;
5. explicit request text.

If multiple feature plans match materially different features:

* do not guess;
* report the matches;
* stop without changing files.

If no feature plan exists and the request is broad or ambiguous:

* perform planning only;
* recommend `/plan-feature`;
* do not modify implementation files.

If the request is narrow, explicit, and independently testable, implementation may proceed without a persisted feature plan.

---

## Feature Plan Validation

When a feature plan exists, inspect at least:

```text
Status
Phase
Objective
Scope
Non-goals
Domain rules
Functional requirements
Non-functional requirements
Data model impact
Backend impact
API contract
Frontend impact
Security and privacy
Testing strategy
Implementation increments
Acceptance criteria
Open decisions
Definition of ready
```

The feature may be implemented only when:

* status permits implementation;
* phase is active;
* first or next increment is defined;
* blocking decisions are resolved;
* acceptance criteria are testable;
* dependencies are satisfied.

If the plan is not ready:

* do not invent missing decisions;
* report the blocking sections;
* stop implementation.

Small reversible decisions may be resolved using project conventions and recorded in the feature plan.

---

## Phase Validation

Map the feature to one official phase:

```text
Phase 0 — Foundation
Phase 1 — Public Catalog
Phase 2 — Users and Authentication
Phase 3 — Administration
Phase 4 — Advanced Editorial Experience
Phase 5 — Gamification
Phase 6 — AWS Deployment
```

Verify all prerequisite phases.

Do not implement later-phase behavior when an earlier phase is incomplete.

Permitted exception:

A narrowly scoped prerequisite fix may be implemented when it is required for the selected increment and still belongs to the current phase.

Do not use a feature request to advance the project phase implicitly.

---

## Task Classification

Classify the requested work as:

```text
feature
foundation
refactoring
bug_fix
infrastructure
security
documentation
```

Use one primary category.

If the work is actually a bug fix, use bug-fix discipline:

* reproduce;
* add regression protection;
* fix;
* validate.

If the work is primarily architectural planning, do not implement it through this command.

---

## Skill Selection

Always use:

```text
project-orchestrator
testing-quality
security
documentation
```

Load additional skills according to affected areas.

### Product domain

Use:

```text
product-domain
```

for:

* species;
* taxonomy;
* reptiles;
* articles;
* conservation;
* references;
* ecological data.

### Go backend

Use:

```text
go-backend
```

for:

* Go code;
* APIs;
* handlers;
* use cases;
* repositories;
* middleware;
* configuration.

### React frontend

Use:

```text
react-frontend
ux-design-system
```

for:

* routes;
* pages;
* components;
* forms;
* API integration;
* responsive behavior;
* accessibility.

### Database

Use:

```text
database
```

for:

* migrations;
* SQL;
* sqlc;
* schema;
* indexes;
* seeds;
* transactions.

### Authentication

Use:

```text
authentication
```

for:

* Keycloak;
* JWT;
* users;
* roles;
* permissions;
* protected routes.

### Editorial content

Use:

```text
content-editor
```

for:

* article blocks;
* TipTap;
* revisions;
* preview;
* publishing;
* structured content.

### Local environment

Use:

```text
local-development
```

for:

* Docker;
* Compose;
* LocalStack;
* Keycloak initialization;
* Mailpit;
* Makefile;
* scripts.

### Infrastructure

Use:

```text
terraform-aws
```

for:

* Terraform;
* LocalStack resources;
* AWS architecture;
* real infrastructure planning.

### Observability

Use:

```text
observability
```

for:

* logs;
* correlation IDs;
* health;
* readiness;
* metrics;
* traces;
* audit events.

Do not load unrelated skills.

---

## Existing-State Analysis

Before selecting the increment, classify relevant capabilities as:

```text
existing_and_reusable
existing_but_incomplete
existing_but_conflicting
missing
```

Inspect:

* domain types;
* application services;
* handlers;
* routes;
* DTOs;
* repositories;
* migrations;
* SQL queries;
* generated code;
* frontend pages;
* components;
* hooks;
* query keys;
* schemas;
* tests;
* documentation;
* infrastructure.

Do not duplicate existing behavior.

Do not replace a working implementation without a clear reason.

---

## Increment Selection

When the feature plan contains increments:

1. identify completed increments;
2. identify partially completed increments;
3. identify the earliest incomplete dependency;
4. verify its prerequisites;
5. select exactly one increment.

The selected increment must:

* be coherent;
* be independently testable;
* produce observable behavior;
* fit the current phase;
* avoid speculative future work;
* leave the repository usable.

Do not select multiple increments because they are related.

A vertical slice may affect several layers when all are required for one observable result.

Example valid vertical slice:

```text
Add a public paginated species list endpoint,
its PostgreSQL query,
OpenAPI contract,
and repository integration tests.
```

Example invalid combined scope:

```text
Implement species listing,
species details,
search,
admin CRUD,
authentication,
and deployment.
```

---

## Partial Increment Recovery

If an increment is already partially implemented:

1. inspect current changes;
2. identify intended behavior;
3. preserve valid work;
4. complete the smallest missing parts;
5. add missing tests;
6. synchronize contracts;
7. validate the whole increment.

Do not restart the increment from scratch.

Do not replace user code merely because another implementation style is preferred.

---

## Implementation Plan

Before modifying files, present a concise plan containing:

### Feature

Resolved feature name or plan path.

### Phase

Current project phase.

### Category

Primary task category.

### Selected increment

Exactly one increment.

### Existing state

Relevant reusable and missing pieces.

### Skills

Only selected skills.

### Affected areas

Expected:

* backend;
* frontend;
* database;
* infrastructure;
* tests;
* documentation;
* public contracts.

### Risks

Relevant:

* data;
* security;
* compatibility;
* accessibility;
* performance;
* migration;
* scope.

### Validation

Exact commands and checks expected.

### Acceptance criteria

Criteria applicable to this increment.

Do not begin implementation before the plan is established.

---

## Implementation Order

Use the order appropriate to the feature.

A common backend-led vertical slice:

```text
1. Domain behavior.
2. Application use case.
3. Persistence contract.
4. Migration and SQL.
5. Repository implementation.
6. HTTP transport.
7. OpenAPI.
8. Tests.
9. Documentation.
```

A common frontend-led vertical slice:

```text
1. API contract inspection.
2. Frontend types and API function.
3. Query or mutation hook.
4. Page and components.
5. Loading, empty, error, and success states.
6. Accessibility and responsiveness.
7. Tests.
8. Documentation.
```

A cross-cutting feature may combine both, but each change must support the one selected increment.

Do not force every feature through every layer.

---

## Domain Implementation Rules

When domain behavior is affected:

* use canonical terminology;
* preserve taxonomy and editorial-group distinctions;
* enforce invariants near the domain;
* represent uncertainty safely;
* avoid invented scientific facts;
* keep HTTP and persistence concerns out of domain code.

Do not create an anemic domain model when meaningful behavior exists.

Do not create domain abstractions without real behavior.

---

## Backend Implementation Rules

Backend work must:

* follow modular-monolith boundaries;
* keep handlers thin;
* keep business rules in domain or application layers;
* use explicit DTOs;
* use context propagation;
* map errors safely;
* enforce backend authorization;
* use bounded pagination;
* keep OpenAPI synchronized.

Do not place SQL in handlers.

Do not expose generated database rows as public responses.

Do not ignore errors.

---

## Database Implementation Rules

When schema or SQL changes:

1. create a new migration;
2. do not edit already-applied shared migrations;
3. define constraints;
4. define indexes based on query patterns;
5. update SQL queries;
6. regenerate sqlc;
7. update repositories;
8. update seeds when required;
9. add integration tests;
10. verify rollback when safe.

Do not use `SELECT *`.

Do not use JSONB to avoid modeling stable queryable fields.

Do not manually edit generated sqlc code.

---

## API Implementation Rules

For every changed endpoint:

* use `/api/v1`;
* define authentication;
* define permission;
* validate path and query parameters;
* enforce payload limits;
* use standard errors;
* define success and failure responses;
* update OpenAPI in the same increment.

Do not return unpublished data through public routes.

Do not use generic status-update endpoints to bypass workflow rules.

---

## Frontend Implementation Rules

Frontend work must:

* use TypeScript strictly;
* use feature-oriented structure;
* use TanStack Query for server state;
* use React Hook Form and Zod for forms;
* use semantic design tokens;
* handle all relevant interface states;
* preserve URL state for shareable filters;
* respect accessibility;
* validate responsive behavior.

Do not use `any` indiscriminately.

Do not place domain rules in React components.

Do not rely on frontend permissions as authorization.

---

## UI State Requirements

Implement all states relevant to the increment:

```text
loading
success
empty
error
not_found
unauthenticated
forbidden
submitting
save_failed
conflict
```

Do not add irrelevant states.

Each state must define:

* visible message;
* available action;
* retry or recovery behavior;
* accessible focus behavior where needed.

Do not implement only the success path.

---

## Accessibility Rules

For affected interfaces, verify:

* semantic HTML;
* heading hierarchy;
* accessible names;
* visible focus;
* keyboard access;
* form labels;
* error announcements;
* dialog behavior;
* image alternative text;
* touch targets;
* reduced motion.

Do not use non-semantic clickable elements.

Do not remove focus outlines without a replacement.

---

## Security Rules

For every increment, evaluate:

* authentication;
* backend authorization;
* object-level access;
* input validation;
* mass assignment;
* SQL injection;
* XSS;
* unsafe links;
* SSRF;
* upload safety;
* rate limiting;
* secrets;
* unpublished content;
* error disclosure;
* logging of sensitive data.

Implement explicit controls where relevant.

Do not write “security handled elsewhere” when this increment creates a trust boundary.

---

## Observability Rules

Add only useful signals.

Possible additions:

* structured operation logs;
* stable error code;
* correlation propagation;
* audit event;
* failure counter;
* readiness behavior.

Do not add high-cardinality metric labels.

Do not log raw search terms, tokens, article bodies, or uploaded content.

---

## Dependency Rules

Before adding a dependency:

1. verify existing stack or standard library cannot reasonably solve it;
2. verify active maintenance;
3. verify security;
4. verify license;
5. evaluate runtime or bundle cost;
6. document the reason.

Do not add overlapping libraries.

Do not add a large framework for a small utility.

---

## Generated Code

When generated code is affected:

* update source specification first;
* run the documented generator;
* do not edit generated files manually;
* include generated changes;
* validate the repository remains clean after regeneration.

Potential generated artifacts:

```text
sqlc output
OpenAPI types
mock code when justified
documentation
```

Do not leave generated code stale.

---

## Testing Strategy

Add tests proportional to risk.

### Domain

Test:

* invariants;
* validation;
* workflow transitions;
* boundary cases.

### Application

Test:

* authorization;
* orchestration;
* error mapping;
* transaction decisions.

### Handler

Test:

* malformed input;
* validation;
* status codes;
* response bodies;
* authentication;
* forbidden access;
* not found;
* success.

### Repository

Test using PostgreSQL:

* query behavior;
* constraints;
* filters;
* pagination;
* mapping;
* conflicts.

### Frontend

Test:

* rendering;
* loading;
* empty;
* error;
* user interaction;
* accessibility;
* permission-aware presentation;
* form errors.

### End-to-end

Use only for critical user journeys affected by the increment.

### Infrastructure

Test:

* Compose configuration;
* LocalStack resources;
* Terraform formatting and validation.

Do not duplicate every scenario at every level.

---

## Regression Protection

When the feature corrects broken or incomplete behavior:

1. reproduce the failure;
2. add a failing regression test where practical;
3. implement the fix;
4. verify the test passes;
5. run the related suite.

Do not claim regression protection without a meaningful test.

---

## Progressive Validation

Validate during implementation.

Examples:

```bash
go test ./internal/species/...
npm run test -- SpeciesList
sqlc generate
terraform validate
docker compose config
```

Before completion, run the broader relevant validation.

Do not wait until the end to discover basic compilation errors.

---

## Validation Commands

Run only commands that exist in the repository.

### Backend

```bash
gofmt -w .
go test ./...
go vet ./...
golangci-lint run
go build ./...
```

When concurrency is affected:

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

When critical flow is affected:

```bash
npm run test:e2e
```

### Database

```bash
sqlc generate
make migrate
make seed
```

Use only local or isolated databases.

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

Do not invent missing commands.

Do not report a command as passed unless it was executed.

---

## Validation Failure Handling

When a validation fails:

1. determine whether the failure was introduced by the increment;
2. determine whether it already existed;
3. fix increment-related failures when safe;
4. do not expand into unrelated repairs;
5. document pre-existing failures;
6. do not mark the increment complete if required validation remains failing.

Do not disable tests or lint rules to obtain a green result.

Do not hide failures.

---

## Contract Synchronization

Before completion, verify consistency among:

```text
domain
database
sqlc
repositories
application use cases
HTTP handlers
OpenAPI
frontend types
frontend API functions
tests
documentation
```

Do not silently change a public contract.

When a breaking change is necessary:

* document compatibility impact;
* define migration or rollout;
* update all consumers;
* record the decision when architectural.

---

## Documentation Updates

Update relevant documentation in the same increment.

Possible files:

```text
README.md
feature plan
phase plan
OpenAPI
domain glossary
architecture documents
ADR
development guide
testing guide
security documentation
runbook
```

Do not create an ADR for routine implementation.

Do update the feature plan status and completion evidence when a plan exists.

---

## Feature Plan Progress

When using a feature plan, update:

```text
Status
Implementation increments
Acceptance criteria
Completion evidence
Known limitations
Open decisions
```

Possible status values:

```text
Planned
In progress
Blocked
Implemented
```

Mark only the selected increment complete.

Do not mark the whole feature implemented unless all planned increments and acceptance criteria are complete.

---

## Completion Evidence

Record evidence such as:

```markdown
## Completion evidence

### Increment: Public species list API

Status: Complete

Implemented:

- paginated published-species query;
- repository mapping;
- public handler;
- OpenAPI contract;
- repository and handler tests.

Validation:

- `sqlc generate` — passed
- `go test ./...` — passed
- `go vet ./...` — passed
- `go build ./...` — passed
```

Do not record hypothetical commands.

---

## Git Safety

Do not automatically:

* commit;
* push;
* amend;
* rebase;
* reset;
* clean;
* stash;
* discard changes.

Do not stage unrelated files.

Preserve all user modifications.

You may suggest a focused commit message.

---

## Real AWS Safety

This command may prepare or validate Terraform.

It must not run:

```text
terraform apply
terraform destroy
```

against real AWS without explicit authorization.

If the feature belongs to Phase 6:

* identify account;
* identify principal;
* identify region;
* inspect backend;
* create or inspect plan;
* stop before apply unless explicitly authorized.

Do not interpret “implement infrastructure” as automatic deployment permission.

---

## Scope Control

During implementation, reject or defer work that:

* belongs to another phase;
* is unrelated to the selected increment;
* creates speculative abstractions;
* introduces microservices;
* adds unused infrastructure;
* adds unsupported content blocks;
* creates generic CRUD without domain behavior;
* rewrites working code unnecessarily.

Record deferred work in the feature plan or final report.

Do not silently expand scope.

---

## Refactoring During Implementation

Small refactoring is allowed only when it is necessary to implement or test the increment safely.

It must:

* preserve unrelated behavior;
* remain local;
* have tests;
* not become a separate architecture rewrite.

Do not use a feature implementation as an excuse for broad cleanup.

---

## Unsupported or Conflicting Plans

If the plan conflicts with:

* `CLAUDE.md`;
* accepted ADRs;
* current phase;
* security baseline;
* actual implementation;

do not implement blindly.

Report:

* the conflict;
* affected files or decisions;
* recommended resolution;
* whether the increment can proceed safely.

Do not silently override project governance.

---

## Implementation Completion Assessment

After validation, classify the selected increment as:

```text
complete
blocked
partially_complete
```

### Complete

All increment acceptance criteria are met and required validation passes.

### Blocked

A dependency or unresolved decision prevents completion.

### Partially Complete

Some work is valid, but required validation or behavior remains incomplete.

Do not classify partial work as complete.

---

## Feature Completion Assessment

After the increment, classify the overall feature as:

```text
planned
in_progress
blocked
implemented
```

A feature is implemented only when:

* all increments are complete;
* all acceptance criteria are met;
* all required validation passes;
* documentation is synchronized;
* no blocking decision remains.

Do not infer whole-feature completion from one increment.

---

## Final Response Format

Use:

```markdown
## Feature

## Phase and category

## Selected increment

## Existing state

## Implemented changes

## Files changed

## Domain and technical decisions

## Security and accessibility

## Tests added or updated

## Validation performed

## Acceptance criteria

## Increment status

## Feature progress

## Limitations and deferred work

## Remaining risks

## Recommended next increment

## Suggested commit
```

The recommended next increment is informational.

Do not begin it automatically.

---

## Definition of Done

This command execution is complete only when:

* the input was resolved;
* the current phase was validated;
* relevant skills were loaded;
* the existing state was inspected;
* exactly one increment was selected;
* implementation remained within scope;
* contracts were synchronized;
* security and accessibility were evaluated;
* relevant tests were added or updated;
* validation was executed;
* feature or phase documentation was updated;
* completion evidence was recorded;
* unrelated user changes were preserved;
* no commit or deployment was performed without explicit instruction;
* results were reported honestly.

---

## Prohibited Behavior

Do not:

* implement the entire feature automatically;
* implement multiple planned increments in one execution;
* advance project phases;
* overwrite unrelated user work;
* discard uncommitted changes;
* create microservices;
* introduce speculative abstractions;
* create unused modules;
* place business rules in handlers or React components;
* trust frontend authorization;
* expose draft content publicly;
* render unsanitized HTML;
* edit applied migrations;
* edit generated code manually;
* skip OpenAPI updates for API changes;
* remove tests to make validation pass;
* disable quality rules without justification;
* report unexecuted validation as successful;
* automatically commit or push;
* deploy or destroy real AWS resources without explicit authorization;
* automatically invoke another command after completion.

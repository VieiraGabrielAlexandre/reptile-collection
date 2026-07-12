---

name: finish-task
description: Finalizes the current implementation task by identifying the completed scope, validating acceptance criteria, running relevant quality checks, synchronizing contracts and documentation, recording completion evidence, and determining whether the work is ready for review or merge.
argument-hint: "[task-or-feature-plan-path]"
disable-model-invocation: true
user-invocable: true
model: inherit
effort: high
------------

# Finish Task

Finalize the current implementation task.

Requested task or feature:

```text
$ARGUMENTS
```

If no argument was provided, infer the task from:

1. current Git changes;
2. active feature plan;
3. active phase plan;
4. recent implementation scope;
5. changed tests and contracts.

This command finalizes existing work.

It must not implement new features.

It may perform only small completion corrections directly required to make the already implemented task internally consistent, such as:

* formatting changed files;
* regenerating code from an already changed source contract;
* correcting stale documentation directly caused by the task;
* fixing a trivial compile or lint issue introduced by the current task;
* adding missing completion evidence.

It must not:

* expand scope;
* introduce a new feature;
* perform broad refactoring;
* change architecture;
* add a new dependency without prior approval;
* create a new migration for unplanned behavior;
* advance the project phase automatically;
* commit or push changes.

---

## Objective

Determine whether the current task is genuinely complete.

The command must answer:

1. What task was implemented?
2. Which project phase owns it?
3. Which files and contracts changed?
4. Which acceptance criteria apply?
5. Which criteria are satisfied?
6. Which validations passed?
7. Which validations failed or were skipped?
8. Are tests sufficient for the changed behavior?
9. Are API, database, frontend, infrastructure, and documentation synchronized?
10. Does any security, accessibility, or operational blocker remain?
11. Is the task ready for review or merge?
12. What should happen next?

---

## Mandatory Context

Before changing or validating anything:

1. Read `CLAUDE.md`.
2. Read `.claude/skills/project-orchestrator/SKILL.md`.
3. Read `.claude/skills/testing-quality/SKILL.md`.
4. Read `.claude/skills/security/SKILL.md`.
5. Read `.claude/skills/documentation/SKILL.md`.
6. Read all specialized skills relevant to changed files.
7. Inspect the current repository structure.
8. Inspect `git status --short`.
9. Inspect `git diff --stat`.
10. Inspect `git diff`.
11. Inspect `git diff --cached`.
12. Inspect relevant untracked files.
13. Identify the current phase.
14. Identify the feature or task plan.
15. Inspect applicable acceptance criteria.
16. Inspect related OpenAPI contracts.
17. Inspect related migrations and SQL.
18. Inspect related frontend contracts.
19. Inspect related tests.
20. Inspect phase and feature completion evidence.
21. Preserve all unrelated user changes.

Do not assume that all current changes belong to one task.

Do not discard, reset, stash, or overwrite user work.

---

## Input Resolution

The argument may be:

```text
feature-plan path
phase-plan path
feature name
task description
current changes
```

Examples:

```text
docs/product/features/public-species-catalog.md
public species listing API
Phase 0 backend foundation
current changes
```

Resolve the task using this priority:

1. exact provided plan path;
2. matching feature plan;
3. matching phase increment;
4. current changed files;
5. explicit task description.

If current changes contain multiple unrelated tasks:

* separate them;
* identify which one matches the argument;
* do not finalize unrelated work;
* report that the working tree contains mixed scope.

If the task cannot be resolved confidently:

* report the ambiguity;
* do not invent completion criteria;
* stop without modifying files.

---

## Current Task Classification

Classify the task as:

```text
feature
foundation
bug_fix
refactoring
infrastructure
security
documentation
```

Identify:

```text
project phase
feature or phase increment
primary module
affected layers
```

Possible affected layers:

```text
domain
backend
database
API
frontend
authentication
content editor
local development
Terraform
security
observability
testing
documentation
```

---

## Skill Selection

Always use:

```text
project-orchestrator
testing-quality
security
documentation
```

Load additional skills based on the changed scope.

### Backend

```text
go-backend
observability
```

### Database

```text
database
```

### Frontend

```text
react-frontend
ux-design-system
```

### Authentication

```text
authentication
```

### Domain

```text
product-domain
```

### Editorial content

```text
content-editor
```

### Local environment

```text
local-development
```

### Terraform and AWS

```text
terraform-aws
```

Do not load unrelated skills.

---

## Task Boundary Analysis

Determine which files belong to the task.

Classify changed files as:

```text
task_scope
supporting_change
generated_change
documentation_change
unrelated_change
uncertain
```

Do not include unrelated files in completion claims.

Report mixed-scope changes explicitly.

Examples:

```text
Task scope:
apps/api/internal/species/**
apps/api/queries/species.sql

Supporting:
apps/api/openapi/openapi.yaml

Generated:
apps/api/internal/platform/database/generated/**

Documentation:
docs/product/features/public-species-catalog.md

Unrelated:
apps/web/src/features/profile/**
```

Do not stage or revert any category automatically.

---

## Plan and Acceptance-Criteria Resolution

When a feature or phase plan exists, inspect:

```text
Status
Objective
Scope
Non-goals
Requirements
Implementation increments
Acceptance criteria
Definition of ready
Completion evidence
Known limitations
```

Identify the selected increment.

Do not evaluate future increments as part of the current task.

If no persisted plan exists, derive completion criteria only from:

* explicit task request;
* tests;
* public contracts;
* established project rules;
* changed implementation.

Do not invent broad requirements.

---

## Completion Checklist

Evaluate only applicable categories.

### Scope

* requested behavior is implemented;
* no unrelated feature was introduced;
* future-phase behavior was not added accidentally;
* selected increment is coherent;
* unfinished placeholders do not falsely imply completion.

### Domain

* terminology is canonical;
* invariants are enforced;
* editorial grouping is not confused with taxonomy;
* scientific information is not invented;
* uncertainty and references are represented safely.

### Backend

* handlers remain thin;
* application behavior is explicit;
* domain rules are not in transport code;
* errors are mapped safely;
* context is propagated;
* pagination is bounded;
* authorization is backend-enforced;
* graceful behavior is preserved.

### Database

* migrations exist when required;
* constraints protect invariants;
* indexes support actual queries;
* SQL is parameterized;
* sorting is deterministic;
* sqlc is regenerated;
* repository mappings are synchronized;
* seeds are updated when required.

### API

* routes match implementation;
* OpenAPI is synchronized;
* request and response schemas match;
* authentication is documented;
* authorization is enforced;
* errors follow the standard problem format;
* public endpoints exclude unpublished data.

### Frontend

* routes and API functions are synchronized;
* query keys are correct;
* loading, empty, error, and success states exist;
* forms preserve data on failure;
* responsive behavior is implemented;
* frontend permissions are not treated as authorization.

### Accessibility

* semantic elements are used;
* keyboard navigation works;
* focus is visible;
* labels are present;
* errors are announced appropriately;
* image alternative text is handled;
* color is not the only state indicator.

### Security

* inputs are validated;
* output rendering is safe;
* no secret is exposed;
* object-level access is enforced;
* mass assignment is prevented;
* file uploads are constrained when affected;
* draft content remains private;
* logs exclude sensitive data.

### Observability

* relevant failures are diagnosable;
* correlation is preserved;
* operation logs are safe;
* health and readiness behavior remain correct;
* privileged actions are audited when required.

### Testing

* changed behavior has meaningful coverage;
* success and relevant failure paths are covered;
* regression tests exist for bug fixes;
* repository behavior uses integration tests when appropriate;
* frontend behavior is tested by user-visible outcomes;
* tests are deterministic.

### Documentation

* feature plan is updated;
* phase plan is updated when applicable;
* OpenAPI is current;
* README is current when workflows changed;
* `.env.example` is synchronized;
* relevant ADRs remain accurate;
* runbooks are updated when operational behavior changed.

---

## Allowed Completion Corrections

This command may perform narrowly scoped corrections only when all conditions are true:

1. the correction belongs directly to the existing task;
2. no product or architectural decision is required;
3. the change is small and low risk;
4. the correction is needed to pass an existing acceptance criterion;
5. the correction does not introduce new behavior.

Allowed examples:

```text
run formatter
regenerate sqlc after an already changed query
update OpenAPI to match an already implemented endpoint
correct a stale feature-plan checkbox
fix an import causing compilation failure
add a missing environment-variable description
```

Not allowed:

```text
design a new endpoint
add a new table
introduce caching
replace the authentication architecture
create an unplanned component
rewrite a module
add a new major dependency
```

If a nontrivial correction is required:

* classify the task as not complete;
* report the blocker;
* recommend `/fix-bug` or `/implement-feature`;
* do not implement it here.

---

## Validation Command Discovery

Before running commands:

1. inspect `Makefile`;
2. inspect backend scripts;
3. inspect `package.json`;
4. inspect Terraform roots;
5. inspect CI workflows;
6. inspect Docker Compose;
7. verify tool availability;
8. identify which commands are safe and relevant.

Build an internal matrix:

```text
command
working directory
purpose
available
requires services
mutates generated files
destructive
selected
```

Do not execute destructive commands.

Do not run commands that target real AWS.

---

## Progressive Validation

Run targeted checks first.

Examples:

```bash
go test ./internal/species/...
npm run test -- SpeciesList
sqlc generate
terraform validate
docker compose config
```

Then run broader relevant checks.

Do not run the entire environment when the task affects only documentation.

Do not claim full-project confidence from one targeted test.

---

## Backend Validation

Run available commands such as:

```bash
gofmt -l .
go test ./...
go vet ./...
go build ./...
go mod verify
```

When configured and relevant:

```bash
golangci-lint run
go test -race ./...
govulncheck ./...
```

A non-empty `gofmt -l` result means formatting remains incomplete.

Do not automatically install missing tools unless repository workflow explicitly supports it.

---

## Frontend Validation

Use the repository-selected package manager.

For npm-based projects, run available scripts such as:

```bash
npm run typecheck
npm run lint
npm run test
npm run build
```

When critical flows are affected:

```bash
npm run test:e2e
```

Do not run dependency installation unnecessarily when dependencies are already available.

Do not report E2E as passed when the required stack was unavailable.

---

## Database Validation

When persistence changed:

```bash
sqlc generate
```

Then verify whether generation produced unexpected changes.

Run available commands:

```bash
make migrate
make migration-status
make seed
make test-integration
```

Use only local or isolated databases.

Do not reset, drop, or destroy a shared database.

Do not edit applied migrations.

---

## Docker and Local Environment Validation

When local infrastructure changed:

```bash
docker compose config
docker compose build
docker compose up -d
docker compose ps
```

Only start services when necessary.

Do not remove volumes.

Do not run global Docker prune commands.

When services are running, validate applicable URLs:

```bash
curl --fail http://localhost:8080/health
curl --fail http://localhost:8080/ready
curl --fail http://localhost:3000
curl --fail http://localhost:4566/_localstack/health
curl --fail http://localhost:8025
```

Use the configured Keycloak health endpoint for its pinned version.

---

## Terraform Validation

When Terraform changed:

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

Do not run real AWS apply or destroy.

Do not run a plan against an unknown account.

LocalStack plans require explicit LocalStack endpoints and dummy credentials.

---

## Test Adequacy Assessment

Classify coverage for each changed behavior:

```text
adequate
partial
missing
not_applicable
```

Evaluate whether tests cover:

* primary success path;
* relevant validation failures;
* authorization failures;
* not-found behavior;
* data constraints;
* UI loading and error states;
* accessibility behavior;
* regression scenario for bug fixes.

A high coverage percentage does not automatically mean coverage is adequate.

Do not require every scenario at every layer.

---

## Contract Synchronization

Compare affected contracts:

```text
domain terminology
database schema
SQL queries
sqlc output
repository models
application DTOs
HTTP handlers
OpenAPI
frontend types
frontend API functions
tests
documentation
```

Report drift explicitly.

Examples:

```text
OpenAPI says `scientificName` is optional, but the handler requires it.
Frontend expects `total`, while the API returns `totalItems`.
Migration introduced `editorial_group`, but sqlc was not regenerated.
```

Small direct drift may be corrected under the allowed completion-correction rules.

Large contract changes require a separate task.

---

## Documentation Synchronization

Update completion evidence when a plan exists.

Feature plan sections to update:

```text
Status
Implementation increments
Acceptance criteria
Completion evidence
Known limitations
Open decisions
```

Phase plan sections to update:

```text
Current state
Deliverables
Execution increments
Acceptance criteria
Completion evidence
Risks
```

Do not mark the entire feature or phase complete when only one increment is complete.

---

## Completion Evidence Format

Use:

```markdown
## Completion evidence

### Increment: Increment name

Status: Complete | Partial | Blocked

Implemented:

- concrete behavior;
- contract changes;
- tests;
- documentation.

Validation:

- `command` — passed;
- `command` — failed;
- `command` — skipped because reason.

Limitations:

- remaining limitation or `None`.
```

Do not record commands that were not executed.

---

## Acceptance-Criteria Assessment

For every applicable criterion, classify:

```text
met
partially_met
not_met
blocked
not_applicable
```

Include concise evidence.

Example:

```text
AC-03 — Met

Evidence:
Repository integration test confirms draft species are excluded from the public list.
```

Do not mark criteria as met based only on intended code behavior.

---

## Task Status

Classify the task as:

```text
complete
complete_with_warnings
partially_complete
blocked
not_ready_for_completion
```

### Complete

* all applicable acceptance criteria are met;
* required validation passes;
* contracts are synchronized;
* documentation is current;
* no blocking risk remains.

### Complete with Warnings

* acceptance criteria are met;
* required validation passes;
* only non-blocking limitations remain.

### Partially Complete

* valid implementation exists;
* some criteria or validation remain incomplete.

### Blocked

* external or foundational dependency prevents completion.

### Not Ready for Completion

* scope is unclear;
* changes mix unrelated tasks;
* implementation has material defects;
* feature planning is missing.

Do not classify a task as complete when required tests fail.

---

## Merge Readiness

Classify merge readiness as:

```text
ready
ready_with_warnings
not_ready
blocked
```

A task is not ready when:

* build fails;
* required tests fail;
* migration validation fails;
* a critical or high security problem exists;
* authorization is incomplete;
* API contracts are inconsistent;
* acceptance criteria are not met;
* documentation falsely claims completion.

Do not equate merge readiness with production readiness.

---

## Feature Progress

Classify the overall feature as:

```text
planned
in_progress
blocked
implemented
```

Only mark `implemented` when every planned increment is complete.

---

## Phase Progress

Classify the current phase as:

```text
not_started
in_progress
blocked
complete
```

Do not advance the phase automatically.

Do not change the current phase merely because one task completed.

---

## Git Safety

Do not run:

```bash
git reset
git restore
git checkout
git clean
git stash
git commit
git push
git rebase
git merge
git cherry-pick
```

Read-only Git commands are allowed.

Do not stage files automatically.

You may suggest a focused commit command, but do not execute it.

---

## Failure Handling

If validation fails:

1. identify the failing command;
2. summarize the relevant output;
3. determine whether the failure appears task-related;
4. classify it as introduced, pre-existing, or uncertain;
5. perform only allowed trivial corrections;
6. rerun the affected validation after a correction;
7. stop if nontrivial work is required;
8. do not hide the failure.

Do not remove tests or disable quality rules.

---

## Recommended Next Action

Choose one next action.

Possible outcomes:

```text
run /review-code current changes
run /fix-bug <specific failure>
run /implement-feature <next increment>
run /validate-project <scope>
create a focused commit
resolve mixed working-tree scope
```

The recommendation must be specific.

Do not execute it automatically.

---

## Suggested Commit

When the task is ready, suggest:

```bash
git add <task-specific-files>
git commit -m "<type>: <concise description>"
```

Do not include unrelated files.

Suggested commit types:

```text
feat
fix
refactor
test
docs
build
ci
chore
```

Do not execute the commit.

---

## Final Response Format

Use:

```markdown
## Task summary

## Resolved scope

## Phase and feature

## Files included

## Completion corrections

## Acceptance criteria

## Tests and quality checks

## Contract synchronization

## Security and accessibility

## Documentation and evidence

## Task status

## Merge readiness

## Feature progress

## Phase progress

## Failed, skipped, or blocked checks

## Remaining limitations

## Recommended next action

## Suggested commit
```

Do not omit failed or skipped checks.

---

## Definition of Done

This command execution is complete only when:

* the task was resolved;
* task boundaries were identified;
* applicable skills were loaded;
* unrelated changes were preserved;
* acceptance criteria were identified;
* relevant validation was executed;
* test adequacy was assessed;
* contracts were compared;
* documentation was synchronized when appropriate;
* completion evidence was recorded;
* task and merge readiness were classified honestly;
* no new feature was introduced;
* no broad refactoring occurred;
* no destructive or real-cloud operation occurred;
* no commit was made automatically.

---

## Prohibited Behavior

Do not:

* implement a new feature;
* expand the current scope;
* create speculative architecture;
* perform broad refactoring;
* update dependencies without an approved task;
* create an unplanned migration;
* rewrite working modules;
* mark future increments complete;
* mark a phase complete without evidence;
* disable tests or lint;
* remove failing tests;
* hide failed validation;
* invent completion evidence;
* discard user changes;
* automatically stage, commit, or push;
* deploy or destroy real AWS resources;
* automatically invoke another command.

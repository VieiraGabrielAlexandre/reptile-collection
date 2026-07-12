---

name: fix-bug
description: Reproduces, diagnoses, and fixes a specific defect by identifying its root cause, implementing the smallest safe correction, adding regression protection, validating affected behavior, and documenting the result without expanding scope.
argument-hint: "[bug-description|finding-id|failing-command|issue-reference]"
disable-model-invocation: true
user-invocable: true
model: inherit
effort: high
------------

# Fix Bug

Investigate and correct the requested defect.

Bug request:

```text
$ARGUMENTS
```

This command is for defect correction.

It must:

1. resolve the reported behavior;
2. reproduce the failure when practical;
3. identify the root cause;
4. implement the smallest safe correction;
5. add regression protection;
6. validate affected behavior;
7. update contracts or documentation when required;
8. stop after the bug is fixed.

It must not:

* add unrelated features;
* perform broad refactoring;
* redesign architecture;
* update unrelated dependencies;
* advance the project phase;
* automatically commit or push;
* deploy to real AWS.

---

## Objective

Correct a concrete defect while preserving unrelated behavior.

The command must answer:

1. What is the observed behavior?
2. What is the expected behavior?
3. Can the defect be reproduced?
4. Which execution path causes it?
5. What is the root cause?
6. Which layers are affected?
7. What is the smallest safe correction?
8. Which regression test proves the fix?
9. Which validations passed?
10. What residual risk remains?

---

## Mandatory Context

Before modifying files:

1. Read `CLAUDE.md`.
2. Read `.claude/skills/project-orchestrator/SKILL.md`.
3. Read `.claude/skills/testing-quality/SKILL.md`.
4. Read `.claude/skills/security/SKILL.md`.
5. Read `.claude/skills/documentation/SKILL.md`.
6. Read specialized skills relevant to the defect.
7. Inspect the current project phase.
8. Inspect related feature and phase plans.
9. Inspect accepted ADRs.
10. Inspect affected implementation.
11. Inspect related tests.
12. Inspect API contracts when applicable.
13. Inspect migrations and SQL when applicable.
14. Inspect frontend behavior when applicable.
15. Inspect `git status --short`.
16. Inspect `git diff --stat`.
17. Inspect relevant current diffs.
18. Preserve unrelated user changes.
19. Determine whether the defect is pre-existing or related to current work.

Do not overwrite pending changes.

Do not assume the reported symptom identifies the root cause.

---

## Input Resolution

The argument may be:

```text
bug description
review finding ID
validation finding ID
failing test
failing command
error message
issue reference
affected path
```

Examples:

```text
API readiness returns 200 when PostgreSQL is unavailable
REV-003
SEC-001
go test ./... fails in article publication tests
species filters disappear after page refresh
```

Resolve:

```text
observed behavior
expected behavior
affected actor
affected environment
reproduction context
severity
```

If the report contains insufficient information:

* inspect current code and tests;
* use the most conservative reasonable interpretation;
* do not invent product behavior;
* stop only when material ambiguity prevents safe correction.

---

## Bug Classification

Classify the defect as one primary type:

```text
correctness
regression
security
authorization
data_integrity
concurrency
performance
accessibility
API_contract
database
frontend
infrastructure
configuration
documentation
```

Also classify severity:

```text
critical
high
medium
low
```

Do not inflate severity.

---

## Skill Selection

Always use:

```text
project-orchestrator
testing-quality
security
documentation
```

Load additional skills based on the defect.

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

### Terraform

```text
terraform-aws
```

Do not load unrelated skills.

---

## Reproduction First

Before changing implementation, attempt to reproduce the defect when practical.

Preferred reproduction order:

1. existing failing test;
2. targeted automated test;
3. safe API request;
4. isolated local integration scenario;
5. static proof when runtime reproduction is unnecessary;
6. documented manual reproduction only when automation is impractical.

Record:

```text
reproduction method
command
environment
actual result
expected result
reproduction status
```

Reproduction status:

```text
reproduced
partially_reproduced
not_reproduced
statically_confirmed
blocked
```

Do not modify code before understanding the likely execution path unless the failure prevents all inspection.

---

## Reproduction Safety

Do not reproduce through:

* destructive database operations;
* real user accounts;
* real email;
* real AWS mutation;
* production systems;
* public content publication;
* role changes in shared environments;
* volume deletion.

Use local or isolated test environments.

Do not expose secrets in reproduction output.

---

## Regression Test First

When practical:

1. write or identify a test that fails due to the defect;
2. confirm the failure;
3. implement the fix;
4. confirm the test passes;
5. run related broader tests.

The regression test should verify observable behavior.

Examples:

```text
readiness returns 503 when PostgreSQL is unavailable
draft species are excluded from public search
invalid JWT audience returns 401
form values remain after failed save
filter remains in URL after pagination
```

Do not write a test that only asserts the internal implementation chosen for the fix.

If a regression test cannot be created, explain why.

---

## Root-Cause Analysis

Trace the defect through relevant layers.

Possible path:

```text
user action
frontend state
API request
HTTP handler
application use case
domain rule
repository
database
external dependency
response
frontend rendering
```

Identify:

```text
symptom
trigger
fault location
root cause
contributing factors
missing protection
```

Do not stop at the first failing line when the real cause is an invalid contract or missing invariant.

---

## Root Cause vs Symptom

Examples:

```text
Symptom:
The species list shows draft records.

Immediate cause:
The repository query does not filter editorial_status.

Root cause:
The public repository operation reused an unrestricted administrative query.
```

```text
Symptom:
The frontend repeatedly calls the API.

Immediate cause:
The query key changes every render.

Root cause:
The filter object is created with unstable non-normalized state.
```

Correct the root cause when possible without expanding scope.

Do not add a superficial guard when a stable invariant can solve the defect safely.

---

## Existing-State Analysis

Classify related code as:

```text
correct_and_reusable
incorrect
incomplete
conflicting
unrelated
```

Inspect callers and consumers before modifying shared behavior.

Identify whether a proposed correction could affect:

* public endpoints;
* administrative endpoints;
* database compatibility;
* frontend contracts;
* authentication;
* caching;
* tests;
* seed data;
* LocalStack;
* Terraform.

Do not change a shared helper without reviewing all consumers.

---

## Fix Scope

Define the smallest safe scope.

A valid fix may include:

```text
implementation correction
regression test
contract synchronization
small documentation correction
small observability correction
```

It may cross multiple layers only when required to restore one expected behavior.

Example:

```text
Fix API field name,
update frontend type,
update OpenAPI,
add contract test.
```

Do not include:

```text
nearby cleanup
unrelated refactoring
new feature
future-phase behavior
dependency upgrade without necessity
```

---

## Fix Plan

Before modifying files, present:

### Bug

Concise description.

### Severity and category

### Reproduction

How it was reproduced or confirmed.

### Root cause

### Affected layers

### Selected correction

### Regression protection

### Risks

### Validation

Do not begin modification before establishing this plan.

---

## Backend Fix Rules

When fixing Go code:

* preserve modular boundaries;
* keep handlers thin;
* correct behavior at the appropriate layer;
* propagate context;
* map errors safely;
* preserve error identity;
* avoid panic for expected behavior;
* maintain bounded operations;
* enforce backend authorization.

Do not add special-case logic to handlers when the rule belongs in application or domain code.

---

## Database Fix Rules

When fixing persistence:

* create a new migration only if schema change is truly required;
* do not edit shared applied migrations;
* use parameterized SQL;
* preserve data;
* add constraints when they protect the root invariant;
* add indexes only for actual query patterns;
* regenerate sqlc;
* add repository integration coverage.

Do not solve query correctness only in frontend filtering.

---

## API Fix Rules

When fixing an endpoint:

* preserve versioning;
* validate inputs;
* use correct status codes;
* return standard errors;
* synchronize OpenAPI;
* update frontend clients when necessary;
* preserve backward compatibility when practical.

Do not silently change a public field without updating all consumers.

---

## Frontend Fix Rules

When fixing React behavior:

* fix the underlying state or contract issue;
* preserve user input;
* handle loading and error states;
* use stable query keys;
* propagate cancellation;
* maintain accessibility;
* verify responsive behavior.

Do not solve server data errors with presentation-only filtering when the API contract is wrong.

---

## Authentication Fix Rules

When fixing authentication:

* verify signature;
* issuer;
* audience;
* expiration;
* algorithm;
* subject mapping;
* account state;
* permissions;
* object-level access.

Do not weaken validation to make local login easier.

Do not place client secrets in the frontend.

Do not log raw tokens.

---

## Security Defect Rules

For security defects:

1. limit exposure immediately in code;
2. preserve evidence without exposing secrets;
3. rotate credentials when actual secrets were exposed, though rotation may require explicit external action;
4. add negative-path tests;
5. update threat or security documentation when material;
6. report residual exposure.

Do not print compromised secrets.

Do not claim a committed secret is safe merely because it was deleted from the current file.

---

## Content Security Fix Rules

When fixing editorial rendering:

* reject unsupported structures;
* sanitize or structurally render content;
* validate URLs;
* preserve unknown blocks without executing them;
* protect previews;
* exclude drafts from public behavior;
* enforce payload limits.

Do not introduce arbitrary HTML as a workaround.

---

## Infrastructure Fix Rules

For Docker, LocalStack, Terraform, or AWS-related defects:

* verify the target environment;
* preserve state;
* keep LocalStack and real AWS separated;
* avoid destructive commands;
* update health checks or endpoints safely;
* use least privilege;
* avoid hardcoded credentials.

Do not run real AWS apply or destroy.

Do not remove Docker volumes.

---

## Concurrency Fix Rules

When fixing concurrency:

* identify ownership of goroutines or shared state;
* use context cancellation;
* prevent goroutine leaks;
* protect shared maps and mutable state;
* avoid blocking indefinitely;
* add race-oriented tests where practical;
* run the race detector.

Do not add locks without understanding lock ordering and lifecycle.

---

## Performance Defect Rules

Performance fixes require evidence.

Evidence may include:

* repeated query in a loop;
* unbounded result set;
* measured bundle impact;
* request duplication;
* long transaction;
* missing image dimensions causing layout shift.

Do not add caching for speculative performance concerns.

Preserve correctness before optimization.

---

## Accessibility Defect Rules

For accessibility bugs:

* preserve equivalent functionality;
* use semantic HTML;
* restore keyboard support;
* restore visible focus;
* add accessible names;
* manage focus correctly;
* add automated and manual validation where practical.

Do not only add ARIA when a native element would solve the issue better.

---

## Error and Observability Fixes

When the defect concerns diagnostics:

* log at the correct boundary;
* use stable error codes;
* preserve correlation IDs;
* avoid duplicate logging;
* exclude sensitive data;
* distinguish required and optional dependencies.

Do not log entire request bodies as a debugging workaround.

---

## Regression Test Requirements

The regression test must:

* fail before the correction when practical;
* pass after the correction;
* assert observable behavior;
* remain deterministic;
* avoid real credentials;
* avoid shared production-like state;
* use the lowest useful test layer.

Examples:

### Domain

Invalid state transition remains rejected.

### Handler

Malformed input returns the expected problem response.

### Repository

Public query excludes unpublished records.

### Frontend

Form data remains after a failed mutation.

### E2E

An editor cannot access administrator-only role management.

Do not rely only on a snapshot.

---

## Progressive Validation

After implementing the correction:

1. run the regression test;
2. run the affected package or feature tests;
3. run affected lint or type checks;
4. run the affected build;
5. run integration tests when persistence changed;
6. run E2E only when the critical flow requires it;
7. run security or race validation when relevant.

Do not run unrelated expensive validation unless necessary.

---

## Validation Commands

Use only commands that exist.

### Backend

```bash
go test ./...
go vet ./...
go build ./...
```

When relevant:

```bash
golangci-lint run
go test -race ./...
govulncheck ./...
```

### Frontend

```bash
npm run typecheck
npm run lint
npm run test
npm run build
```

When relevant:

```bash
npm run test:e2e
```

### Database

```bash
sqlc generate
make migrate
make test-integration
```

Use only local or isolated databases.

### Docker

```bash
docker compose config
docker compose build
docker compose up -d
docker compose ps
```

Do not remove volumes.

### Terraform

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Do not apply or destroy real infrastructure.

---

## Fix Verification

Verify both:

```text
defect no longer occurs
unrelated expected behavior remains intact
```

Do not consider the fix complete after only the new regression test passes when shared behavior changed.

Inspect nearby consumers.

---

## Contract Synchronization

When the correction changes or restores a contract, synchronize:

```text
OpenAPI
frontend types
frontend API functions
database schema
sqlc
tests
feature plan
runbook
```

Do not use documentation to conceal a broken implementation.

---

## Documentation Updates

Update documentation only when the defect revealed a documentation or operational gap.

Possible updates:

* feature-plan limitation;
* OpenAPI correction;
* runbook diagnostic;
* environment-variable clarification;
* security guidance;
* migration note.

Do not create an ADR for an ordinary bug fix unless the correction changes architecture.

---

## Bug Completion Evidence

When a feature or phase plan exists, add:

```markdown
### Bug fix: Bug title

Status: Fixed

Root cause:

Concise root cause.

Correction:

Concise correction.

Regression protection:

- test name or path.

Validation:

- `command` — passed.

Residual risk:

- remaining risk or `None`.
```

Do not mark the entire feature complete automatically.

---

## Fix Status

Classify the bug as:

```text
fixed
fixed_with_limitations
partially_fixed
blocked
not_reproduced
```

### Fixed

The root cause was corrected and regression validation passes.

### Fixed with Limitations

The defect is corrected, but a known non-blocking limitation remains.

### Partially Fixed

The symptom is reduced, but the complete expected behavior is not restored.

### Blocked

A dependency or unresolved decision prevents correction.

### Not Reproduced

The reported behavior could not be confirmed and no safe static correction was justified.

Do not classify a workaround as fully fixed if the root cause remains.

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
git cherry-pick
```

Preserve unrelated changes.

Do not automatically stage files.

You may suggest a focused commit.

---

## Failure Handling

If the correction fails:

1. stop expanding scope;
2. preserve valid work;
3. report the failing validation;
4. identify whether the root-cause hypothesis was incomplete;
5. classify the fix honestly;
6. do not remove tests;
7. do not weaken validation;
8. recommend the next focused investigation.

---

## Final Response Format

Use:

```markdown
## Bug summary

## Severity and category

## Reproduction

## Root cause

## Affected scope

## Fix implemented

## Regression protection

## Contracts and documentation

## Validation performed

## Fix status

## Remaining limitations

## Remaining risk

## Recommended next action

## Suggested commit
```

Do not hide failed or skipped validation.

---

## Suggested Commit

When fixed, suggest:

```bash
git add <bug-specific-files>
git commit -m "fix: <concise defect correction>"
```

Do not include unrelated changes.

Do not execute the commit.

---

## Definition of Done

This command execution is complete only when:

* the bug request was resolved;
* relevant skills were loaded;
* unrelated work was preserved;
* the defect was reproduced or statically confirmed;
* the execution path was traced;
* the root cause was identified;
* the smallest safe correction was implemented;
* regression protection was added when practical;
* related behavior was validated;
* contracts were synchronized;
* documentation was updated when necessary;
* fix status was classified honestly;
* no unrelated feature or refactoring was added;
* no destructive or real-cloud operation occurred;
* no commit was made automatically.

---

## Prohibited Behavior

Do not:

* implement unrelated features;
* perform broad cleanup;
* redesign architecture;
* update unrelated dependencies;
* weaken authentication or authorization;
* remove validation to make a test pass;
* remove failing tests;
* suppress errors without correction;
* patch only the frontend when backend data exposure exists;
* patch only the symptom when a safe root-cause fix exists;
* edit shared applied migrations;
* manually edit generated code;
* expose secrets;
* reset or discard user changes;
* mutate real AWS;
* remove Docker volumes;
* automatically commit or push;
* automatically invoke `/finish-task`.

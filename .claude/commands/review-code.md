---

name: review-code
description: Reviews current changes, files, commits, or branches for correctness, regressions, security risks, architectural violations, contract drift, missing tests, accessibility issues, and maintainability problems without modifying the repository.
argument-hint: "[current-changes|file-or-directory|commit <ref>|branch <name>|diff <base>..<head>]"
disable-model-invocation: true
user-invocable: true
model: inherit
effort: high
------------

# Review Code

Perform an evidence-based code review of the requested scope.

Requested review scope:

```text
$ARGUMENTS
```

If no argument was provided, review:

```text
current changes
```

This command is review-only.

Do not modify files.

Do not implement fixes.

Do not reformat code.

Do not update dependencies.

Do not create migrations.

Do not commit, push, reset, restore, clean, stash, rebase, or amend.

The primary objective is to identify defects and risks that could affect correctness, security, data integrity, user experience, operability, or maintainability.

---

## Review Priorities

Review findings in this order:

1. correctness;
2. security;
3. data integrity;
4. regressions;
5. broken contracts;
6. authorization;
7. concurrency;
8. error handling;
9. missing tests;
10. accessibility;
11. performance;
12. architecture;
13. maintainability;
14. style only when it creates real risk.

Do not focus on cosmetic preferences while meaningful defects remain.

Do not report a preference as a bug.

---

## Mandatory Context

Before reviewing code:

1. Read `CLAUDE.md`.
2. Read `.claude/skills/project-orchestrator/SKILL.md`.
3. Read `.claude/skills/testing-quality/SKILL.md`.
4. Read `.claude/skills/security/SKILL.md`.
5. Read `.claude/skills/documentation/SKILL.md`.
6. Identify all specialized skills relevant to the changed files.
7. Inspect the current project phase.
8. Inspect related feature and phase plans.
9. Inspect accepted ADRs relevant to the reviewed code.
10. Inspect API contracts when endpoints are affected.
11. Inspect migrations and queries when persistence is affected.
12. Inspect related tests.
13. Inspect `git status --short`.
14. Preserve all existing user work.
15. Determine the exact review target.
16. Verify that the target exists before reviewing it.

Do not assume a diff contains the complete context.

Read surrounding implementation when necessary to determine whether a finding is real.

---

# Review Scope Resolution

The argument may identify:

```text
current changes
staged changes
unstaged changes
file
directory
commit
branch
diff range
feature plan
```

Supported examples:

```text
current changes
staged
unstaged
apps/api/internal/articles
apps/web/src/features/species
commit HEAD
commit HEAD~1
branch feature/public-catalog
diff main..HEAD
docs/product/features/public-species-catalog.md
```

Resolve the target using the rules below.

---

## Current Changes

For:

```text
current changes
```

Inspect:

```bash
git status --short
git diff
git diff --cached
```

Review both staged and unstaged tracked changes.

Also inspect relevant untracked files when they belong to the task.

Do not review unrelated untracked files outside the project scope.

---

## Staged Changes

For:

```text
staged
```

Inspect:

```bash
git diff --cached
```

Review only staged changes and their necessary surrounding context.

---

## Unstaged Changes

For:

```text
unstaged
```

Inspect:

```bash
git diff
```

Review only unstaged tracked changes and necessary surrounding context.

---

## File or Directory

When the argument is a path:

1. verify it exists;
2. inspect the file or directory;
3. inspect related tests;
4. inspect callers and consumers when necessary;
5. inspect relevant contracts.

Do not review the whole repository unless the requested path has broad cross-cutting impact.

---

## Commit Review

For:

```text
commit <ref>
```

Verify the reference.

Inspect:

```bash
git show --stat <ref>
git show <ref>
```

Review the commit and necessary surrounding current code.

Identify when later commits may already have fixed a problem.

Do not report a historical issue as current without clarifying its current status.

---

## Branch Review

For:

```text
branch <name>
```

Determine the merge base against the default branch when possible.

Inspect:

```bash
git merge-base <default-branch> <name>
git diff <merge-base>..<name>
```

Do not assume the default branch is named `main`.

Inspect repository configuration or available branches.

Do not check out the branch automatically.

---

## Diff Range Review

For:

```text
diff <base>..<head>
```

Verify both references.

Inspect:

```bash
git diff --stat <base>..<head>
git diff <base>..<head>
```

Do not mutate the working tree.

---

## Feature Plan Review

When the argument points to a feature plan:

1. inspect the plan;
2. identify claimed implementation files;
3. inspect current diffs or completed increments;
4. compare implementation against acceptance criteria;
5. review only the implemented scope.

Do not treat planned future increments as missing defects.

---

# Invalid Scope

If the scope cannot be resolved:

1. explain what was not found;
2. provide accepted scope examples;
3. do not review unrelated code;
4. stop without changing files.

---

# Skill Selection

Always use:

```text
project-orchestrator
testing-quality
security
documentation
```

Load additional skills based on affected files.

## Backend

```text
go-backend
database
observability
```

## Frontend

```text
react-frontend
ux-design-system
```

## Domain

```text
product-domain
```

## Authentication

```text
authentication
```

## Content Editor

```text
content-editor
```

## Local Development

```text
local-development
```

## Terraform and AWS

```text
terraform-aws
```

Do not load unrelated skills.

---

# Review Method

Use this review process:

1. identify intended behavior;
2. identify changed behavior;
3. trace inputs and outputs;
4. inspect trust boundaries;
5. inspect state transitions;
6. inspect error paths;
7. inspect concurrency and cancellation;
8. inspect persistence and transactions;
9. inspect public contracts;
10. inspect frontend states;
11. inspect tests;
12. inspect documentation impact;
13. verify each potential finding against surrounding code;
14. report only actionable findings.

Do not report a concern before confirming whether another layer already handles it.

---

# Intended Behavior

Determine intended behavior from:

```text
feature plan
phase plan
acceptance criteria
tests
OpenAPI
ADRs
existing conventions
request context
```

If intended behavior is unclear:

* identify the uncertainty;
* avoid asserting a defect that depends on an unknown requirement;
* report the ambiguity only when it materially affects correctness.

Do not invent product requirements.

---

# Review Categories

Classify findings under:

```text
correctness
security
authorization
data_integrity
concurrency
error_handling
api_contract
database
frontend
accessibility
performance
observability
architecture
testing
documentation
maintainability
```

Use the most specific category.

---

# Severity Levels

Use:

## Critical

Use when the change may cause:

* exposed real secrets;
* remote code execution;
* complete authorization bypass;
* public exposure of private or unpublished data;
* destructive real-cloud behavior;
* irrecoverable broad data loss.

## High

Use when the change may cause:

* significant user-facing failure;
* privilege escalation;
* data corruption;
* broken migration;
* inaccessible critical workflow;
* unsafe file upload;
* production outage;
* invalid published content;
* broken authentication.

## Medium

Use when the change may cause:

* important edge-case failure;
* incomplete error handling;
* contract drift;
* missing important regression coverage;
* operational blind spot;
* accessibility barrier;
* meaningful performance degradation;
* maintainability risk likely to create defects.

## Low

Use when the change causes:

* localized inconsistency;
* minor accessibility issue;
* small maintainability problem;
* limited test gap;
* non-blocking documentation drift.

## Informational

Use for useful observations that are not defects.

Do not inflate severity.

Do not classify formatting as High.

---

# Confidence Levels

Classify each finding as:

```text
confirmed
high_confidence
possible
requires_runtime_verification
```

### Confirmed

Directly demonstrated by code, contract, test, or executable evidence.

### High Confidence

Strong evidence exists, but runtime confirmation may still help.

### Possible

The issue depends on an assumption or unverified environment behavior.

### Requires Runtime Verification

Static inspection cannot determine the outcome safely.

Do not report possible concerns as confirmed defects.

---

# Finding Requirements

Every finding must include:

```text
ID
title
severity
confidence
category
location
evidence
impact
scenario
recommended correction
test recommendation
```

A finding must be:

* specific;
* actionable;
* tied to code;
* relevant to the requested scope;
* more than a stylistic preference.

Do not report a finding without a concrete affected path or contract.

---

# Location Format

Use the smallest useful location.

Examples:

```text
apps/api/internal/articles/application/publish.go:48
apps/web/src/features/species/pages/SpeciesListPage.tsx:72-91
infrastructure/terraform/modules/storage/main.tf:15
```

If exact line numbers cannot be determined reliably, use:

```text
file
function
type
resource
migration
endpoint
```

Do not invent line numbers.

---

# Backend Review

When Go backend code is affected, inspect:

* package ownership;
* dependency direction;
* domain invariants;
* application orchestration;
* handler responsibilities;
* request validation;
* DTO boundaries;
* error mapping;
* context propagation;
* timeouts;
* graceful shutdown;
* authorization;
* transactions;
* logging;
* generated-code usage;
* test coverage.

Look specifically for:

```text
ignored errors
incorrect error wrapping
errors compared by message
panic for expected behavior
nil dereferences
incorrect zero-value handling
context.Background inside request flows
context stored in structs
missing cancellation
unbounded goroutines
concurrent map writes
race conditions
business rules in handlers
SQL in handlers
authorization only in middleware
missing object-level authorization
database models serialized directly
incorrect HTTP status
response written more than once
missing body limits
multiple JSON documents accepted
unbounded pagination
```

---

# Go Correctness Review

Check:

* pointer versus value semantics;
* slice and map aliasing;
* loop variable capture;
* deferred calls;
* error shadowing;
* typed nil behavior;
* resource closure;
* transaction rollback;
* channel closure;
* goroutine lifecycle;
* integer conversion;
* time handling;
* UUID parsing;
* nullable fields.

Do not report obsolete Go loop-variable issues without checking the configured Go version and actual code behavior.

---

# Context Review

Verify that request-bound operations:

* accept `context.Context`;
* propagate request context;
* respect cancellation;
* use deadlines for external dependencies;
* do not replace request context with `context.Background()`.

Background work may intentionally use a separate lifecycle context.

Do not report that as a defect without checking ownership.

---

# Error Handling Review

Verify:

* errors are handled;
* expected domain errors map correctly;
* internal messages are not exposed;
* errors are logged once at the correct boundary;
* client and server errors are distinguished;
* correlation IDs are included where appropriate;
* retryable and non-retryable failures are separated.

Look for:

```text
returning raw PostgreSQL errors
returning raw JWT errors
logging and returning the same internal message
swallowed cleanup errors
successful status after partial failure
```

---

# Authorization Review

For protected actions, verify:

* authentication;
* permission;
* ownership;
* resource state;
* account status;
* object-level access;
* server-side enforcement.

Look for:

```text
frontend-only permission checks
valid token treated as universal authorization
role name hardcoded inconsistently
resource ID accepted without access check
profile update allowing role fields
editor publishing without publish permission
draft visible through public endpoint
```

Do not assume administrators bypass domain validation.

---

# HTTP Review

Verify:

* correct methods;
* route versioning;
* path parameter validation;
* query validation;
* request size limits;
* content type handling;
* status codes;
* response schemas;
* standard error format;
* cache headers;
* authentication requirements;
* CORS behavior.

Check whether state-changing operations use `GET`.

Check whether `404`, `409`, and `422` are used consistently.

---

# Database Review

When migrations, SQL, or repositories are affected, inspect:

* migration order;
* reversibility;
* data preservation;
* constraints;
* foreign keys;
* delete behavior;
* indexes;
* query parameterization;
* deterministic ordering;
* pagination;
* transaction boundaries;
* sqlc generation;
* error mapping;
* null handling.

Look for:

```text
SELECT *
missing publication filter
missing uniqueness constraint
application-only uniqueness check
unsafe string concatenation
offset without deterministic order
foreign key without deletion analysis
missing transaction for multi-write operation
transaction open during external call
nullable field treated as empty string
JSONB used for frequently filtered stable fields
generated sqlc code edited manually
```

Do not recommend an index without identifying a query that needs it.

---

# Migration Review

For migrations, verify:

* naming convention;
* focus;
* forward migration;
* rollback strategy;
* destructive changes;
* default values;
* table locks;
* backfill behavior;
* compatibility with current code;
* shared-environment safety.

Look for:

```text
editing an existing applied migration
adding NOT NULL without backfill
dropping a column before consumers migrate
changing enum-like values incompatibly
destructive down migration pretending to restore data
migration dependent on local seed data
```

---

# API Contract Review

Compare:

```text
router
handler
request DTO
response DTO
OpenAPI
frontend client
frontend types
tests
```

Look for:

```text
field-name mismatch
optional versus required mismatch
status mismatch
missing error response
pagination mismatch
authentication mismatch
frontend expecting unpublished fields
OpenAPI path not registered
registered path absent from OpenAPI
```

Do not treat one side as automatically correct.

Report the drift and identify the competing contracts.

---

# Frontend Review

When React code is affected, inspect:

* route behavior;
* layout usage;
* component boundaries;
* server-state ownership;
* query keys;
* API cancellation;
* loading;
* empty;
* error;
* not found;
* authentication;
* permission-aware UI;
* forms;
* Zod schemas;
* responsive behavior;
* accessibility;
* rendering safety;
* test coverage.

Look for:

```text
any
unsafe type assertions
stale closures
effects used for derived state
missing effect cleanup
infinite render loops
unstable query keys
duplicated server state
fetch inside many components
mutation without error recovery
form input lost on failure
missing loading state
missing empty state
missing error state
incorrect route guard
unsafe HTML
secret in VITE variable
```

---

# React Correctness Review

Check:

* stable list keys;
* controlled and uncontrolled input transitions;
* state synchronization;
* dependency arrays;
* event-handler references;
* race conditions between requests;
* stale responses;
* mutation invalidation;
* optimistic rollback;
* Suspense or lazy-loading boundaries;
* route parameter handling.

Do not recommend memoization without evidence of a meaningful rendering problem.

---

# TanStack Query Review

Verify:

* structured query keys;
* correct parameters included in keys;
* request signal propagation;
* retry policy;
* invalidation after mutations;
* stale-time behavior;
* errors handled explicitly;
* no server-state duplication.

Look for:

```text
filter omitted from query key
mutation succeeds but list remains stale
retrying 401 or 403 repeatedly
request cancellation ignored
query enabled before required parameter exists
```

---

# Form Review

Verify:

* labels;
* schema;
* default values;
* backend errors;
* disabled state;
* duplicate-submit protection;
* input preservation;
* null and empty semantics;
* permission restrictions;
* focus after errors.

Look for:

```text
placeholder used as label
role or status accepted in public form
server field errors discarded
form reset on failed submission
button enabled during duplicate request
```

---

# Accessibility Review

Inspect changed interfaces for:

* semantic elements;
* headings;
* landmarks;
* keyboard access;
* visible focus;
* accessible names;
* labels;
* descriptions;
* error announcements;
* dialog focus;
* status communication;
* image alt text;
* color independence;
* reduced motion;
* touch targets.

Look for:

```text
clickable div
missing button label
outline removed
dialog without title
focus not restored
status conveyed only by color
image missing meaningful alt text
drag-and-drop without keyboard alternative
```

Do not claim full accessibility compliance from static review.

---

# UX Review

Evaluate changed user journeys for:

* clear hierarchy;
* primary action;
* recovery;
* consistency;
* responsive behavior;
* public versus admin distinction;
* scientific-name styling;
* responsible risk presentation;
* content readability.

Do not report subjective visual taste.

Tie findings to usability, accessibility, product principles, or consistency.

---

# Content Security Review

When article content or rich text is affected, verify:

* explicit schemas;
* supported block types;
* backend validation;
* safe links;
* safe public rendering;
* media references;
* payload limits;
* preview protection;
* draft privacy.

Look for:

```text
arbitrary HTML
unvalidated TipTap document
dangerouslySetInnerHTML with untrusted content
javascript URLs
arbitrary iframe embeds
unknown blocks silently deleted
public preview URLs
base64 images
```

---

# Authentication Review

When authentication changes, verify:

* Authorization Code Flow;
* PKCE;
* public frontend client;
* no frontend client secret;
* issuer;
* audience;
* signature;
* expiration;
* algorithms;
* JWKS caching;
* subject mapping;
* role ownership;
* token storage;
* logout;
* return-path safety;
* local Keycloak reproducibility.

Look for:

```text
JWT decoded without verification
ID token used as access token
localStorage refresh token
email as sole identity key
wildcard redirect URI
raw token logged
invalid token silently treated as anonymous
```

---

# Infrastructure Review

For Docker, Compose, LocalStack, Terraform, and AWS-related changes, inspect:

* pinned versions;
* environment boundaries;
* endpoint safety;
* state;
* credentials;
* IAM;
* networking;
* encryption;
* public exposure;
* health checks;
* cost;
* destructive behavior;
* LocalStack versus real AWS separation.

Look for:

```text
latest image
localhost used between containers
real AWS credential fallback
global Docker prune
normal down removing volumes
privileged container
Docker socket mount
Terraform state committed
hardcoded credentials
wildcard IAM
public database
public Redis
LocalStack endpoint in production
generic apply command targeting arbitrary environment
```

---

# Terraform Review

Verify:

* provider pinning;
* Terraform version;
* typed variables;
* state isolation;
* outputs;
* sensitive values;
* module ownership;
* naming;
* tags;
* lifecycle;
* destructive replacements;
* AWS account assumptions.

Do not run apply or destroy.

Review plans only when a plan is part of the requested scope and can be inspected safely.

---

# Observability Review

Verify:

* stable structured fields;
* correlation propagation;
* safe logs;
* correct levels;
* health semantics;
* readiness semantics;
* dependency criticality;
* audit events;
* bounded metric labels;
* useful error codes.

Look for:

```text
raw token logs
request body logs
article content logs
search query logs
same error logged at every layer
optional dependency breaking health
expensive readiness checks
user ID used as metric label
raw path used as metric label
```

---

# Performance Review

Report only evidence-backed risks.

Check:

* N+1 database calls;
* unbounded lists;
* missing deterministic pagination;
* unnecessary repeated network requests;
* slow operations inside transactions;
* large payloads;
* missing image dimensions;
* frontend full-dataset pagination;
* large dependencies;
* uncontrolled retries;
* unbounded goroutines.

Do not report speculative performance concerns as defects.

Use `possible` or `requires_runtime_verification` when measurement is needed.

---

# Testing Review

Inspect whether changed behavior is protected.

Verify:

* happy path;
* failure path;
* boundary cases;
* authorization failures;
* migration behavior;
* repository integration;
* frontend states;
* accessibility behavior;
* regression cases.

Look for:

```text
new behavior without tests
test only checking implementation details
mocking away the behavior under review
shared test state
real credentials
arbitrary sleeps
test-order dependency
large brittle snapshots
```

Do not demand every behavior at every test level.

Recommend the cheapest test that provides confidence.

---

# Test Adequacy

For each changed behavior, classify coverage as:

```text
adequate
partial
missing
not_applicable
```

A test file existing is not proof of adequate coverage.

Check whether it verifies the changed behavior and failure mode.

---

# Documentation Review

When behavior, commands, contracts, or architecture changed, inspect:

```text
README
OpenAPI
feature plan
phase plan
ADR
development guide
runbook
environment variables
architecture diagrams
```

Look for:

```text
new endpoint absent from OpenAPI
new variable absent from .env.example
new command absent from Makefile help
future behavior documented as current
feature increment marked complete without evidence
```

Do not request documentation changes for purely internal refactoring unless maintainers need them.

---

# Dead Code and Scope Review

Inspect changed code for:

```text
unused abstractions
empty interfaces
placeholder methods
TODO masking incomplete behavior
commented-out implementation
future-phase code
unused configuration
unused dependencies
duplicate helpers
```

Do not report every TODO.

Report only when it:

* blocks the task;
* creates misleading completeness;
* introduces risk;
* leaves dead production paths.

---

# Backward Compatibility

When existing contracts change, assess:

* database compatibility;
* API compatibility;
* frontend compatibility;
* seed compatibility;
* migration order;
* deployment order;
* old-client behavior;
* rollback.

Look for changes such as:

```text
renamed JSON field
required field added
status code changed
column dropped
enum value removed
route changed
authentication added unexpectedly
```

Report breaking changes even if the code compiles.

---

# Review Validation

The review may run targeted safe commands when they materially improve confidence.

Examples:

```bash
go test ./internal/articles/...
npm run test -- SpeciesList
terraform validate
docker compose config
```

Do not turn the review into a full project audit unless the scope requires it.

Do not modify files to make commands pass.

If a formatter or generator would mutate files, do not run it unless the user explicitly requested validation that permits generated diffs.

---

# Command Result Reporting

For commands executed, report:

```text
command
working directory
result
relevant evidence
```

Classify as:

```text
passed
failed
blocked
skipped
not_configured
not_installed
```

Do not claim a test passed without running it.

---

# Avoiding False Positives

Before reporting a finding:

1. inspect surrounding code;
2. inspect relevant caller or consumer;
3. inspect tests;
4. inspect contract;
5. confirm the execution path is reachable;
6. confirm another layer does not already mitigate it;
7. determine whether it belongs to the reviewed change.

Do not report theoretical risks with no reachable scenario.

Do not report code outside the scope unless the reviewed change directly interacts with it.

---

# Duplicate Findings

Consolidate findings with the same root cause.

Example:

A missing publication filter may cause:

* draft API exposure;
* search exposure;
* frontend display.

Report one primary finding and list affected paths.

Do not create several inflated findings for the same defect.

---

# Review Outcome

Classify the review as:

```text
approve
approve_with_comments
request_changes
blocked
```

## Approve

No correctness, security, data, or contract findings requiring changes.

Low or informational observations may remain.

## Approve with Comments

No blocking issue, but useful non-blocking improvements exist.

## Request Changes

One or more findings should be fixed before merge or completion.

Usually applies to Critical, High, or material Medium findings.

## Blocked

The review could not be completed because:

* scope was invalid;
* required files were unavailable;
* diff was incomplete;
* merge conflict prevented interpretation;
* essential context was missing.

Do not approve code merely because no issue was found in an incomplete review.

---

# Finding Format

Use:

```markdown
### REV-001 — Finding title

Severity: High  
Confidence: Confirmed  
Category: Authorization  
Location: `apps/api/internal/articles/application/publish.go:48`

Evidence:

Describe the exact code behavior.

Impact:

Describe what can fail or be exploited.

Scenario:

Describe a realistic execution path.

Recommended correction:

Describe the smallest safe correction without implementing it.

Test recommendation:

Describe the regression or validation test that should protect the correction.
```

Order findings by:

1. severity;
2. confidence;
3. execution likelihood;
4. user impact.

---

# No-Finding Behavior

When no actionable findings are identified, state:

```text
No actionable correctness, security, data-integrity, contract, or regression findings were identified in the reviewed scope.
```

Still report:

* review scope;
* files inspected;
* tests examined;
* commands executed;
* remaining uncertainty.

Do not invent low-value findings to avoid an empty review.

---

# Suggested Corrections

Corrections must remain concise and implementation-neutral enough to respect project architecture.

Do not provide a full patch unless the user asks for fixes.

Do not rewrite the reviewed code inside the review.

The next action may recommend:

```text
/fix-bug <finding>
```

or:

```text
/implement-feature <missing increment>
```

Do not invoke another command automatically.

---

# Git Safety

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

Read-only Git commands are allowed.

Do not alter the index or working tree.

---

# Real Infrastructure Safety

Do not:

* run Terraform apply;
* run Terraform destroy;
* change AWS resources;
* modify DNS;
* send email;
* assign roles;
* publish content;
* reset databases;
* remove Docker volumes.

Read-only inspection is allowed when explicitly within scope and safely configured.

---

# Final Response Format

Use:

```markdown
## Review summary

## Scope

## Outcome

## Files and contracts reviewed

## Findings

### Critical

### High

### Medium

### Low

## Test coverage assessment

## Commands executed

## Remaining uncertainty

## Recommended next action
```

When a severity category has no findings, state:

```text
None identified.
```

Do not bury findings after long general commentary.

---

# Definition of Done

This command execution is complete only when:

* the review scope was resolved;
* required context was inspected;
* relevant skills were loaded;
* intended behavior was identified;
* changed behavior was traced;
* findings were evidence-based;
* severity and confidence were assigned;
* false positives were actively checked;
* tests and contracts were reviewed;
* the working tree was not modified;
* review outcome was classified;
* remaining uncertainty was reported;
* no fix was implemented automatically.

---

# Prohibited Behavior

Do not:

* modify files;
* implement fixes;
* reformat code;
* create migrations;
* update dependencies;
* regenerate code;
* stage or commit;
* discard user changes;
* report style preferences as bugs;
* report theoretical risks without evidence;
* duplicate findings;
* inflate severity;
* omit missing-test findings for risky behavior;
* approve incomplete or unreviewable changes;
* expose secrets in review evidence;
* run destructive commands;
* mutate real AWS;
* automatically invoke `/fix-bug`;
* automatically invoke `/finish-task`.

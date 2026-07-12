---

name: plan-feature
description: Produces an implementation-ready feature plan by analyzing product scope, project phase, domain rules, architecture, contracts, dependencies, risks, tests, security, observability, accessibility, and acceptance criteria without changing implementation files.
argument-hint: "[feature-description]"
disable-model-invocation: true
user-invocable: true
model: inherit
effort: high
---

# Plan Feature

Create a complete and implementation-ready plan for the requested feature.

Feature request:

```text
$ARGUMENTS
```

This command is planning-only.

Do not implement production code.

Do not create migrations.

Do not change application behavior.

Do not run destructive commands.

Documentation may be created or updated only when necessary to persist the approved feature plan.

---

## Objective

Transform the feature request into a clear technical plan that can be executed incrementally.

The plan must define:

* user and product objective;
* current project phase;
* task category;
* scope;
* non-goals;
* actors;
* use cases;
* domain rules;
* authorization;
* data model impact;
* backend impact;
* API contracts;
* frontend impact;
* UX states;
* infrastructure impact;
* security considerations;
* observability;
* testing strategy;
* documentation impact;
* implementation increments;
* acceptance criteria;
* risks;
* unresolved decisions.

The output must be detailed enough for `/implement-feature` to execute without redefining the feature from scratch.

---

## Mandatory Context

Before writing the plan:

1. Read `CLAUDE.md`.
2. Read `.claude/skills/project-orchestrator/SKILL.md`.
3. Read `.claude/skills/product-domain/SKILL.md` when the feature involves reptiles, species, taxonomy, articles, references, ecology, or conservation.
4. Read all specialized skills relevant to the feature.
5. Inspect the repository structure.
6. Inspect existing related modules.
7. Inspect current tests.
8. Inspect API specifications.
9. Inspect migrations and queries when persistence may be affected.
10. Inspect frontend routes and components when user interface behavior may be affected.
11. Inspect current documentation and ADRs.
12. Inspect `git status --short`.
13. Preserve all existing user changes.
14. Identify the current project phase.
15. Verify whether the requested feature belongs to the current phase.

Do not assume the repository is empty.

Do not create a plan that contradicts existing accepted ADRs without explicitly identifying the conflict.

---

## Feature Request Validation

Before planning, evaluate whether the request is:

```text
clear
partially_defined
ambiguous
out_of_scope
future_phase
conflicting
```

### Clear

The objective and expected behavior are sufficiently defined.

### Partially Defined

The feature can be planned using documented project conventions and conservative assumptions.

### Ambiguous

A material decision prevents a safe plan.

When possible, choose the smallest reversible assumption and document it.

Do not stop for minor ambiguities.

### Out of Scope

The request conflicts with project principles or explicitly excluded functionality.

Examples:

* converting the modular monolith into microservices;
* allowing public article publication during the initial phases;
* storing arbitrary unsanitized HTML;
* creating real AWS resources during local-only work.

### Future Phase

The feature belongs to a later phase.

Create a preparatory plan only if requested.

Do not present future-phase work as current implementation scope.

### Conflicting

The request conflicts with existing code, API, schema, or ADRs.

Document the conflict and the required decision.

---

## Phase Classification

Map the feature to one official phase.

### Phase 0 — Foundation

Examples:

* application skeleton;
* Docker Compose;
* health checks;
* logging;
* CI;
* Terraform foundation.

### Phase 1 — Public Catalog

Examples:

* species listing;
* species page;
* article page;
* taxonomy;
* public search.

### Phase 2 — Users and Authentication

Examples:

* registration;
* login;
* profile;
* roles;
* permissions.

### Phase 3 — Administration

Examples:

* article CRUD;
* species CRUD;
* editor;
* publishing;
* media upload.

### Phase 4 — Advanced Editorial Experience

Examples:

* revisions;
* advanced blocks;
* galleries;
* maps;
* SEO extensions.

### Phase 5 — Gamification

Examples:

* progress;
* achievements;
* quizzes;
* levels.

### Phase 6 — AWS Deployment

Examples:

* ECS;
* RDS;
* CloudFront;
* Cognito;
* WAF;
* CI/CD deployment.

If the feature spans multiple phases:

1. identify the primary phase;
2. separate immediate scope from future extensions;
3. plan only the requested executable phase;
4. document extension points without implementing them.

---

## Task Category

Classify the feature as one or more:

```text
feature
foundation
refactoring
bug_fix
infrastructure
security
documentation
```

A feature plan should normally have one primary category.

Do not describe routine feature work as refactoring merely because internal code will change.

---

## Skill Selection

Always use:

```text
project-orchestrator
testing-quality
documentation
security
```

Load additional skills according to the feature.

### Domain content

```text
product-domain
```

### Go backend and API

```text
go-backend
```

### React frontend

```text
react-frontend
ux-design-system
```

### PostgreSQL and sqlc

```text
database
```

### Authentication and permissions

```text
authentication
```

### Article editor and blocks

```text
content-editor
```

### Docker and local services

```text
local-development
```

### Terraform and AWS

```text
terraform-aws
```

### Logs, health, metrics, or audit

```text
observability
```

Do not load unrelated skills.

---

## Existing-State Analysis

Identify what already exists.

Inspect:

* related domain entities;
* use cases;
* HTTP handlers;
* routes;
* request and response DTOs;
* migrations;
* SQL queries;
* repositories;
* frontend routes;
* pages;
* components;
* forms;
* query hooks;
* tests;
* documentation;
* infrastructure resources.

Classify each required capability as:

```text
existing_and_reusable
existing_but_requires_change
missing
conflicting
```

Do not plan duplicate implementations for existing capabilities.

---

## User and Actor Analysis

Identify all actors.

Possible actors:

```text
visitor
member
editor
administrator
system
background_worker
```

For each actor, define:

* what they can see;
* what they can do;
* what they cannot do;
* what permissions are required;
* what error or forbidden state applies.

Do not assume authentication when the feature is public.

Do not assume administrators bypass every domain rule.

---

## User Problem

State the user problem in one concise paragraph.

The problem statement must describe:

* who has the problem;
* what they need to accomplish;
* why current behavior is insufficient;
* what outcome creates value.

Avoid defining the problem only in technical terms.

Bad example:

```text
We need a new endpoint.
```

Better example:

```text
Visitors need to browse published reptile species by editorial group so they can discover relevant content without knowing a scientific name.
```

---

## Feature Objective

Define one primary objective.

The objective must be observable.

Example:

```text
Allow visitors to browse published species by editorial group with pagination and clear empty states.
```

Do not combine several unrelated objectives into one feature.

---

## Scope

Define exactly what is included.

Example:

```text
Included:
- public species list endpoint;
- editorial-group filter;
- server-side pagination;
- species cards;
- loading, error, and empty states;
- URL-synchronized filters;
- integration tests;
- OpenAPI update.
```

Scope must be implementable as a coherent vertical slice.

---

## Non-Goals

Explicitly define what is not included.

Example:

```text
Not included:
- authenticated favorites;
- administration CRUD;
- advanced full-text search;
- AWS deployment;
- multilingual content;
```

Non-goals protect the implementation from uncontrolled expansion.

Do not use vague phrases such as:

```text
advanced features
future improvements
other things
```

Name excluded behaviors clearly.

---

## User Stories

Create only useful user stories.

Format:

```text
As a <actor>,
I want <capability>,
so that <outcome>.
```

Example:

```text
As a visitor,
I want to filter published species by editorial group,
so that I can discover snakes, lizards, turtles, crocodilians, or tuataras.
```

Do not create many nearly identical stories.

Prefer three to seven meaningful stories.

---

## Use Cases

For each primary use case, define:

```text
actor
preconditions
trigger
main flow
alternative flows
failure flows
postconditions
```

Example:

```text
Use case: Filter species by editorial group

Actor:
Visitor

Preconditions:
Published species exist.

Trigger:
The visitor selects "Snakes".

Main flow:
1. The frontend updates the URL.
2. The frontend requests the filtered first page.
3. The backend validates the filter.
4. The database returns published matching species.
5. The page displays the result count and cards.

Alternative flow:
No species match the filter.

Failure flow:
The API is unavailable.

Postcondition:
The selected filter remains shareable through the URL.
```

Do not use use cases to describe internal class calls.

---

## Domain Rules

Identify all domain rules.

Examples:

* public endpoints return only published content;
* editorial groups are not taxonomic ranks;
* scientific names render in italics;
* conservation status requires authority;
* an editor cannot publish without permission;
* draft content may be incomplete;
* published article content must pass publication validation.

Separate rules into:

```text
invariants
validation
workflow
authorization
presentation
```

Do not treat presentation preferences as domain invariants.

---

## Assumptions

Document assumptions made because the request did not define them.

Each assumption must be:

* conservative;
* reversible;
* aligned with existing architecture;
* clearly labeled.

Example:

```text
Assumption: the initial species listing uses page-based pagination because current data volume does not require cursor pagination.
```

Do not hide assumptions inside implementation details.

---

## Functional Requirements

Use numbered requirements.

Example:

```text
FR-01: The public API must return only published species.
FR-02: The endpoint must support editorial-group filtering.
FR-03: The endpoint must support bounded page-based pagination.
FR-04: The frontend must preserve filters in the URL.
FR-05: The page must display loading, empty, error, and success states.
```

Requirements must be testable.

Avoid:

```text
The page should be beautiful.
```

Replace with observable design requirements.

---

## Non-Functional Requirements

Evaluate:

* security;
* accessibility;
* performance;
* reliability;
* maintainability;
* observability;
* privacy;
* responsiveness;
* compatibility.

Example:

```text
NFR-01: List requests must enforce a maximum page size.
NFR-02: Filter controls must be keyboard accessible.
NFR-03: Public responses must not include internal editorial metadata.
NFR-04: Request logs must use route templates rather than raw slugs.
```

Do not add arbitrary performance targets without evidence or project standards.

---

## Data Model Impact

Determine whether the feature requires:

```text
no_schema_change
new_table
new_column
new_relationship
new_constraint
new_index
data_migration
seed_change
```

For each change, define:

* owning module;
* table;
* field or relationship;
* type;
* nullability;
* constraints;
* indexes;
* migration direction;
* rollback considerations;
* seed impact.

Example:

```text
species.editorial_group
Type: text
Required: yes for published records
Constraint: allowed editorial-group values
Index: partial index for published species filtering
```

Do not design the database only around frontend presentation.

Do not add JSONB when a stable queryable column is needed.

---

## Data Lifecycle

Evaluate:

* creation;
* update;
* publication;
* archival;
* deletion;
* retention;
* audit;
* migration.

Do not add soft delete automatically.

Do not ignore lifecycle effects when the feature changes publication state.

---

## Backend Impact

Identify:

* module ownership;
* domain changes;
* value objects;
* entities;
* application use cases;
* repository ports;
* SQL queries;
* transactions;
* HTTP handlers;
* middleware;
* configuration;
* generated code.

Use the dependency direction:

```text
transport -> application -> domain
infrastructure -> application or domain ports
```

Do not plan business rules inside handlers.

---

## API Contract

For every new or changed endpoint, define:

```text
method
path
authentication
permission
path parameters
query parameters
request body
success responses
error responses
pagination
sorting
visibility rules
```

Example:

```text
Method:
GET

Path:
/api/v1/species

Authentication:
Public

Query parameters:
editorialGroup
page
pageSize
sort
order

Success:
200 OK

Errors:
400 invalid query parameter
422 invalid filter value
500 internal server error
503 database unavailable
```

Do not create a generic endpoint when an explicit command endpoint better protects workflow rules.

---

## Request Contract

Define the request schema.

For query parameters, define:

* type;
* optionality;
* default;
* allowed values;
* minimum;
* maximum;
* normalization.

Example:

```text
page:
integer
default 1
minimum 1

pageSize:
integer
default 20
minimum 1
maximum 100
```

Do not leave pagination unbounded.

---

## Response Contract

Define the response shape.

Example:

```json
{
  "items": [
    {
      "id": "uuid",
      "slug": "green-sea-turtle",
      "commonName": "Green sea turtle",
      "scientificName": "Chelonia mydas",
      "summary": "A large marine turtle...",
      "editorialGroup": "turtles_and_tortoises",
      "primaryImage": {
        "url": "http://localhost:4566/...",
        "altText": "Green sea turtle swimming above seagrass"
      }
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 1,
    "totalPages": 1
  }
}
```

Do not expose database rows directly.

---

## Error Contract

Define expected errors.

Use the standard project problem format.

Example:

```text
invalid_query
validation_error
unauthenticated
forbidden
not_found
conflict
dependency_unavailable
internal_error
```

For each error, define:

* status;
* safe detail;
* field errors when relevant;
* client recovery behavior.

Do not expose SQL or infrastructure messages.

---

## Frontend Impact

Identify:

* routes;
* layouts;
* pages;
* feature components;
* shared components;
* query keys;
* API functions;
* forms;
* Zod schemas;
* URL state;
* authentication state;
* permission-based rendering;
* SEO metadata.

Do not plan a frontend component without defining its data and error states.

---

## UI States

Every asynchronous interface must define:

```text
initial
loading
success
empty
error
not_found
unauthenticated
forbidden
submitting
submitted
conflict
```

Use only states relevant to the feature.

For each state, define:

* visible content;
* available actions;
* focus behavior;
* retry behavior.

Do not define only the successful state.

---

## UX and Accessibility

Define:

* semantic structure;
* heading hierarchy;
* keyboard interactions;
* focus management;
* accessible names;
* labels;
* error announcements;
* responsive behavior;
* touch targets;
* reduced motion;
* image alt-text requirements.

Example:

```text
The filter button must expose its expanded state through aria-expanded.
The mobile filter dialog must restore focus to the trigger when closed.
```

Do not use visual-only acceptance criteria.

---

## Responsive Behavior

Define behavior for:

```text
mobile
tablet
desktop
wide desktop
```

Example:

```text
Mobile:
Filters open in an accessible dialog.

Desktop:
Filters remain visible in a sidebar.

All viewports:
Active filters are shown above the results.
```

Do not duplicate separate mobile and desktop implementations unless behavior genuinely differs.

---

## Security Analysis

Identify:

* protected assets;
* user-controlled inputs;
* trust boundaries;
* authorization;
* mass assignment;
* XSS;
* SQL injection;
* upload risks;
* SSRF;
* rate limiting;
* sensitive data;
* unpublished content;
* audit requirements.

Define required mitigations.

Example:

```text
Public search results must include only published content.
Sort fields must use an allowlist.
Raw search terms must not be logged.
```

Do not say “apply security best practices” without specifying controls.

---

## Privacy Analysis

Evaluate whether the feature introduces:

* personal data;
* activity tracking;
* search-term collection;
* analytics;
* account data;
* retention requirements.

Document:

* collected data;
* purpose;
* storage;
* retention;
* public exposure;
* deletion implications.

Do not introduce tracking as an unstated side effect.

---

## Observability Plan

Define operational questions.

Examples:

```text
How often does this endpoint fail?
How long do search queries take?
How many publication attempts fail validation?
Are media uploads leaving orphaned objects?
```

Then define appropriate signals:

* logs;
* counters;
* histograms;
* audit events;
* readiness impact.

Do not create high-cardinality metric labels.

---

## Performance Considerations

Evaluate:

* pagination;
* query indexes;
* N+1 behavior;
* payload size;
* image loading;
* bundle impact;
* expensive rendering;
* external calls;
* caching needs.

Do not add caching before identifying a real need.

Do not define performance optimizations without query or usage rationale.

---

## Local Development Impact

Identify changes to:

* Compose;
* environment variables;
* LocalStack resources;
* Keycloak configuration;
* Mailpit;
* Makefile;
* bootstrap;
* seed;
* test services.

Do not require real cloud services.

Do not introduce undocumented manual setup.

---

## Terraform and AWS Impact

Classify as:

```text
none
localstack_only
future_aws_extension
real_aws_required
```

For planning before Phase 6, prefer:

```text
future_aws_extension
```

without implementing resources.

If real AWS is required, explicitly state that deployment requires separate authorization.

Do not assume planning grants deployment permission.

---

## Testing Strategy

Define tests by level.

### Domain

* invariants;
* validation;
* workflow.

### Application

* authorization;
* orchestration;
* repository behavior through fakes.

### Handler

* request parsing;
* status;
* response;
* errors.

### Repository integration

* PostgreSQL queries;
* constraints;
* pagination;
* filters.

### Frontend unit or component

* schemas;
* UI behavior;
* accessibility;
* server error mapping.

### End-to-end

* critical user journey.

### Infrastructure

* Compose validation;
* Terraform validation;
* LocalStack resources.

Do not require E2E tests for every small feature.

---

## Test Matrix

Create a concise matrix.

Example:

| Scenario                       | Expected result    | Test level             |
| ------------------------------ | ------------------ | ---------------------- |
| Published species match filter | Results returned   | Repository + API       |
| Draft species match filter     | Not returned       | Repository integration |
| Invalid editorial group        | Validation problem | Handler                |
| No matches                     | Empty state        | Frontend component     |
| API unavailable                | Retry state        | Frontend component     |
| Mobile filter opens            | Accessible dialog  | Component/E2E          |

Do not create redundant scenarios across many levels without reason.

---

## Documentation Impact

Identify updates to:

```text
README.md
OpenAPI
domain glossary
product model
ADR
architecture diagrams
development guide
runbook
testing documentation
security documentation
phase plan
```

For each document, state why it changes.

Do not create an ADR for ordinary feature implementation unless an architectural decision exists.

---

## Migration and Compatibility

When changing an existing contract, define:

* backward compatibility;
* rollout order;
* schema expansion;
* backfill;
* application deployment;
* cleanup;
* rollback;
* frontend compatibility;
* old clients.

Do not assume a breaking change is safe because the project is local.

Practice explicit contract evolution.

---

## Dependencies

List new dependencies only when required.

For each proposed dependency, document:

* purpose;
* alternatives;
* maintenance;
* security;
* license;
* bundle or runtime impact.

Do not add a dependency merely because it is popular.

Prefer existing stack and standard library.

---

## Implementation Increments

Break work into small, ordered increments.

Each increment must include:

* objective;
* changed areas;
* observable result;
* tests;
* validation;
* dependency on earlier increments.

Example:

```text
Increment 1:
Add domain and database support for editorial groups.

Increment 2:
Add filtered public species API.

Increment 3:
Add frontend filter and URL state.

Increment 4:
Add integration and E2E coverage.

Increment 5:
Update OpenAPI and user documentation.
```

Do not create an increment that changes every layer without an independently testable result unless it is the smallest valid vertical slice.

---

## Recommended First Increment

Identify the first implementation increment.

It should:

* satisfy foundational dependencies;
* be small;
* produce a valid state;
* avoid speculative work;
* have clear validation.

Do not start implementing it during this command.

---

## Acceptance Criteria

Use observable criteria.

Format:

```text
AC-01
Given <context>,
when <action>,
then <observable result>.
```

Example:

```text
AC-01
Given published snake and lizard species,
when a visitor filters by snakes,
then only published snake species are displayed.
```

Include:

* happy path;
* empty state;
* error path;
* authorization path when relevant;
* accessibility;
* responsive behavior;
* contract behavior.

Do not use acceptance criteria such as:

```text
Code is clean.
UI is modern.
Feature works correctly.
```

---

## Definition of Ready

The feature is ready for implementation when:

* objective is clear;
* phase is identified;
* scope and non-goals are explicit;
* actors are identified;
* requirements are testable;
* domain rules are defined;
* API contracts are defined;
* data impacts are defined;
* security controls are defined;
* UI states are defined;
* test strategy is defined;
* increments are ordered;
* acceptance criteria are complete;
* unresolved decisions do not block the first increment.

Do not mark the feature ready if a foundational decision remains unresolved.

---

## Feature Plan File

Create or update a feature plan only when persistence is useful.

Recommended path:

```text
docs/product/features/<feature-slug>.md
```

Example:

```text
docs/product/features/public-species-catalog.md
```

Do not create the file for trivial changes.

Do not overwrite a previously implemented feature plan without preserving status and decisions.

---

## Feature Plan Template

When creating a file, use:

```markdown
# Feature: Feature Name

## Status

Planned

## Phase

## Category

## Objective

## User problem

## Scope

## Non-goals

## Actors

## User stories

## Use cases

## Assumptions

## Domain rules

## Functional requirements

## Non-functional requirements

## Data model impact

## Backend impact

## API contract

## Frontend impact

## UX and accessibility

## Security and privacy

## Observability

## Local-development impact

## Infrastructure impact

## Testing strategy

## Documentation impact

## Dependencies

## Implementation increments

## Recommended first increment

## Acceptance criteria

## Risks

## Open decisions

## Definition of ready
```

Do not include empty sections without stating `None` or explaining why they do not apply.

---

## Risk Assessment

Identify risks under:

```text
scope
domain
security
data
compatibility
performance
accessibility
operations
dependency
delivery
```

For each relevant risk, define:

* impact;
* likelihood;
* mitigation.

Example:

```text
Risk:
Editorial-group values diverge between backend and frontend.

Impact:
Invalid filters and inconsistent labels.

Mitigation:
Use one API enum contract, backend validation, generated or centralized frontend type, and contract tests.
```

Do not list generic risks without mitigations.

---

## Open Decisions

List only decisions that genuinely require resolution.

For each decision, include:

* question;
* options;
* recommended option;
* impact;
* whether it blocks implementation.

Example:

```text
Decision:
Should editorial-group values be fixed by code or stored in a database table?

Recommendation:
Use a validated fixed value set during Phase 1 because groups are stable and not administratively managed yet.

Blocking:
No.
```

Do not defer every technical choice to future discussion.

Use project principles to resolve small reversible decisions.

---

## Planning Validation

Before completing the plan, verify:

* no implementation files were changed;
* no future-phase feature was included accidentally;
* requirements are testable;
* API fields match domain terminology;
* authorization is backend-owned;
* UI states are complete;
* migrations are explicit;
* documentation impact is covered;
* risks have mitigations;
* first increment is actionable.

If a feature-plan document was created, review it for consistency with `CLAUDE.md`.

---

## Final Response Format

Use:

```markdown
## Feature

## Planning status

## Phase and category

## Objective

## Scope

## Non-goals

## Actors and use cases

## Domain rules

## Functional requirements

## Technical impact

### Backend

### Database

### API

### Frontend

### Local development and infrastructure

## UX and accessibility

## Security and privacy

## Observability

## Testing strategy

## Implementation increments

## Recommended first increment

## Acceptance criteria

## Risks

## Open decisions

## Definition of ready

## Documentation created or updated
```

Keep the response implementation-ready but avoid unnecessary repetition.

---

## Definition of Done

This command is complete only when:

* the feature request was analyzed;
* the current phase was identified;
* scope and non-goals were defined;
* actors and use cases were defined;
* domain rules were identified;
* backend, database, API, and frontend impacts were evaluated;
* security, accessibility, observability, and testing were covered;
* implementation increments were ordered;
* acceptance criteria were testable;
* risks and open decisions were documented;
* no production implementation was performed;
* any feature-plan file created matches actual project conventions.

---

## Prohibited Behavior

Do not:

* implement the feature;
* create production migrations;
* modify application behavior;
* run destructive commands;
* plan outside the current phase without clear separation;
* create speculative microservices;
* define generic CRUD without domain analysis;
* place authorization only in the frontend;
* omit failure and empty states;
* omit security considerations;
* omit tests;
* create unbounded pagination;
* use raw unsanitized HTML;
* invent existing code or files;
* invent requirements without labeling assumptions;
* declare a feature ready when blocking decisions remain;
* automatically invoke `/implement-feature`.

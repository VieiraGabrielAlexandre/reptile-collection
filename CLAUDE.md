# CLAUDE.md

## 1. Project Overview

This repository contains an editorial platform dedicated to building a structured knowledge base about reptiles.

The application will present scientific, educational, and ecological information about reptile species, organized through species pages, articles, taxonomic classifications, categories, habitats, geographic regions, and related topics.

The platform must provide an elegant, responsive, accessible, and trustworthy editorial experience.

Initially:

* only administrators and editors may create content;
* users may create accounts;
* regular users may not publish articles;
* there will be no comments;
* there will be no forums;
* there will be no community-generated content;
* there will be no public social interaction;
* gamification will only be implemented in future phases.

The system must be designed to evolve without introducing premature complexity.

---

## 2. Purpose of This File

This file defines the general rules for any work performed in this repository by Claude Code.

Before analyzing, changing, or creating code, Claude must:

1. read this file;
2. identify the current project phase;
3. identify the skills related to the task;
4. read the required skills;
5. inspect the current repository structure;
6. understand the existing contracts;
7. present a short implementation plan;
8. execute the implementation in verifiable increments;
9. run validations;
10. update the required documentation.

No task may be considered complete without technical validation.

---

## 3. Project Principles

Development must follow these principles:

* simplicity before abstraction;
* evolutionary architecture;
* modular monolith;
* low coupling;
* high cohesion;
* security by default;
* accessibility by default;
* documentation as part of the product;
* tests proportional to risk;
* automation of repetitive tasks;
* reproducible local environment;
* infrastructure as code;
* documented technical decisions;
* explicit contracts;
* observability from the beginning;
* no dependency on paid external services in the local environment.

Do not create structures for problems that do not yet exist.

Do not apply patterns only because they are considered conventional.

Do not transform the application into microservices.

---

## 4. Official Technology Stack

### 4.1 Backend

Use:

* Go;
* `net/http`;
* `chi`;
* PostgreSQL;
* `sqlc`;
* versioned migrations;
* OpenAPI;
* structured logs;
* environment-based configuration;
* unit tests;
* integration tests;
* health checks;
* graceful shutdown.

Additional libraries must be justified before adoption.

Avoid highly opinionated backend frameworks or frameworks that hide HTTP behavior.

### 4.2 Frontend

Use:

* React;
* TypeScript;
* Vite;
* React Router;
* TanStack Query;
* React Hook Form;
* Zod;
* Tailwind CSS;
* accessible components;
* Vitest;
* Testing Library;
* Playwright for critical flows.

The interface must explicitly handle:

* loading;
* errors;
* empty states;
* success states;
* missing permissions;
* resource not found states.

### 4.3 Database

Use:

* PostgreSQL;
* versioned migrations;
* `sqlc`;
* constraints;
* explicit indexes;
* parameterized queries;
* transactions when necessary.

Do not use automatic migrations in shared or production environments.

Do not use an ORM as the default data-access strategy.

### 4.4 Local Environment

Use:

* Docker;
* Docker Compose;
* PostgreSQL;
* Redis;
* LocalStack;
* Keycloak;
* Mailpit;
* backend running in a container;
* frontend running in a container.

The local environment must work without real AWS credentials.

### 4.5 Future Infrastructure

Infrastructure will be written with Terraform.

The future target platform will be AWS, using when appropriate:

* VPC;
* public and private subnets;
* ECS Fargate;
* ECR;
* Application Load Balancer;
* RDS PostgreSQL;
* ElastiCache;
* S3;
* CloudFront;
* Cognito;
* SES;
* SQS;
* CloudWatch;
* Secrets Manager;
* WAF;
* Route 53;
* ACM.

Do not implement all AWS infrastructure before the appropriate phase.

---

## 5. Architectural Strategy

The application must use a modular monolith architecture.

Planned modules:

* `taxonomy`;
* `species`;
* `articles`;
* `media`;
* `users`;
* `authentication`;
* `administration`;
* `gamification`;
* `search`;
* `platform`.

Each module may contain:

```text
domain/
application/
infrastructure/
transport/
```

This structure must not be created mechanically in every module.

Only create directories that have a real responsibility.

### 5.1 Layers

#### Domain

Responsible for:

* entities;
* value objects;
* invariants;
* business rules;
* policies;
* domain errors.

The domain must not depend on:

* HTTP;
* PostgreSQL;
* Redis;
* AWS;
* Keycloak;
* Cognito;
* infrastructure-specific libraries.

#### Application

Responsible for:

* use cases;
* orchestration;
* transactions;
* commands;
* queries;
* application authorization;
* coordination between modules.

The application layer must not contain HTTP details.

#### Infrastructure

Responsible for:

* persistence;
* integrations;
* adapters;
* storage;
* messaging;
* external providers;
* technical implementations.

#### Transport

Responsible for:

* HTTP handlers;
* parsing;
* input validation;
* serialization;
* HTTP status codes;
* headers;
* transport-specific middleware.

Handlers must not contain business rules.

---

## 6. Expected Repository Structure

```text
.
├── CLAUDE.md
├── README.md
├── Makefile
├── compose.yaml
├── compose.override.yaml
├── .env.example
├── .editorconfig
├── .gitignore
├── .github/
│   └── workflows/
├── .claude/
│   ├── settings.json
│   ├── commands/
│   └── skills/
├── apps/
│   ├── api/
│   └── web/
├── infrastructure/
│   ├── terraform/
│   └── localstack/
├── docs/
│   ├── architecture/
│   ├── adr/
│   ├── product/
│   ├── api/
│   ├── development/
│   └── runbooks/
├── scripts/
└── test/
```

Do not move files or change this structure without explaining the impact.

---

## 7. Platform Domain

### 7.1 Species

A species may contain:

* identifier;
* slug;
* common name;
* alternative common names;
* scientific name;
* genus;
* family;
* order;
* suborder;
* editorial group;
* summary;
* description;
* geographic distribution;
* habitat;
* diet;
* behavior;
* reproduction;
* size;
* weight;
* life expectancy;
* physical characteristics;
* ecological importance;
* ecosystem contribution;
* risks to humans;
* risk level;
* conservation status;
* threats;
* curiosities;
* references;
* main image;
* gallery;
* tags;
* editorial status;
* publication date;
* author;
* timestamps.

Not every field will be mandatory.

Do not create an excessively wide table without prior modeling.

### 7.2 Taxonomy

The taxonomy must support:

* class;
* order;
* suborder;
* family;
* genus;
* species.

The application may also contain non-scientific editorial groupings such as:

* snakes;
* lizards;
* turtles and tortoises;
* crocodilians;
* tuataras.

Do not mix scientific classifications with editorial categories without explicitly distinguishing them.

### 7.3 Articles

Articles must be independent from species pages.

An article may be associated with one or more species.

Planned fields:

* identifier;
* title;
* slug;
* subtitle;
* summary;
* cover image;
* content;
* author;
* editorial status;
* tags;
* related species;
* references;
* estimated reading time;
* SEO metadata;
* publication date;
* scheduled publication date;
* revisions;
* timestamps.

Editorial states:

* `draft`;
* `in_review`;
* `scheduled`;
* `published`;
* `archived`.

### 7.4 Structured Content

Article content must be stored in a structured format.

Planned block types:

* paragraph;
* heading;
* list;
* image;
* gallery;
* quote;
* curiosity;
* alert;
* table;
* scientific classification;
* reference;
* related species;
* map;
* embedded video.

The first version may support only a subset of these blocks.

Do not store unsanitized user-provided HTML.

### 7.5 Users

Initial roles:

* `visitor`;
* `member`;
* `editor`;
* `administrator`.

Initial permissions:

* `species:read`;
* `species:create`;
* `species:update`;
* `species:publish`;
* `articles:read`;
* `articles:create`;
* `articles:update`;
* `articles:publish`;
* `media:upload`;
* `users:manage`.

Authorization must be validated on the backend.

### 7.6 Gamification

Do not implement complete gamification before the appropriate phase.

The foundation may register events such as:

* `user_registered`;
* `user_logged_in`;
* `article_viewed`;
* `article_started`;
* `article_completed`;
* `species_viewed`;
* `search_performed`.

Do not implement points, rankings, or competition without formalized business rules.

---

## 8. API

The API must be versioned:

```text
/api/v1
```

Planned public routes:

```text
GET /api/v1/species
GET /api/v1/species/{slug}
GET /api/v1/articles
GET /api/v1/articles/{slug}
GET /api/v1/taxonomies
GET /api/v1/tags
GET /api/v1/search
GET /health
GET /ready
```

Planned authenticated routes:

```text
GET /api/v1/me
PATCH /api/v1/me
POST /api/v1/activity-events
```

Planned administrative routes:

```text
POST /api/v1/admin/species
PATCH /api/v1/admin/species/{id}
POST /api/v1/admin/species/{id}/publish

POST /api/v1/admin/articles
PATCH /api/v1/admin/articles/{id}
POST /api/v1/admin/articles/{id}/publish

POST /api/v1/admin/media
GET /api/v1/admin/users
PATCH /api/v1/admin/users/{id}/roles
```

These routes are directional and may evolve through ADRs.

### 8.1 API Conventions

The API must use:

* JSON;
* pagination;
* filters;
* sorting;
* validation;
* correct HTTP status codes;
* correlation IDs;
* OpenAPI;
* standardized errors.

Recommended error format:

```json
{
  "type": "validation_error",
  "title": "Invalid request",
  "status": 422,
  "detail": "One or more fields are invalid.",
  "correlationId": "uuid",
  "errors": [
    {
      "field": "scientificName",
      "message": "Scientific name is required."
    }
  ]
}
```

Do not return stack traces to clients.

Do not expose internal database or infrastructure messages.

---

## 9. Authentication and Authorization

Use Keycloak in the local environment.

On AWS, the planned identity provider will be Cognito.

The application must have an identity abstraction containing:

* external identifier;
* email;
* name;
* roles;
* permissions;
* account status.

Domain code must not depend directly on Keycloak or Cognito.

Tokens must be validated by the backend.

Do not store user passwords in the application database when authentication is delegated to an identity provider.

Do not trust roles sent by the frontend.

---

## 10. Images and Media

Use S3 emulated through LocalStack in the local environment.

Use real S3 and, when appropriate, CloudFront on AWS.

Every media asset must contain metadata:

* filename;
* MIME type;
* size;
* width;
* height;
* alternative text;
* caption;
* credit;
* source;
* license;
* storage key;
* upload author;
* timestamps.

Do not treat an image as only a URL.

Uploads must include:

* size limits;
* type validation;
* extension validation;
* safe filenames;
* unique storage keys;
* authorization;
* failure handling.

---

## 11. Search

The first version must use PostgreSQL Full Text Search.

Do not add Elasticsearch or OpenSearch in this phase.

Search may consider:

* common name;
* scientific name;
* alternative names;
* summary;
* description;
* tags;
* article title;
* article summary.

Planned filters:

* type;
* order;
* family;
* habitat;
* region;
* diet;
* conservation status;
* risk to humans.

---

## 12. UX and Visual Identity

The platform must communicate:

* nature;
* science;
* conservation;
* discovery;
* credibility;
* editorial elegance.

Avoid:

* childish visuals;
* generic template appearance;
* excessive use of green;
* indiscriminate use of cards;
* dense pages;
* unnecessary animations;
* decorative elements without purpose;
* poor text readability.

The interface must provide:

* editorial typography for headings;
* readable body typography;
* clear visual hierarchy;
* consistent spacing;
* high-quality imagery;
* clear navigation;
* responsive behavior;
* accessibility;
* visible focus states;
* keyboard support;
* semantic HTML;
* adequate contrast.

### 12.1 Home Page

The home page must plan for:

1. editorial hero;
2. primary search;
3. featured species;
4. popular categories;
5. recent articles;
6. ecological importance content;
7. registration call to action;
8. informational footer.

### 12.2 Article Page

It must plan for:

* title;
* subtitle;
* cover image;
* author;
* publication date;
* reading time;
* table of contents;
* content;
* references;
* related species;
* related articles.

### 12.3 Species Page

It must plan for:

* common name;
* scientific name;
* main image;
* summary;
* scientific classification;
* distribution;
* habitat;
* diet;
* behavior;
* reproduction;
* ecological importance;
* risks;
* conservation;
* curiosities;
* gallery;
* references;
* related articles.

---

## 13. Security

Apply security from the beginning.

Minimum requirements:

* input validation;
* backend authorization;
* restrictive CORS;
* security headers;
* rate limiting on critical endpoints;
* parameterized queries;
* protection against mass assignment;
* secure upload handling;
* secrets outside the repository;
* dependency scanning;
* logs without sensitive data;
* safe error messages;
* content sanitization;
* payload limits.

Never log:

* passwords;
* complete tokens;
* cookies;
* recovery codes;
* secrets;
* credentials;
* unnecessary sensitive content.

Do not create real keys, tokens, or passwords in versioned examples.

---

## 14. Observability

The backend must use structured logging.

Recommended fields:

* timestamp;
* level;
* service;
* environment;
* correlation ID;
* method;
* route;
* status;
* duration;
* error code.

The application must provide:

```text
GET /health
GET /ready
```

`/health` verifies whether the process is alive.

`/ready` verifies whether the application is ready to receive traffic and whether essential dependencies are available.

Prepare the architecture for:

* OpenTelemetry;
* metrics;
* traces;
* CloudWatch.

Do not add a complex observability stack during the initial phase.

---

## 15. Testing and Quality

Every change must include tests proportional to its risk.

### 15.1 Backend

Run:

```bash
go test ./...
go test -race ./...
go vet ./...
golangci-lint run
```

Expected tests:

* domain;
* use cases;
* handlers;
* repositories;
* migrations;
* critical integrations.

### 15.2 Frontend

Run:

```bash
npm run typecheck
npm run lint
npm run test
npm run build
```

Use:

* Vitest;
* Testing Library;
* Playwright for critical flows.

### 15.3 Infrastructure

Run:

```bash
terraform fmt -check -recursive
terraform validate
tflint
```

When configured, also run:

```bash
trivy
checkov
```

### 15.4 General Rules

Do not create tests that only validate internal implementation details without behavioral value.

Do not use mocks when a simple in-memory implementation would be sufficient.

Do not ignore failing tests.

Do not remove tests to make the pipeline pass.

---

## 16. Database and Migrations

Every schema change must include a migration.

Migrations must be:

* small;
* ordered;
* reversible when safe;
* tested;
* compatible with the current application stage.

Do not edit a migration that has already been applied in a shared environment.

Create a new migration for corrections.

Every table must evaluate:

* primary key;
* timestamps;
* constraints;
* indexes;
* uniqueness;
* referential integrity;
* deletion strategy;
* auditing.

Do not automatically add soft delete to every table.

---

## 17. Docker and Local Environment

The local environment must be reproducible.

Expected commands:

```bash
cp .env.example .env
make bootstrap
make up
make migrate
make seed
make validate
make test
```

Planned services:

```text
Frontend:   http://localhost:3000
Backend:    http://localhost:8080
Health:     http://localhost:8080/health
Keycloak:   http://localhost:8081
Mailpit:    http://localhost:8025
LocalStack: http://localhost:4566
```

The project must provide:

```bash
make up
make down
make restart
make logs
make migrate
make migrate-down
make seed
make test
make lint
make validate
make reset
```

The `make reset` command must be safe and clearly state that local data will be removed.

---

## 18. Terraform

Expected structure:

```text
infrastructure/terraform/
├── modules/
│   ├── networking/
│   ├── database/
│   ├── compute/
│   ├── storage/
│   ├── authentication/
│   ├── messaging/
│   ├── observability/
│   └── security/
└── environments/
    ├── local/
    ├── development/
    ├── staging/
    └── production/
```

The `local` environment may use LocalStack endpoints.

Local PostgreSQL will run through Docker Compose.

Do not attempt to emulate RDS locally.

Do not create real AWS resources without explicit instructions.

Do not run `terraform apply` against a real AWS account without explicit authorization.

Never assume an AWS profile is correct.

---

## 19. Documentation

Every relevant change must evaluate whether the following need updates:

* README;
* OpenAPI;
* ADR;
* C4 diagrams;
* development documentation;
* runbooks;
* roadmap;
* domain model;
* changelog.

Expected initial ADRs:

1. modular monolith;
2. PostgreSQL;
3. React and Vite;
4. Keycloak locally and Cognito in the future;
5. S3 for media storage;
6. structured block-based content;
7. PostgreSQL Full Text Search;
8. Terraform environments.

Do not document architectural decisions only in code comments.

---

## 20. Skills

Skills will be stored under:

```text
.claude/skills/
```

Planned skills:

```text
project-orchestrator
product-domain
go-backend
react-frontend
database
authentication
content-editor
local-development
terraform-aws
testing-quality
security
observability
ux-design-system
documentation
```

Before executing a task, identify which skills are required.

Example:

An article creation feature may require:

* `project-orchestrator`;
* `product-domain`;
* `go-backend`;
* `react-frontend`;
* `database`;
* `content-editor`;
* `testing-quality`;
* `security`;
* `documentation`.

Do not load skills unrelated to the task.

---

## 21. Mandatory Implementation Process

For every relevant task, follow this sequence.

### 21.1 Understanding

1. read this file;
2. read the required skills;
3. identify the current phase;
4. inspect the code and documentation;
5. understand the contracts;
6. identify dependencies;
7. identify risks.

### 21.2 Planning

Before implementation, present:

* objective;
* scope;
* files or modules involved;
* risks;
* required tests;
* completion criteria.

The plan must be short and executable.

### 21.3 Implementation

During implementation:

* make small changes;
* preserve contracts;
* avoid unnecessary rewrites;
* run tests progressively;
* keep the project compilable;
* update relevant documentation.

### 21.4 Validation

Before completion:

* compile the backend;
* compile the frontend;
* run tests;
* run lint;
* validate migrations;
* validate Terraform when changed;
* verify Docker Compose;
* verify acceptance criteria.

### 21.5 Final Report

Present:

* summary;
* changed files;
* decisions;
* tests executed;
* limitations;
* remaining risks;
* next steps.

---

## 22. Definition of Done

A task is complete only when:

* the code compiles;
* related tests pass;
* lint passes;
* contracts are consistent;
* required documentation is updated;
* acceptance criteria are met;
* no secrets are committed;
* no known error is ignored;
* the behavior can be reproduced locally.

Do not declare completion using phrases such as:

* “it should work”;
* “it probably works”;
* “I did not run it, but it is correct”;
* “tests can be added later”.

If a validation cannot be executed, explicitly state:

* which validation was not executed;
* why it was not executed;
* what risk remains;
* which command must be executed.

---

## 23. Prohibited Practices

Do not perform the following practices:

* create microservices;
* create speculative abstractions;
* create interfaces without a real consumer;
* add dependencies without justification;
* ignore errors;
* use `panic` for expected errors;
* place business rules inside handlers;
* place business rules inside React components;
* trust frontend authorization;
* return internal errors to clients;
* commit secrets;
* add real credentials;
* edit already-applied migrations;
* disable tests;
* remove tests to make the pipeline pass;
* use `any` indiscriminately in TypeScript;
* use global state without need;
* use Redis as the primary database;
* use LocalStack to simulate PostgreSQL;
* create real AWS resources without authorization;
* publish unsanitized content;
* copy code without understanding its impact;
* replace entire files unnecessarily;
* silently change public contracts;
* automatically advance to another project phase.

---

## 24. Contract Change Rules

Any API change must consider:

* OpenAPI;
* backend;
* frontend;
* tests;
* documentation;
* compatibility;
* versioning.

Any database change must consider:

* migration;
* query;
* `sqlc`;
* seed;
* tests;
* rollback;
* indexes.

Any authentication change must consider:

* Keycloak;
* claims;
* middleware;
* RBAC;
* frontend;
* tests;
* documentation.

Any infrastructure change must consider:

* Docker;
* LocalStack;
* Terraform;
* variables;
* documentation;
* security.

---

## 25. Phased Development

The project must evolve through phases.

### Phase 0 — Foundation

Includes:

* monorepo;
* documentation;
* skills;
* Docker Compose;
* minimal backend;
* minimal frontend;
* database;
* Redis;
* LocalStack;
* Keycloak;
* Mailpit;
* initial Terraform structure;
* CI;
* tests;
* lint;
* health check.

### Phase 1 — Public Catalog

Includes:

* species listing;
* species page;
* article listing;
* article page;
* taxonomy;
* search;
* filters;
* seed data;
* public layout.

### Phase 2 — Users and Authentication

Includes:

* registration;
* login;
* profile;
* email confirmation;
* account recovery;
* roles;
* permissions.

### Phase 3 — Administration

Includes:

* dashboard;
* species CRUD;
* article CRUD;
* media upload;
* editorial workflow;
* preview;
* publishing.

### Phase 4 — Advanced Editorial Experience

Includes:

* advanced content blocks;
* gallery;
* maps;
* tables;
* related content;
* advanced SEO;
* sharing.

### Phase 5 — Gamification

Includes:

* progress;
* events;
* achievements;
* collections;
* quizzes;
* levels.

### Phase 6 — AWS

Includes:

* real infrastructure;
* deployment;
* security;
* observability;
* backups;
* domain;
* CDN.

Do not advance to another phase without explicit instruction.

---

## 26. Expected Initial State

When starting from an empty repository, implement only Phase 0 first.

Phase 0 must support:

```bash
cp .env.example .env
make bootstrap
make up
make migrate
make seed
make validate
make test
```

The application must expose:

```text
Frontend: http://localhost:3000
Backend: http://localhost:8080
Health: http://localhost:8080/health
Keycloak: http://localhost:8081
Mailpit: http://localhost:8025
LocalStack: http://localhost:4566
```

Do not implement the complete catalog during the foundation phase.

---

## 27. Instructions for Claude Code

When receiving a task:

1. do not start changing files immediately;
2. identify the project phase;
3. identify the required skills;
4. inspect the repository;
5. present a plan;
6. execute the smallest complete change possible;
7. validate;
8. document;
9. report the results.

When technical ambiguity exists, choose the solution that is:

* simpler;
* safer;
* easier to test;
* easier to run locally;
* better aligned with the current phase.

Do not ask for confirmation for small and reversible technical decisions.

Record important decisions through ADRs.

Always prioritize a functional and verifiable delivery.


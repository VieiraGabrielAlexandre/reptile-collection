---

name: go-backend
description: Defines backend engineering standards for the reptile knowledge platform. Use this skill for Go code, HTTP APIs, modular monolith structure, domain logic, use cases, repositories, middleware, configuration, error handling, concurrency, testing, and backend performance.
when_to_use: Use whenever a task creates, changes, reviews, debugs, or tests Go backend code, API contracts, application services, domain models, repositories, middleware, background workers, or backend configuration.
argument-hint: "[backend-task-or-feature]"
disable-model-invocation: false
user-invocable: true
model: inherit
effort: high
paths:

* "apps/api/**/*.go"
* "apps/api/go.mod"
* "apps/api/go.sum"
* "apps/api/openapi/**"
* "apps/api/queries/**"
* "apps/api/migrations/**"
* "test/integration/**"

---

# Go Backend

## Objective

Define and enforce backend engineering standards for the reptile knowledge platform.

Use this skill to guide implementation of:

* Go packages;
* modular monolith boundaries;
* HTTP APIs;
* domain logic;
* use cases;
* repositories;
* middleware;
* configuration;
* structured logging;
* error handling;
* database access;
* background workers;
* integration points;
* testing;
* backend performance.

The current task is:

```text
$ARGUMENTS
```

If no arguments were provided, infer the task from the current conversation.

---

## Mandatory Context

Before changing backend code:

1. Read `${CLAUDE_PROJECT_DIR}/CLAUDE.md`.
2. Read the relevant domain skill.
3. Inspect the current package structure.
4. Inspect existing handlers, services, repositories, and tests.
5. Inspect OpenAPI when an endpoint is involved.
6. Inspect migrations and SQL queries when persistence is involved.
7. Identify the current project phase.
8. Identify affected contracts.
9. Preserve existing conventions unless there is a documented reason to change them.

Do not assume the backend is empty.

Do not introduce a new architectural pattern before verifying what already exists.

---

## Official Backend Stack

Use:

* Go;
* `net/http`;
* `chi`;
* PostgreSQL;
* `sqlc`;
* versioned migrations;
* OpenAPI;
* structured logging;
* environment-based configuration;
* unit tests;
* integration tests;
* graceful shutdown;
* health and readiness endpoints.

Avoid adding frameworks that obscure HTTP behavior.

Do not introduce an ORM unless explicitly approved through an architectural decision.

---

## Architectural Style

Use a modular monolith.

Expected high-level structure:

```text
apps/api/
├── cmd/
│   ├── api/
│   │   └── main.go
│   └── worker/
│       └── main.go
├── internal/
│   ├── platform/
│   ├── taxonomy/
│   ├── species/
│   ├── articles/
│   ├── media/
│   ├── users/
│   ├── authentication/
│   ├── administration/
│   ├── gamification/
│   └── search/
├── migrations/
├── queries/
├── openapi/
└── tests/
```

Each module may contain:

```text
domain/
application/
infrastructure/
transport/
```

Only create layers and directories that have a real responsibility.

Do not create empty packages for architectural appearance.

---

## Package Design

Packages should be:

* cohesive;
* narrowly focused;
* explicit about ownership;
* free from circular dependencies;
* named after domain responsibilities;
* independent from unrelated modules.

Prefer:

```text
species/domain
species/application
species/infrastructure
species/transport/http
```

Avoid vague package names such as:

```text
utils
helpers
common
shared
misc
services
managers
```

A small `platform` package may contain technical cross-cutting concerns such as:

* configuration;
* logging;
* database connection;
* HTTP server setup;
* identity context;
* storage adapters;
* clock;
* ID generation.

Do not move business concepts into `platform`.

---

## Dependency Direction

The expected dependency direction is:

```text
transport -> application -> domain
infrastructure -> domain or application ports
```

The domain must not depend on:

* HTTP;
* database drivers;
* Redis;
* AWS SDKs;
* Keycloak;
* Cognito;
* logging frameworks;
* configuration libraries.

Application code may depend on domain types and ports.

Infrastructure implements ports defined by the application or domain boundary.

Transport converts external requests into application inputs.

Do not allow handlers to call SQL directly.

Do not allow React-oriented response shapes to leak into domain entities.

---

## Domain Layer

The domain layer may contain:

* entities;
* value objects;
* invariants;
* domain services;
* policies;
* domain errors;
* state transitions.

Domain methods should enforce meaningful business rules.

Example:

```go
type Article struct {
	id        ArticleID
	status    EditorialStatus
	title     string
	content   []ContentBlock
	published *time.Time
}

func (a *Article) Publish(now time.Time) error {
	if a.status != StatusInReview && a.status != StatusScheduled {
		return ErrInvalidEditorialTransition
	}

	if strings.TrimSpace(a.title) == "" {
		return ErrArticleTitleRequired
	}

	if len(a.content) == 0 {
		return ErrArticleContentRequired
	}

	a.status = StatusPublished
	a.published = &now

	return nil
}
```

Do not create an entity that exposes all fields publicly without reason.

Prefer constructors when initialization rules exist.

Avoid constructors that merely assign fields without validation.

---

## Application Layer

The application layer coordinates use cases.

Examples:

* create species;
* update species;
* publish article;
* search content;
* upload media;
* assign user role.

Application services may:

* authorize;
* load entities;
* call domain methods;
* coordinate repositories;
* define transaction boundaries;
* emit events;
* map expected errors.

Example structure:

```go
type PublishArticleCommand struct {
	ArticleID string
	Actor     Identity
}

type PublishArticleHandler struct {
	articles ArticleRepository
	clock    Clock
}

func (h PublishArticleHandler) Handle(
	ctx context.Context,
	cmd PublishArticleCommand,
) error {
	if !cmd.Actor.HasPermission("articles:publish") {
		return ErrForbidden
	}

	article, err := h.articles.FindByID(ctx, cmd.ArticleID)
	if err != nil {
		return err
	}

	if err := article.Publish(h.clock.Now()); err != nil {
		return err
	}

	return h.articles.Update(ctx, article)
}
```

Application services must not parse HTTP requests.

Do not return HTTP status codes from use cases.

---

## Interfaces

Create interfaces only at real boundaries.

Appropriate examples:

```go
type ArticleRepository interface {
	FindByID(ctx context.Context, id ArticleID) (*Article, error)
	Update(ctx context.Context, article *Article) error
}
```

```go
type ObjectStorage interface {
	Put(ctx context.Context, input PutObjectInput) (StoredObject, error)
	Delete(ctx context.Context, key string) error
}
```

```go
type Clock interface {
	Now() time.Time
}
```

Do not create interfaces:

* for every struct;
* only to make mocking possible;
* without at least one real consumer;
* inside infrastructure packages when the consumer owns the contract elsewhere.

Prefer defining an interface close to the code that consumes it.

Use concrete types when substitution is unnecessary.

---

## HTTP Transport

Use `net/http` and `chi`.

Handlers are responsible for:

* route parameters;
* query parameters;
* request decoding;
* transport validation;
* authentication context extraction;
* calling application services;
* response serialization;
* HTTP status codes;
* response headers.

Handlers are not responsible for:

* business rules;
* transaction orchestration;
* direct SQL;
* authorization rules duplicated from the application layer;
* domain state transitions.

Example:

```go
type ArticleHandler struct {
	publishArticle PublishArticleUseCase
}

func (h ArticleHandler) Publish(w http.ResponseWriter, r *http.Request) {
	articleID := chi.URLParam(r, "id")
	identity, ok := IdentityFromContext(r.Context())
	if !ok {
		WriteProblem(w, r, ErrUnauthenticated)
		return
	}

	err := h.publishArticle.Handle(
		r.Context(),
		PublishArticleCommand{
			ArticleID: articleID,
			Actor:     identity,
		},
	)
	if err != nil {
		WriteProblem(w, r, err)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}
```

Keep handlers short and readable.

---

## Request Decoding

Use strict JSON decoding.

Requirements:

* limit request body size;
* reject malformed JSON;
* reject unknown fields for administrative write endpoints when appropriate;
* reject multiple JSON documents;
* validate required primitive fields;
* close request bodies through normal server behavior;
* return standardized errors.

Example:

```go
func DecodeJSON[T any](w http.ResponseWriter, r *http.Request, dst *T) error {
	r.Body = http.MaxBytesReader(w, r.Body, 1<<20)

	decoder := json.NewDecoder(r.Body)
	decoder.DisallowUnknownFields()

	if err := decoder.Decode(dst); err != nil {
		return NewValidationError("invalid_json", err)
	}

	if decoder.More() {
		return NewValidationError("multiple_json_documents", nil)
	}

	return nil
}
```

The implementation may differ, but behavior must remain safe and predictable.

---

## Response Design

Use explicit response DTOs.

Do not serialize domain entities directly when that exposes internal fields or couples contracts to storage.

Example:

```go
type SpeciesResponse struct {
	ID             string             `json:"id"`
	Slug           string             `json:"slug"`
	CommonName     string             `json:"commonName"`
	ScientificName string             `json:"scientificName"`
	Summary        string             `json:"summary"`
	Taxonomy       TaxonomyResponse   `json:"taxonomy"`
	PrimaryImage   *MediaResponse     `json:"primaryImage,omitempty"`
	PublishedAt    *time.Time         `json:"publishedAt,omitempty"`
}
```

Use consistent JSON naming.

Prefer camelCase in JSON payloads.

Use `omitempty` only when absence has clear semantic meaning.

Do not silently omit validation errors.

---

## Error Handling

Errors must be explicit and mapped consistently.

Recommended categories:

* validation;
* unauthenticated;
* forbidden;
* not found;
* conflict;
* rate limited;
* dependency unavailable;
* internal.

Use sentinel errors, typed errors, or wrapped errors where appropriate.

Example:

```go
var ErrSpeciesNotFound = errors.New("species not found")
```

Or:

```go
type ValidationError struct {
	Code   string
	Field  string
	Reason string
}
```

Preserve error chains:

```go
return fmt.Errorf("load article %s: %w", id, err)
```

Do not compare errors by message text.

Do not expose internal error messages to clients.

Do not log the same error repeatedly at every layer.

Prefer logging once at the boundary with sufficient context.

---

## Standard Problem Response

Use a consistent error format.

Example:

```go
type Problem struct {
	Type          string         `json:"type"`
	Title         string         `json:"title"`
	Status        int            `json:"status"`
	Detail        string         `json:"detail"`
	CorrelationID string         `json:"correlationId,omitempty"`
	Errors        []ProblemField `json:"errors,omitempty"`
}
```

Example response:

```json
{
  "type": "validation_error",
  "title": "Invalid request",
  "status": 422,
  "detail": "One or more fields are invalid.",
  "correlationId": "1f0f0f28-acde-4bfa-a93f-fbf7e02d44a3",
  "errors": [
    {
      "field": "scientificName",
      "message": "Scientific name is required."
    }
  ]
}
```

OpenAPI must describe the response.

---

## HTTP Status Codes

Use status codes consistently.

Recommended mapping:

```text
200 OK
201 Created
202 Accepted
204 No Content
400 Bad Request
401 Unauthorized
403 Forbidden
404 Not Found
409 Conflict
415 Unsupported Media Type
422 Unprocessable Entity
429 Too Many Requests
500 Internal Server Error
503 Service Unavailable
```

Use:

* `400` for malformed transport-level requests;
* `422` for well-formed requests that violate validation rules;
* `409` for uniqueness or state conflicts;
* `404` when the resource does not exist or should not be disclosed.

Do not return `200` for every outcome.

---

## Routing

Organize routes by module.

Example:

```go
func MountArticleRoutes(
	router chi.Router,
	handler ArticleHandler,
	auth Middleware,
) {
	router.Route("/api/v1/articles", func(r chi.Router) {
		r.Get("/", handler.List)
		r.Get("/{slug}", handler.GetBySlug)
	})

	router.Route("/api/v1/admin/articles", func(r chi.Router) {
		r.Use(auth.RequireAuthentication)
		r.Post("/", handler.Create)
		r.Patch("/{id}", handler.Update)
		r.Post("/{id}/publish", handler.Publish)
	})
}
```

Do not register every route in `main.go`.

Keep route ownership close to the module.

---

## Middleware

Possible middleware:

* request ID or correlation ID;
* structured request logging;
* panic recovery;
* security headers;
* CORS;
* authentication;
* rate limiting;
* body size limits;
* metrics.

Middleware should be:

* small;
* composable;
* ordered deliberately;
* free from domain logic.

Recommended high-level order:

```text
recovery
correlation ID
security headers
CORS
request logging
authentication
rate limiting
router
```

Exact order depends on implementation.

Do not place authorization rules entirely in middleware when the use case owns the decision.

---

## Authentication Context

Transport middleware may validate the token and place an internal identity in the request context.

Example:

```go
type Identity struct {
	Subject     string
	Email       string
	Roles       []string
	Permissions map[string]struct{}
}
```

Use unexported context key types.

Example:

```go
type contextKey string

const identityContextKey contextKey = "identity"
```

Do not store raw tokens in the context unless strictly required.

Do not trust frontend-provided identity headers.

---

## Context Usage

Every request-bound operation must accept `context.Context`.

Use context for:

* cancellation;
* deadlines;
* request-scoped values;
* database operations;
* external calls.

Do not store context inside structs.

Pass context as the first argument.

Correct:

```go
func (r Repository) FindByID(ctx context.Context, id string) (*Species, error)
```

Avoid:

```go
type Repository struct {
	ctx context.Context
}
```

Do not use `context.Background()` inside request flows to bypass cancellation.

Background workers may create their own root context with controlled lifecycle.

---

## Configuration

Configuration must come from environment variables or explicit config files for local tooling.

Create a typed configuration structure.

Example:

```go
type Config struct {
	Environment string
	HTTP        HTTPConfig
	Database    DatabaseConfig
	Redis       RedisConfig
	Auth        AuthConfig
	Storage     StorageConfig
}
```

Validate configuration at startup.

Fail fast when required values are missing.

Do not read environment variables throughout the codebase.

Centralize loading.

Do not provide unsafe production defaults.

Local defaults may exist only when clearly documented.

---

## Secrets

Do not hardcode:

* database passwords;
* signing keys;
* client secrets;
* AWS secrets;
* Keycloak secrets.

`.env.example` may contain placeholders.

Example:

```text
DATABASE_PASSWORD=local-development-password
```

Use clearly local-only values when required by Docker Compose.

Never log secret values.

---

## Logging

Use structured logging.

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
* error code;
* resource ID when safe.

Example:

```go
logger.InfoContext(
	ctx,
	"article published",
	"article_id", articleID,
	"actor_id", identity.Subject,
)
```

Do not build machine-readable logs through string concatenation.

Avoid logging:

* raw tokens;
* passwords;
* complete request bodies;
* cookies;
* sensitive user data;
* internal stack traces in normal informational logs.

Do not log expected validation failures as server errors.

---

## Database Access

Use PostgreSQL with `sqlc`.

Repositories should translate between:

* generated SQL types;
* domain types;
* application errors.

Do not expose generated `sqlc` models beyond infrastructure unless explicitly useful.

Example:

```go
func (r SpeciesRepository) FindBySlug(
	ctx context.Context,
	slug species.Slug,
) (*species.Species, error) {
	row, err := r.queries.FindSpeciesBySlug(ctx, slug.String())
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, species.ErrNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("find species by slug: %w", err)
	}

	return mapSpeciesRow(row)
}
```

Do not place SQL in handlers.

Do not use string concatenation for queries.

---

## Transactions

Use transactions when a use case requires atomicity.

Examples:

* create article and initial revision;
* publish article and persist audit event;
* assign role and update user state;
* store media metadata after successful object upload.

Transaction boundaries belong to application orchestration or a dedicated transaction abstraction.

Avoid opening transactions inside low-level repository methods when multiple repositories must participate.

Do not keep transactions open during slow external network calls.

---

## Generated Code

Generated code must be reproducible.

Potential generated assets:

* `sqlc` output;
* OpenAPI clients or models;
* mocks when justified.

Do not manually edit generated files.

Generated files should contain standard generated-code markers when supported.

Document generation commands in the Makefile.

Example:

```bash
make generate
```

The repository must remain buildable after generation.

---

## IDs

Prefer UUIDs or another explicitly documented identifier strategy.

Use typed IDs in domain code when they improve safety.

Example:

```go
type SpeciesID string
```

Do not overcomplicate IDs with generic abstractions.

Public IDs must not expose database sequencing when that creates avoidable coupling or enumeration concerns.

---

## Time

Inject time when business logic depends on it.

Example:

```go
type Clock interface {
	Now() time.Time
}
```

Use UTC for storage and backend processing.

Convert to local display time in the presentation layer when required.

Do not call `time.Now()` throughout domain logic when deterministic tests are needed.

Do not store timestamps without timezone semantics.

---

## Slugs

Slug generation should be deterministic and validated.

Requirements:

* lowercase;
* URL-safe;
* stable;
* unique within the resource type.

Do not silently regenerate a published slug when a title changes.

Slug history or redirects may be introduced later.

The application must handle uniqueness conflicts explicitly.

---

## Pagination

Use bounded pagination.

Recommended query parameters:

```text
page
pageSize
sort
order
```

Or cursor pagination when required by scale or data consistency.

Initial catalog endpoints may use page-based pagination.

Rules:

* define a default page size;
* define a maximum page size;
* reject invalid values;
* return pagination metadata;
* apply deterministic ordering.

Example response:

```json
{
  "items": [],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 0,
    "totalPages": 0
  }
}
```

Do not allow unbounded result sets.

---

## Filtering and Sorting

Whitelist allowed fields.

Do not pass arbitrary client field names directly into SQL.

Example allowed sorting:

```text
commonName
scientificName
publishedAt
createdAt
```

Translate client values to trusted query implementations.

Reject unsupported filter or sort values clearly.

---

## Search

Initial search should use PostgreSQL Full Text Search.

Backend responsibilities:

* normalize user input;
* enforce query length limits;
* apply filters;
* rank results;
* distinguish resource types;
* avoid exposing unpublished content;
* return stable result shapes.

Do not introduce OpenSearch or Elasticsearch before a real need exists.

---

## Media Uploads

Backend upload handling must:

* authenticate the actor;
* authorize the permission;
* enforce file size limits;
* validate MIME type;
* validate extension;
* generate safe object keys;
* store metadata;
* support failure cleanup;
* preserve source and license metadata.

Do not trust the original filename.

Do not use the user-provided filename as the storage key.

Do not serve arbitrary uploaded files inline without reviewing content disposition and MIME behavior.

---

## Redis

Use Redis only for a concrete need.

Possible uses:

* rate limiting;
* short-lived cache;
* distributed locks when justified;
* idempotency;
* session-related technical data if required.

Do not use Redis as the source of truth for species, articles, or users.

Do not cache before measuring or identifying a real performance concern.

Every cache must have:

* key design;
* TTL;
* invalidation strategy;
* fallback behavior;
* observability.

---

## Background Workers

Create a worker only when asynchronous work has a real requirement.

Examples:

* scheduled publication;
* image metadata processing;
* email delivery;
* search indexing;
* activity-event processing.

Workers must support:

* graceful shutdown;
* retries;
* idempotency;
* dead-letter handling when using queues;
* structured logging;
* metrics when appropriate.

Do not create a generic worker framework during Phase 0 without a concrete job.

---

## Idempotency

Consider idempotency for:

* activity events;
* media callbacks;
* scheduled publication;
* queue consumers;
* retryable commands.

An idempotency strategy may use:

* idempotency keys;
* unique database constraints;
* processed-event records;
* deterministic commands.

Do not implement global idempotency middleware without a real requirement.

---

## Concurrency

Use concurrency only when it improves the current task.

Rules:

* respect context cancellation;
* avoid unbounded goroutines;
* use synchronization deliberately;
* propagate errors;
* close channels correctly;
* avoid concurrent writes to shared maps;
* prefer simple sequential code when performance is sufficient.

Do not create goroutines in HTTP handlers without lifecycle control.

Run the race detector when concurrency changes:

```bash
go test -race ./...
```

---

## Graceful Shutdown

The API process must handle termination signals.

Shutdown should:

1. stop accepting new requests;
2. allow active requests to finish within a timeout;
3. close database pools;
4. close Redis connections;
5. stop workers;
6. flush logs when required.

Do not call `os.Exit` from internal packages.

`main` owns process lifecycle and exit codes.

---

## Health Checks

Provide:

```text
GET /health
GET /ready
```

### Health

`/health` confirms the process is alive.

It should not depend on every external service.

Recommended response:

```json
{
  "status": "ok"
}
```

### Readiness

`/ready` verifies essential dependencies.

Possible checks:

* database connectivity;
* required startup configuration;
* essential storage connectivity when needed.

Readiness checks must have short timeouts.

Do not make readiness depend on optional services.

Do not expose secrets or internal topology.

---

## OpenAPI

OpenAPI is the API contract.

For every endpoint, define:

* path;
* method;
* operation ID;
* request parameters;
* request body;
* response schemas;
* error responses;
* authentication;
* examples when useful.

Update OpenAPI in the same change as the endpoint.

Do not allow implementation and specification to drift.

Use stable operation IDs.

Example:

```text
listSpecies
getSpeciesBySlug
createArticle
publishArticle
```

---

## Versioning

Use:

```text
/api/v1
```

Do not create `v2` for every breaking internal refactor.

A new API version is appropriate when a public contract requires incompatible change that cannot be safely migrated.

Internal package versions should not mirror API versions.

---

## Testing Strategy

Backend tests should be proportional to risk.

### Domain tests

Test:

* invariants;
* state transitions;
* value objects;
* business policies.

### Application tests

Test:

* use-case behavior;
* authorization;
* repository interaction;
* expected error mapping;
* transaction decisions.

### Handler tests

Test:

* request parsing;
* status codes;
* headers;
* response bodies;
* authentication behavior;
* malformed inputs.

Use `httptest`.

### Repository tests

Test against PostgreSQL for:

* SQL behavior;
* constraints;
* mapping;
* transaction behavior;
* query filtering;
* pagination.

Prefer integration tests over mocking SQL internals.

### End-to-end tests

Use for critical flows only.

Examples:

* public species retrieval;
* authenticated article publishing;
* media upload;
* registration and profile synchronization.

---

## Test Doubles

Prefer simple fakes or in-memory implementations.

Example:

```go
type InMemoryArticleRepository struct {
	articles map[article.ArticleID]*article.Article
}
```

Use mocks when interaction verification is genuinely important.

Do not generate mocks for every interface automatically.

Do not over-specify call order unless order is part of behavior.

---

## Table-Driven Tests

Use table-driven tests for validation-heavy behavior.

Example:

```go
func TestNewSlug(t *testing.T) {
	tests := []struct {
		name    string
		input   string
		wantErr bool
	}{
		{
			name:    "valid slug",
			input:   "green-sea-turtle",
			wantErr: false,
		},
		{
			name:    "contains spaces",
			input:   "green sea turtle",
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			_, err := NewSlug(tt.input)
			if tt.wantErr && err == nil {
				t.Fatal("expected error")
			}
			if !tt.wantErr && err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
		})
	}
}
```

Avoid excessively large table tests that become difficult to understand.

---

## Assertions

Prefer the standard library unless an assertion library is already adopted.

Use clear failure messages.

Do not hide meaningful test behavior behind large helper abstractions.

---

## Performance

Optimize based on evidence.

Check:

* N+1 queries;
* missing indexes;
* unbounded result sets;
* large JSON payloads;
* repeated serialization;
* unnecessary allocations;
* slow external calls;
* transaction duration.

Do not add caching or concurrency as speculative optimization.

Use benchmarks when performance-sensitive logic exists.

Example:

```bash
go test -bench=. ./...
```

---

## Security

Backend changes must evaluate:

* input validation;
* authentication;
* authorization;
* object-level access;
* mass assignment;
* error disclosure;
* injection;
* SSRF;
* unsafe redirects;
* upload risks;
* rate limiting;
* secrets;
* dependency vulnerabilities.

Do not bind request DTOs directly into persistence models.

Use explicit assignment for writable fields.

Do not accept administrative fields from public requests.

---

## Dependency Management

Before adding a dependency:

1. verify the standard library cannot reasonably solve the problem;
2. verify the project does not already include equivalent functionality;
3. verify maintenance activity;
4. verify license;
5. verify security history;
6. verify API stability;
7. justify the dependency.

Run:

```bash
go mod tidy
go mod verify
```

Do not add large framework dependencies for small utility needs.

---

## Code Style

Follow idiomatic Go.

Requirements:

* format with `gofmt`;
* keep functions focused;
* handle all errors;
* use early returns;
* use meaningful names;
* keep exported APIs minimal;
* document exported identifiers when required;
* avoid unnecessary nesting;
* avoid clever abstractions;
* avoid global mutable state.

Prefer:

```go
if err != nil {
	return fmt.Errorf("create article: %w", err)
}
```

Avoid ignoring errors:

```go
value, _ := operation()
```

unless the reason is explicit and safe.

---

## Nil Handling

Use pointers only when absence or mutability requires them.

Do not use pointers for every scalar field.

Distinguish:

* zero value;
* missing value;
* empty value.

For API patch semantics, consider explicit optional wrappers rather than ambiguous pointers when needed.

Do not panic on nil values caused by expected input.

---

## Generics

Use generics only when they clearly reduce duplication without hiding domain meaning.

Appropriate examples may include:

* generic pagination response;
* small reusable result helpers;
* typed collection utilities.

Do not create a generic repository abstraction.

Do not create generic CRUD services for domain-rich modules.

---

## Comments and Documentation

Comments should explain:

* why;
* non-obvious constraints;
* external compatibility;
* concurrency assumptions;
* security decisions.

Do not comment obvious code.

Use package documentation for important packages.

Update:

* OpenAPI;
* README;
* ADRs;
* runbooks;
* environment documentation

when backend behavior changes significantly.

---

## Expected Validation Commands

Run from `apps/api` when applicable:

```bash
gofmt -w .
go test ./...
go vet ./...
golangci-lint run
go build ./...
```

For concurrency-sensitive work:

```bash
go test -race ./...
```

For dependencies:

```bash
go mod tidy
go mod verify
```

For generated code:

```bash
make generate
```

For cross-cutting work, also run from the repository root:

```bash
make validate
make test
```

Only report commands that were actually executed.

---

## Implementation Workflow

When using this skill:

1. identify the backend module;
2. identify the use case;
3. inspect existing packages and contracts;
4. define the domain behavior;
5. define application orchestration;
6. define required ports;
7. define infrastructure changes;
8. define transport changes;
9. update OpenAPI;
10. add or update tests;
11. run validation;
12. update documentation.

Implement the smallest complete vertical slice possible.

---

## Expected Deliverables

Depending on the task, deliverables may include:

* domain types;
* application use cases;
* repository ports;
* PostgreSQL repository implementations;
* HTTP handlers;
* middleware;
* request and response DTOs;
* OpenAPI changes;
* migrations;
* SQL queries;
* tests;
* configuration;
* documentation.

Do not create unrelated modules.

---

## Definition of Done

A backend task is complete only when:

* behavior is implemented;
* module boundaries remain clear;
* business rules are not in handlers;
* public contracts are explicit;
* errors are mapped safely;
* input is validated;
* authorization is enforced;
* database access is parameterized;
* relevant tests pass;
* formatting passes;
* lint passes;
* build passes;
* OpenAPI is updated;
* documentation is updated;
* no secret is exposed;
* no validation result is falsely claimed.

---

## Prohibited Practices

Do not:

* use a generic CRUD architecture for all modules;
* create microservices;
* use handlers as service layers;
* place SQL in handlers;
* expose database models directly;
* ignore errors;
* compare errors by string;
* use `panic` for expected conditions;
* use global mutable state;
* create unbounded goroutines;
* store context in structs;
* use `context.Background()` to bypass request cancellation;
* create interfaces for every struct;
* use a generic repository abstraction;
* add an ORM by default;
* log secrets or raw tokens;
* return stack traces;
* trust frontend authorization;
* accept arbitrary sorting fields;
* allow unbounded pagination;
* cache without an invalidation strategy;
* manually edit generated code;
* declare completion without running relevant validation.

---

## Completion Report

After completing a backend task, report:

```markdown
## Backend scope

## Modules affected

## Domain behavior

## Application changes

## Transport and API changes

## Persistence changes

## Security considerations

## Tests

## Validation performed

## Documentation updates

## Limitations
```

Keep the report factual and based on actual work performed.

---

name: observability
description: Defines observability and operational diagnostics standards for the reptile knowledge platform. Use this skill for structured logging, correlation IDs, health checks, readiness checks, metrics, tracing, audit events, dashboards, alerts, operational diagnostics, and production troubleshooting.
when_to_use: Use whenever a task creates, changes, reviews, debugs, or tests logs, request tracing, health endpoints, readiness behavior, metrics, audit events, worker diagnostics, infrastructure monitoring, CloudWatch integration, or operational runbooks.
argument-hint: "[observability-or-diagnostics-task]"
disable-model-invocation: false
user-invocable: true
model: inherit
effort: high
paths:

* "apps/api/internal/platform/logging/**"
* "apps/api/internal/platform/observability/**"
* "apps/api/internal/platform/http/**"
* "apps/api/internal/**"
* "apps/api/cmd/**"
* "infrastructure/terraform/modules/observability/**"
* "infrastructure/terraform/modules/compute/**"
* "infrastructure/terraform/environments/**"
* "compose*.{yaml,yml}"
* ".github/workflows/**"
* "docs/runbooks/**"
* "docs/architecture/**"

---

# Observability

## Objective

Define and enforce observability and operational-diagnostics standards for the reptile knowledge platform.

Use this skill to guide:

* structured application logs;
* request correlation;
* health checks;
* readiness checks;
* metrics;
* distributed tracing;
* audit events;
* worker diagnostics;
* error visibility;
* CloudWatch integration;
* dashboards;
* alerts;
* runbooks;
* troubleshooting;
* service-level indicators;
* production operability.

The current task is:

```text
$ARGUMENTS
```

If no arguments were provided, infer the task from the current conversation.

---

## Mandatory Context

Before changing observability behavior:

1. Read `${CLAUDE_PROJECT_DIR}/CLAUDE.md`.
2. Read the `go-backend`, `security`, `local-development`, `terraform-aws`, `testing-quality`, and `documentation` skills when relevant.
3. Inspect the current logging setup.
4. Inspect health and readiness endpoints.
5. Inspect HTTP middleware.
6. Inspect background workers when affected.
7. Inspect Docker and infrastructure logging behavior.
8. Identify the current project phase.
9. Identify the operational question the change must answer.
10. Identify which signals are required.
11. Identify sensitive data that must not be logged.
12. Preserve existing field names and conventions unless a migration is justified.

Do not add telemetry merely because a tool supports it.

Do not introduce a large observability stack without a concrete operational need.

---

## Core Principles

Observability must be:

* structured;
* actionable;
* consistent;
* low-noise;
* privacy-aware;
* security-aware;
* environment-aware;
* useful during incidents;
* proportional to system complexity;
* based on actual operational questions;
* compatible with local development and future AWS deployment.

Every signal should help answer at least one question.

Examples:

* Is the service alive?
* Is it ready to receive traffic?
* Which request failed?
* Which dependency is unavailable?
* Which article failed to publish?
* How long did the request take?
* Which actor performed an administrative action?
* Is a queue accumulating messages?
* Is database latency increasing?

Do not generate telemetry that nobody can interpret or act on.

---

## Observability Signals

Use the three primary technical signals:

```text
logs
metrics
traces
```

Also use:

```text
audit events
health checks
readiness checks
```

when appropriate.

### Logs

Best for:

* detailed events;
* errors;
* lifecycle changes;
* business operations;
* diagnostics.

### Metrics

Best for:

* trends;
* rates;
* latency;
* saturation;
* counts;
* alerting.

### Traces

Best for:

* end-to-end request flow;
* distributed latency;
* external dependencies;
* parent-child operations.

### Audit Events

Best for:

* privileged actions;
* user-role changes;
* publishing;
* administrative accountability.

Do not use logs as a substitute for every metric.

Do not use audit events as debug logs.

---

## Phase-Based Observability

### Phase 0

Implement:

* structured backend logs;
* correlation IDs;
* request logs;
* startup and shutdown logs;
* `/health`;
* `/ready`;
* dependency failure diagnostics;
* local Docker health visibility;
* basic operational documentation.

Do not add Prometheus, Grafana, Loki, Jaeger, or a full OpenTelemetry collector unless explicitly required.

### Phase 1

Add visibility for:

* species listing;
* article listing;
* search latency;
* not-found rates;
* public API failures.

### Phase 2

Add visibility for:

* authentication failures;
* user synchronization;
* forbidden operations;
* account status problems.

### Phase 3

Add visibility for:

* article save;
* publication;
* media upload;
* workflow transitions;
* administrative audit events.

### Phase 4

Add visibility for:

* content rendering errors;
* unsupported blocks;
* media-processing failures;
* cache behavior.

### Phase 5

Add visibility for:

* activity-event processing;
* duplicate events;
* score processing;
* queue depth;
* achievement failures.

### Phase 6

Add:

* CloudWatch;
* alarms;
* dashboards;
* traces;
* SLO-oriented metrics;
* infrastructure health;
* deployment diagnostics.

Do not implement future-phase telemetry prematurely.

---

## Structured Logging

The backend must emit structured logs.

Preferred output format:

```text
JSON
```

Recommended fields:

```text
timestamp
level
message
service
environment
version
correlation_id
request_id
trace_id
span_id
method
route
path
status
duration_ms
actor_id
resource_type
resource_id
error_code
```

Not every event needs every field.

Use stable field names.

Do not change field names casually because dashboards and searches may depend on them.

---

## Logging Library

Prefer the Go standard structured logging package when sufficient.

Directional choice:

```go
log/slog
```

A third-party logging library requires justification.

The logging abstraction should remain minimal.

Do not create a large custom logging framework.

Do not wrap every log call behind generic helper functions that hide context.

---

## Logger Configuration

The logger should support:

* JSON output;
* log level;
* service name;
* environment;
* version;
* source information only when useful;
* redaction policy;
* contextual fields.

Example conceptual configuration:

```go
type LoggingConfig struct {
	Level       string
	Format      string
	ServiceName string
	Environment string
	Version     string
}
```

Validate unsupported log levels at startup.

Do not default production to debug logging.

---

## Log Levels

Use levels consistently.

### Debug

Use for:

* detailed development diagnostics;
* non-essential state;
* low-level dependency information.

Do not enable debug by default in production.

### Info

Use for:

* application startup;
* shutdown;
* successful important operations;
* workflow transitions;
* service readiness changes.

### Warn

Use for:

* recoverable problems;
* degraded optional dependency;
* invalid external behavior;
* retryable failures;
* unexpected but handled states.

### Error

Use for:

* failed requests due to server behavior;
* unavailable required dependency;
* worker failure;
* unhandled operational error.

Do not log expected validation errors as `error`.

Do not log every `404` as an error.

---

## Event Naming

Use concise, stable event messages.

Prefer:

```text
application started
article published
media upload failed
database readiness check failed
```

Avoid vague messages:

```text
something went wrong
error
operation failed
```

The message should explain what happened.

Structured fields should explain where and to what resource.

---

## Contextual Logging

Pass context through request and application flows.

Example:

```go
logger.InfoContext(
	ctx,
	"article published",
	"article_id", articleID,
	"actor_id", identity.Subject,
)
```

Correlation and trace fields may be injected through a context-aware handler.

Do not store loggers with request-specific state in global variables.

Do not pass dozens of ad hoc fields manually when middleware can provide stable request context.

---

## Correlation IDs

Every incoming request should have a correlation ID.

Behavior:

1. inspect a trusted incoming correlation header when allowed;
2. validate its format and length;
3. generate a new ID when missing or invalid;
4. store it in context;
5. include it in logs;
6. return it in the response.

Recommended response header:

```text
X-Correlation-ID
```

Use one stable header name across the project.

Do not trust unbounded arbitrary header content.

Do not use correlation IDs as authentication or authorization evidence.

---

## Correlation ID Format

Use a safe format such as:

* UUID;
* ULID;
* validated short opaque identifier.

Limit length.

Do not allow line breaks or control characters.

Do not treat a client-supplied value as trusted log content without validation.

---

## Request ID vs Correlation ID

A request ID identifies one HTTP request.

A correlation ID may link multiple operations.

For the initial monolith, one identifier may serve both purposes.

Do not create multiple IDs without an operational use case.

If both are introduced, document the distinction.

---

## Request Logging Middleware

Request logs should include:

```text
method
route
status
duration
correlation_id
remote context when safe
user agent only when needed
actor_id when authenticated
```

Prefer route templates:

```text
/api/v1/species/{slug}
```

over raw paths:

```text
/api/v1/species/boa-constrictor
```

for aggregation.

Do not log full query strings when they may contain sensitive data.

Do not log request bodies by default.

---

## Request Start vs Completion Logs

A completion log is usually sufficient for normal requests.

It contains:

* outcome;
* status;
* duration;
* route;
* correlation ID.

Request-start logs may be useful for:

* long operations;
* uploads;
* asynchronous handoff;
* debugging incomplete requests.

Do not log both start and completion for every request without evaluating noise.

---

## Response Status Classification

Suggested interpretation:

### Successful

```text
2xx
3xx
```

Usually log at `info` or no explicit log beyond request completion.

### Client errors

```text
4xx
```

Usually log at `info` or `warn` depending on abuse and context.

### Server errors

```text
5xx
```

Log at `error`.

Do not classify every client mistake as an application failure.

Authentication abuse may require dedicated security metrics rather than noisy error logs.

---

## Duration

Record duration in a machine-friendly numeric field.

Recommended:

```text
duration_ms
```

or:

```text
duration_seconds
```

Choose one convention and keep it stable.

Do not log only formatted strings such as:

```text
"1.23 seconds"
```

when metrics extraction may be required.

---

## Error Logging

Log errors at the boundary where they are handled.

Include:

* operation;
* safe error code;
* correlation ID;
* resource ID when safe;
* dependency;
* retry state when applicable.

Preserve wrapped error context internally.

Do not log the same error at every layer.

Repeated logging makes incidents noisy and obscures ownership.

---

## Error Codes

Use stable internal or application error codes.

Examples:

```text
article_not_found
article_invalid_transition
database_unavailable
media_upload_failed
authentication_invalid_token
authorization_forbidden
```

Do not use full error messages as metric dimensions.

Do not expose internal codes publicly unless they are part of the API contract.

---

## Sensitive Logging

Never log:

* passwords;
* raw access tokens;
* refresh tokens;
* authorization headers;
* cookies;
* client secrets;
* database passwords;
* private keys;
* recovery codes;
* full user profiles;
* complete article request bodies;
* uploaded file contents;
* sensitive Terraform state.

Email addresses and user identifiers should be logged only when operationally necessary.

Prefer internal user IDs over email addresses.

---

## Redaction

If structured payload logging is introduced, use explicit allowlists.

Do not attempt to redact arbitrary objects after serialization as the primary strategy.

Prefer logging:

```text
article_id
actor_id
status
block_count
```

instead of the complete article document.

---

## Startup Logging

At startup, log:

* service name;
* environment;
* version;
* listening address;
* enabled major capabilities;
* configuration validation result;
* dependency initialization result.

Do not log:

* secret values;
* database URLs containing passwords;
* tokens;
* complete environment.

Example:

```text
application starting
database connection initialized
HTTP server listening
```

---

## Shutdown Logging

Log:

* shutdown signal;
* graceful shutdown start;
* components being stopped;
* timeout exceeded;
* shutdown completion.

Do not terminate silently.

Do not call `os.Exit` from internal packages before logs can flush.

---

## Health Endpoint

Provide:

```text
GET /health
```

Purpose:

* confirm the process is alive;
* support container and load-balancer liveness;
* remain lightweight;
* not depend on every external service.

Recommended response:

```json
{
  "status": "ok"
}
```

Possible status:

```text
200 OK
```

Do not make `/health` fail because Redis or S3 is unavailable unless process viability truly depends on it.

---

## Readiness Endpoint

Provide:

```text
GET /ready
```

Purpose:

* confirm the application can receive traffic;
* check essential dependencies;
* expose degraded readiness safely.

Possible essential dependency:

```text
PostgreSQL
```

Other dependencies should be included only when they are essential to current traffic.

Use short timeouts.

Do not run migrations, heavy queries, or external workflows inside readiness.

---

## Readiness Response

A basic successful response:

```json
{
  "status": "ready"
}
```

A more detailed internal-safe response may include:

```json
{
  "status": "not_ready",
  "checks": {
    "database": "unavailable"
  }
}
```

Do not expose:

* connection strings;
* internal hostnames;
* credentials;
* stack traces.

Choose whether detailed checks are public or restricted.

---

## Dependency Criticality

Classify dependencies.

### Required

Failure means the application should not receive traffic.

Example:

```text
PostgreSQL
```

### Optional

Failure degrades a feature but does not stop basic service.

Possible examples:

```text
Redis
LocalStack S3 during early phases
email
analytics
```

Do not make readiness depend on optional services.

Do not hide failure of required services.

---

## Health Check Timeouts

Each dependency check must have a short bounded timeout.

Do not inherit a long request timeout.

Do not allow a stuck dependency to make readiness requests hang.

Readiness endpoints should respond quickly.

---

## Docker Health Checks

Docker health checks should call stable endpoints or service-native checks.

Examples:

```text
PostgreSQL -> pg_isready
Redis -> redis-cli ping
backend -> /health
```

Do not assume utilities such as `curl` exist in minimal images.

Do not use fixed sleeps as health checks.

---

## Metrics

Introduce metrics when a concrete question or alert requires them.

Potential application metrics:

```text
http_requests_total
http_request_duration_seconds
http_in_flight_requests
article_publish_total
article_publish_failures_total
media_upload_total
media_upload_failures_total
authentication_failures_total
authorization_denials_total
search_requests_total
search_duration_seconds
```

Use standard naming conventions.

Do not create a metric for every log message.

---

## Metric Types

### Counter

Monotonically increasing event count.

Examples:

```text
requests
publishes
failures
```

### Gauge

Current value.

Examples:

```text
in_flight_requests
queue_depth
active_workers
```

### Histogram

Distribution of observations.

Examples:

```text
request latency
upload size
query duration
```

Use metric types correctly.

Do not use a gauge for cumulative request counts.

---

## Metric Labels

Labels must have bounded cardinality.

Appropriate labels:

```text
method
route
status_class
operation
result
```

Dangerous labels:

```text
user_id
article_id
email
raw_path
error_message
search_query
```

Do not create high-cardinality metrics.

High-cardinality values belong in logs or traces.

---

## HTTP Metrics

When introduced, HTTP metrics should use route templates.

Example:

```text
route="/api/v1/articles/{slug}"
```

Do not use raw URL paths as labels.

Consider:

* request count;
* latency;
* in-flight requests;
* response status class.

---

## Business Metrics

Business-oriented operational metrics may include:

```text
articles_published_total
species_published_total
draft_save_failures_total
media_processing_failures_total
```

Use only when they support product operations or alerts.

Do not publish sensitive user behavior as infrastructure metrics.

---

## Metrics Endpoint

A metrics endpoint may be introduced later.

Potential path:

```text
/metrics
```

If exposed:

* restrict access;
* do not expose publicly without review;
* avoid sensitive labels;
* document scraping;
* define authentication or network boundary.

Do not add `/metrics` during Phase 0 unless a collector or test needs it.

---

## Distributed Tracing

Prepare for OpenTelemetry, but do not introduce it before useful.

Tracing becomes valuable when:

* external services exist;
* workers exist;
* AWS calls affect latency;
* authentication-provider calls occur;
* background jobs span multiple steps.

The initial monolith may use correlation IDs first.

Do not add tracing only to produce unused spans.

---

## Trace Context

When OpenTelemetry is introduced, support standard propagation.

Potential standard:

```text
W3C Trace Context
```

Headers:

```text
traceparent
tracestate
```

Do not invent a custom tracing protocol.

Correlation IDs may coexist with trace IDs.

---

## Span Design

Create spans around meaningful operations:

* HTTP request;
* database query group;
* object-storage upload;
* external identity verification;
* worker job;
* article publication;
* media processing.

Do not create spans for every small function.

Span names should be stable and low-cardinality.

---

## Trace Attributes

Safe attributes may include:

```text
http.request.method
http.route
http.response.status_code
db.system
server.address
article.status
operation.name
```

Avoid:

```text
article full content
access token
email
raw SQL with sensitive values
```

Do not place secrets in span attributes.

---

## Sampling

Production tracing requires a sampling strategy.

Possible:

* head sampling;
* parent-based sampling;
* higher sampling for errors;
* environment-specific sampling.

Do not collect every trace indefinitely without cost analysis.

Development may use higher sampling.

---

## Database Observability

Observe:

* connection acquisition failures;
* query duration;
* transaction failures;
* constraint conflicts;
* connection-pool saturation;
* readiness failure.

Do not log every SQL statement in production by default.

Do not log parameter values that may contain sensitive data.

Use slow-query diagnostics deliberately.

---

## Database Pool Metrics

Future useful metrics:

```text
open_connections
idle_connections
in_use_connections
acquire_duration
acquire_failures
```

Add them only when the database pool library and metric system support reliable collection.

Do not label them by user or query.

---

## Redis Observability

When Redis becomes operationally important, observe:

* connection failures;
* cache hit and miss;
* operation latency;
* rate-limit failures;
* fallback behavior.

Do not add cache metrics before cache behavior exists.

Do not log full cache keys when they contain user identifiers.

---

## Object Storage Observability

For S3 or LocalStack operations, observe:

* uploads;
* download or URL-generation failures;
* object-not-found;
* latency;
* cleanup failures;
* processing status.

Do not log signed URLs.

Do not log object contents.

Object keys may be logged only when safe and useful.

---

## Authentication Observability

Observe:

* missing credentials;
* invalid token categories;
* wrong issuer;
* wrong audience;
* expired token;
* disabled account;
* synchronization failures;
* login-related dependency failures.

Do not log raw tokens or full claims.

Do not expose detailed cryptographic failures to clients.

Use separate security metrics or rate-limited logs for repeated invalid-token noise.

---

## Authorization Observability

Observe:

* denied permission;
* protected operation;
* actor ID;
* target resource type;
* result.

Avoid logging sensitive resource content.

Repeated denial events may indicate:

* expected user behavior;
* stale UI;
* malicious access;
* misconfiguration.

Do not treat every denial as a critical error.

---

## Article Workflow Observability

When editorial workflows exist, log or audit:

* draft created;
* draft updated;
* submitted for review;
* returned to draft;
* scheduled;
* published;
* archived;
* publication failed.

Useful fields:

```text
article_id
actor_id
from_status
to_status
revision_id
scheduled_at
```

Do not log article body content.

---

## Media Workflow Observability

Observe:

* upload initiated;
* upload completed;
* metadata saved;
* processing queued;
* processing completed;
* processing failed;
* orphan cleanup failed.

Do not log binary contents or signed URLs.

---

## Worker Observability

Workers must log:

* startup;
* shutdown;
* job received;
* job completed;
* job failed;
* retry;
* dead-letter outcome;
* idempotent duplicate;
* processing duration.

Useful fields:

```text
job_type
job_id
attempt
duration_ms
result
```

Do not log full queue payloads by default.

---

## Retry Observability

Retries should be visible.

Record:

* operation;
* attempt;
* maximum attempts;
* reason;
* next delay;
* final outcome.

Do not log every fast retry at error level.

Use `warn` for intermediate retry and `error` for exhausted retries when appropriate.

---

## Audit Events

Audit events differ from operational logs.

Audit important actions:

```text
role_assigned
role_removed
account_disabled
article_published
article_archived
media_deleted
administrator_action
```

An audit event should include:

```text
event_id
occurred_at
actor_id
action
target_type
target_id
result
correlation_id
safe_metadata
```

Do not use ephemeral request logs as the only source of critical administrative history.

---

## Audit Event Integrity

Audit records should be:

* append-oriented;
* difficult to alter through normal application flows;
* attributable;
* timestamped;
* queryable;
* retained according to policy.

Do not allow general profile-update endpoints to modify audit records.

Do not include secrets or complete content payloads.

---

## Audit Event Ownership

The application owns business audit events.

Infrastructure owns infrastructure audit sources such as:

* CloudTrail;
* deployment logs;
* state-change records.

Do not mix business and infrastructure audit semantics without distinction.

---

## Frontend Observability

Frontend observability may include:

* page-load failures;
* API errors;
* rendering exceptions;
* unsupported content blocks;
* authentication callback failures;
* failed saves.

Initially, use controlled error boundaries and browser-console diagnostics in development.

Do not add third-party frontend monitoring before privacy and security review.

Do not expose personal content in error reports.

---

## Error Boundaries

React error boundaries should:

* display a safe fallback;
* provide a recovery action;
* capture a safe diagnostic;
* avoid leaking internal details;
* preserve correlation information when available.

Do not use error boundaries for normal API errors.

Do not hide recurring rendering bugs behind a generic fallback without logging.

---

## Client Correlation IDs

The frontend may:

* receive `X-Correlation-ID`;
* display it on support-oriented error states;
* include it in client diagnostics.

Do not generate a new unrelated client correlation ID for every API response when the server already provides one.

Do not expose the ID as if it were a secret.

---

## Local Observability

The Phase 0 local environment should support:

```bash
docker compose ps
docker compose logs api
docker compose logs postgres
docker compose logs keycloak
```

Mailpit and Keycloak administrative interfaces provide additional diagnostics.

Do not require a separate logging stack for basic local troubleshooting.

Use stdout and stderr.

---

## Local Log Format

JSON logs are preferred even locally for consistency.

A human-readable local format may be allowed through configuration if:

* field semantics remain equivalent;
* production remains structured;
* tests do not depend on formatting.

Do not maintain two unrelated logging implementations.

---

## CloudWatch

Future AWS deployment may use:

* CloudWatch Logs;
* CloudWatch Metrics;
* CloudWatch Alarms;
* Container Insights when justified;
* log insights queries;
* dashboards.

Do not create every possible CloudWatch resource in Phase 0.

---

## CloudWatch Log Groups

Create log groups explicitly when retention matters.

Potential names:

```text
/aws/ecs/reptile-archive-dev-api
/aws/ecs/reptile-archive-prod-api
/aws/ecs/reptile-archive-prod-worker
```

Configure:

* retention;
* encryption when required;
* deletion behavior;
* task execution permissions.

Do not retain logs indefinitely by default.

---

## Log Retention

Retention should depend on:

* environment;
* security;
* incident response;
* cost;
* privacy;
* audit policy.

Possible direction:

```text
development -> short retention
staging -> medium retention
production -> longer retention
audit events -> policy-driven retention
```

Do not choose retention periods without documenting rationale.

---

## CloudWatch Metrics

Infrastructure metrics may include:

* ECS CPU;
* ECS memory;
* task count;
* ALB requests;
* ALB target response time;
* ALB 5xx;
* RDS CPU;
* RDS free storage;
* database connections;
* queue depth;
* dead-letter count.

Do not duplicate AWS native metrics unnecessarily.

Application metrics should fill gaps.

---

## Alarms

An alarm must answer:

* what condition is abnormal;
* who owns it;
* how severe it is;
* what action should be taken;
* which runbook applies.

Potential alarms:

```text
API unhealthy targets
high 5xx rate
high latency
RDS low storage
queue backlog
dead-letter messages
worker failure rate
```

Do not create alarms without an owner or response path.

Do not alert on every transient error.

---

## Alert Quality

Good alerts are:

* actionable;
* specific;
* low-noise;
* tied to user impact or imminent risk;
* supported by a runbook.

Avoid:

* alerts on individual expected 4xx responses;
* alerts without thresholds;
* duplicate alerts for the same failure;
* alerts that automatically resolve too slowly to be useful.

---

## Dashboards

Dashboards may include:

* request volume;
* latency;
* errors;
* availability;
* dependency health;
* database saturation;
* queue health;
* publishing activity.

Do not create decorative dashboards with no operational use.

A dashboard should support:

* incident detection;
* diagnosis;
* capacity review;
* release validation.

---

## Golden Signals

For production services, consider:

```text
latency
traffic
errors
saturation
```

These provide a practical baseline.

Do not implement abstract SRE terminology without actual measurable indicators.

---

## SLIs and SLOs

Future service-level indicators may include:

```text
successful request ratio
API latency
article publication success
search availability
```

Service-level objectives require:

* defined measurement;
* user-relevant scope;
* time window;
* target;
* ownership;
* error budget policy.

Do not invent production SLOs before real traffic and business expectations exist.

---

## Availability

Health endpoint availability is not the same as user-facing availability.

A service may return `/health` successfully while:

* database is unavailable;
* public pages fail;
* authentication fails.

Use readiness, request metrics, and synthetic tests to measure actual service behavior.

---

## Synthetic Checks

Future production may add synthetic checks for:

* home page;
* public species endpoint;
* public article endpoint;
* authentication redirect;
* admin login availability.

Do not use synthetic checks to perform destructive actions.

Do not expose credentials in check configuration.

---

## Deployment Observability

Deployment workflows should report:

* version;
* image digest;
* environment;
* migration status;
* rollout status;
* health-check outcome;
* rollback outcome.

Application startup logs should include version.

Do not rely only on mutable image tags.

---

## Version Information

Expose or log a build version.

Possible sources:

* semantic version;
* Git commit;
* build timestamp;
* image digest.

Potential endpoint:

```text
/version
```

Add only when operationally useful.

Do not expose unnecessary repository information.

At minimum, include version in startup logs.

---

## Release Markers

Future observability tools may annotate deployments.

This helps correlate:

* latency changes;
* error increases;
* resource changes.

Do not add release markers before a backend exists to receive or display them.

---

## Operational Runbooks

Create runbooks for important failures.

Potential runbooks:

```text
database unavailable
Keycloak unavailable
LocalStack resource missing
article publication failing
media upload failing
API unhealthy
queue backlog
secret exposure
deployment rollback
```

Phase 0 should at least document local service troubleshooting.

---

## Runbook Structure

A runbook should contain:

```text
symptoms
impact
detection
immediate checks
diagnostic commands
likely causes
mitigation
recovery
escalation
follow-up
```

Do not create vague runbooks that only say “check logs.”

---

## Diagnostic Commands

Document safe commands.

Local examples:

```bash
docker compose ps
docker compose logs api
docker compose logs postgres
curl --fail http://localhost:8080/health
curl --fail http://localhost:8080/ready
```

AWS examples may later include:

```bash
aws logs
aws ecs
aws cloudwatch
```

Do not include commands that expose secrets or destroy resources without warnings.

---

## Support Diagnostics

Support-visible errors may include:

* safe message;
* correlation ID;
* timestamp;
* retry action.

Do not expose:

* stack trace;
* SQL;
* internal hostname;
* secret;
* raw provider error.

Correlation IDs should help operators locate corresponding logs.

---

## Sampling Logs

High-volume logs may need sampling.

Candidates:

* repeated invalid-token attempts;
* frequent health checks;
* repeated not-found requests;
* high-volume activity events.

Do not sample:

* critical failures;
* audit events;
* rare destructive operations.

Sampling must be documented.

---

## Health-Check Logging

Do not log every successful health request at normal request-log volume in production.

Options:

* exclude successful health routes;
* lower them to debug;
* sample them.

Do log health failures.

This prevents noise and unnecessary cost.

---

## Search Query Logging

Do not log raw search terms by default.

Search terms may reveal sensitive interests or personal information.

Prefer metrics such as:

```text
query length
result count
duration
filter count
```

If raw query logging is ever needed, require privacy review.

---

## User Activity Observability

Gamification activity events are product data, not automatically operational logs.

Do not duplicate every activity event into logs.

Log processing failures and aggregate metrics.

Store product events according to domain and privacy rules.

---

## Cardinality Control

Before adding a field to metrics, traces, or indexes, evaluate cardinality.

High-cardinality examples:

```text
user ID
article ID
slug
email
search query
error message
```

These may be acceptable in logs, but not metrics labels.

Do not allow uncontrolled cardinality to increase cost and reduce query performance.

---

## Error Aggregation

Errors should be grouped by stable dimensions:

```text
error_code
operation
route
dependency
status_class
```

Do not group by full dynamic error messages.

This enables useful trends and alerts.

---

## Logging Dependency Errors

For dependency failures, include:

```text
dependency
operation
timeout
retryable
error_code
```

Do not expose credentials or full endpoints containing secrets.

Example:

```text
dependency=postgres
operation=readiness_check
error_code=database_unavailable
```

---

## Retry and Backoff Metrics

When workers or external integrations exist, useful metrics may include:

```text
retry_total
retry_exhausted_total
operation_duration
```

Do not label retries by unique job ID.

Job IDs belong in logs.

---

## Queue Observability

When SQS or another queue exists, observe:

* visible messages;
* oldest message age;
* in-flight messages;
* dead-letter count;
* consumer success;
* consumer failure;
* processing duration.

Do not introduce queue dashboards before queues exist.

---

## Scheduled Publication Observability

When scheduling exists, observe:

* schedules created;
* schedules cancelled;
* publications due;
* publications completed;
* publications failed;
* delayed publications.

A failed scheduled publication must be diagnosable.

Do not allow silent scheduler failure.

---

## Media Processing Observability

When processing exists, observe:

* input format;
* safe dimensions;
* processing duration;
* output variants;
* failure category;
* orphan cleanup.

Do not log image contents or private signed URLs.

---

## Trace and Log Correlation

When tracing is introduced, include:

```text
trace_id
span_id
```

in structured logs.

This allows navigation between logs and traces.

Do not generate unrelated trace IDs manually.

Use the tracing SDK context.

---

## OpenTelemetry

When adopted, use OpenTelemetry standards.

Potential instrumentation:

* HTTP server;
* PostgreSQL;
* AWS SDK;
* workers;
* custom publication spans.

Use the SDK and exporters intentionally.

Do not add multiple competing tracing systems.

Do not hardcode exporter endpoints throughout the codebase.

---

## OpenTelemetry Configuration

Potential variables:

```text
OTEL_SERVICE_NAME
OTEL_EXPORTER_OTLP_ENDPOINT
OTEL_TRACES_SAMPLER
OTEL_RESOURCE_ATTRIBUTES
```

Centralize configuration.

Do not expose secret headers in logs.

Do not make telemetry exporter failure crash the main service unless explicitly required.

---

## Telemetry Failure Behavior

Observability must not normally break core application behavior.

If log output or trace export fails:

* preserve application behavior when safe;
* report failure locally if possible;
* avoid infinite retry loops;
* avoid blocking requests.

Audit persistence may require stronger guarantees for selected actions.

Distinguish operational telemetry from compliance-critical audit data.

---

## Test Strategy

### Logging Tests

Test:

* stable fields;
* level behavior;
* correlation injection;
* sensitive-field absence;
* error-code mapping.

Avoid tests coupled to complete JSON string ordering.

Decode structured logs when asserting fields.

### Middleware Tests

Test:

* generated correlation ID;
* accepted valid correlation ID;
* rejected malformed ID;
* response header;
* request-completion fields;
* health-route noise behavior.

### Health Tests

Test:

* `/health` succeeds while optional dependency is unavailable;
* `/ready` fails when required database is unavailable;
* readiness uses timeouts;
* responses do not expose secrets.

### Metrics Tests

When metrics exist, test:

* expected counter changes;
* bounded labels;
* route templates;
* no high-cardinality labels.

### Worker Tests

Test:

* success logs;
* retry logs;
* exhausted retry;
* idempotent duplicate;
* shutdown.

Do not test only that a log line exists; test operational meaning.

---

## Log Capture in Tests

Use a test handler or buffer.

Prefer structured field assertions.

Example concept:

```go
records := captureLogs(func(logger *slog.Logger) {
	logger.Info("article published", "article_id", "id")
})
```

Assert:

* message;
* level;
* field presence;
* sensitive-field absence.

Do not make tests depend on timestamps or exact field order.

---

## Health Integration Tests

Integration tests should validate actual database readiness behavior.

Use an isolated PostgreSQL instance.

Test transitions:

```text
database available -> ready
database unavailable -> not ready
```

Do not point health tests at a developer's shared database.

---

## Terraform Validation

When observability infrastructure changes, run:

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
tflint
```

Security scans when configured:

```bash
checkov -d .
trivy config .
```

Do not create alarm resources without validating dimensions and references.

---

## Docker Validation

For local observability changes:

```bash
docker compose config
docker compose up -d
docker compose ps
docker compose logs api
```

Check:

```bash
curl --fail http://localhost:8080/health
curl --fail http://localhost:8080/ready
```

Only report commands actually executed.

---

## Documentation Requirements

When observability changes, evaluate updates to:

```text
README.md
docs/architecture/
docs/development/
docs/runbooks/
docs/security/
infrastructure/terraform/README.md
```

Recommended documents:

```text
docs/architecture/observability.md
docs/runbooks/local-development.md
docs/runbooks/api-unhealthy.md
docs/runbooks/database-unavailable.md
```

Document:

* log format;
* field names;
* correlation header;
* health semantics;
* readiness dependencies;
* metric names;
* trace strategy;
* audit events;
* retention;
* troubleshooting commands;
* known gaps.

Do not leave operational behavior only in code.

---

## ADRs

Potential ADRs:

```text
Use structured JSON logs
Use X-Correlation-ID for request correlation
Separate liveness and readiness
Adopt OpenTelemetry when distributed workloads exist
Use CloudWatch for initial AWS observability
Separate audit events from operational logs
```

Create ADRs only for actual decisions.

Do not create ADRs for every log field.

---

## Environment Variables

Potential backend variables:

```text
LOG_LEVEL
LOG_FORMAT
SERVICE_NAME
APP_ENV
APP_VERSION
CORRELATION_HEADER
READINESS_TIMEOUT
```

Future telemetry variables:

```text
OTEL_ENABLED
OTEL_EXPORTER_OTLP_ENDPOINT
OTEL_TRACES_SAMPLER
```

Validate configuration at startup.

Do not allow sensitive exporter headers to be logged.

---

## Implementation Workflow

When using this skill:

1. define the operational question;
2. identify the affected service or workflow;
3. choose the appropriate signal;
4. define stable fields or metric dimensions;
5. review privacy and security;
6. implement the smallest useful signal;
7. add tests;
8. validate local diagnostics;
9. validate infrastructure when affected;
10. update runbooks and architecture documentation;
11. report known gaps and residual risk.

Do not add telemetry without a consumer or operational purpose.

---

## Expected Deliverables

Depending on the task, deliverables may include:

* logger configuration;
* structured logging middleware;
* correlation middleware;
* health endpoint;
* readiness endpoint;
* dependency checks;
* audit-event model;
* metrics;
* traces;
* worker diagnostics;
* CloudWatch resources;
* alarms;
* dashboards;
* runbooks;
* tests;
* documentation;
* ADRs.

Do not create unrelated monitoring infrastructure.

---

## Definition of Done

An observability task is complete only when:

* the operational question is clear;
* the chosen signal is appropriate;
* fields and names are stable;
* sensitive data is excluded;
* correlation is preserved;
* health and readiness semantics are correct;
* optional and required dependencies are distinguished;
* tests cover failure behavior;
* local diagnostics are usable;
* infrastructure validation passes when affected;
* documentation is updated;
* telemetry noise and cardinality are considered;
* no success is falsely claimed.

---

## Prohibited Practices

Do not:

* log raw tokens, passwords, cookies, or secrets;
* log complete request bodies by default;
* log article bodies or uploaded files;
* use user IDs or article IDs as metric labels;
* use raw paths as route labels;
* make `/health` depend on every service;
* run expensive checks in `/ready`;
* log every successful health request at normal volume;
* add metrics without a question or consumer;
* add traces without meaningful boundaries;
* create alarms without owners or runbooks;
* retain logs forever by default;
* expose detailed infrastructure information publicly;
* treat operational logs as complete audit history;
* use full dynamic error messages as aggregation keys;
* claim observability is complete because logs exist;
* add a full monitoring stack during Phase 0 without need;
* declare completion without testing failure paths.

---

## Completion Report

After completing an observability task, report:

```markdown
## Observability scope

## Operational questions

## Logging and correlation

## Health and readiness

## Metrics and tracing

## Audit events

## Infrastructure monitoring

## Security and privacy considerations

## Tests

## Validation performed

## Runbooks and documentation

## Limitations and remaining gaps
```

Keep the report factual and based on actual implementation and validation.

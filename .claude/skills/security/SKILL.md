---

name: security
description: Defines and enforces the security standards used across the reptile knowledge platform. Use this skill for input validation, output encoding, injection prevention, CSRF/CORS, security headers, rate limiting, secrets management, upload security, mass-assignment protection, and the security review checklist applied to every externally reachable change.
when_to_use: Use whenever a task creates, changes, reviews, or tests any externally reachable behavior — public or administrative API endpoints, file uploads, authentication-adjacent code, editorial content rendering, infrastructure exposure, or secrets handling — and whenever another skill's Mandatory Context step instructs reading the `security` skill.
argument-hint: "[security-task-or-review-scope]"
disable-model-invocation: false
user-invocable: true
model: inherit
effort: high
paths:

* "apps/api/**/*.go"
* "apps/web/src/**/*.{ts,tsx}"
* "infrastructure/**"
* ".github/workflows/**"
* "docs/security/**"
* ".env.example"

---

# Security

## Objective

Define and enforce the security standards that apply across every module of the reptile knowledge platform.

Use this skill to guide:

* input validation;
* output encoding and XSS prevention;
* injection prevention;
* CSRF and CORS configuration;
* security headers;
* rate limiting;
* secrets management;
* upload security;
* mass-assignment protection;
* dependency and supply-chain security;
* infrastructure security review;
* the security checklist applied before completing any externally reachable change.

The current task is:

```text
$ARGUMENTS
```

If no arguments were provided, infer the task from the current conversation.

---

## Mandatory Context

Before changing security-relevant behavior:

1. Read `${CLAUDE_PROJECT_DIR}/CLAUDE.md`.
2. Read the `go-backend`, `react-frontend`, `database`, `authentication`, `content-editor`, `local-development`, `terraform-aws`, and `observability` skills when relevant.
3. Inspect existing authentication and authorization implementation.
4. Inspect existing input validation and sanitization.
5. Inspect existing secrets handling and configuration loading.
6. Identify the current project phase.
7. Identify the trust boundary the change crosses.
8. Identify whether the change is externally reachable (public API, public frontend, upload, webhook, infrastructure endpoint).

Do not treat security as a separate, phase-gated feature. Apply it to every externally reachable change, whether or not it was explicitly requested.

Do not assume another skill already enforces a control without verifying it in the actual code.

---

## Core Principles

* security by default;
* deny by default;
* defense in depth;
* least privilege;
* explicit trust boundaries;
* fail closed, not open;
* validate at every boundary that crosses trust, including boundaries internal to the project's own frontend and backend;
* never trust client input, including input from this project's own frontend;
* the backend is the sole authority for authorization decisions.

Do not implement a control only on the layer that is easiest to reach. Implement it at the layer that actually owns the invariant.

---

## Threat Model by Phase

### Phase 0 — Foundation

Minimal attack surface (health/readiness endpoints, static assets). Still requires: restrictive CORS, no verbose error responses, no secrets in logs or `.env.example`, pinned dependency and image versions.

### Phase 1 — Public Catalog

Public, read-only content. Requires: exclusion of unpublished data from every public response, injection-safe search and filters, and abuse-aware rate limiting if a public endpoint is measurably abused.

### Phase 2 — Users and Authentication

The single highest-risk area introduced so far. See the `authentication` skill for identity-provider detail; this skill defines the general controls that apply regardless of provider (token validation baseline, session handling, CSRF/CORS, self-escalation prevention).

### Phase 3 — Administration

Introduces mass-assignment risk, object-level authorization requirements, and file uploads.

### Phase 4 — Advanced Editorial Experience

Introduces additional content-rendering surface (new block types, embeds) — each requires its own sanitization and rendering-safety review.

### Phase 5 — Gamification

Introduces event-submission abuse risk; client-submitted values are never authoritative.

### Phase 6 — AWS Deployment

Introduces real infrastructure exposure. Delegate detailed infrastructure controls to the `terraform-aws` skill; this skill's responsibility is the review checklist (IAM least privilege, no public database/cache, no hardcoded credentials, LocalStack/production separation).

Do not apply Phase 6-level controls to Phase 0 work, and do not skip Phase 0-level controls because "nothing is public yet."

---

## Trust Boundaries

Identify every boundary a change crosses. Typical boundaries in this project:

```text
browser <-> API
API <-> PostgreSQL
API <-> Redis
API <-> object storage (LocalStack / S3)
API <-> identity provider (Keycloak / Cognito)
CI <-> deployment target
```

Every boundary crossing requires, as applicable: authentication, input validation, output encoding, and logging that excludes sensitive data.

Do not assume a boundary is trusted merely because it is "internal" to the project's own systems.

---

## Input Validation

* validate at the transport boundary — types, required fields, length, format, payload size;
* validate again at the domain or application boundary for business invariants;
* reject unknown fields on administrative write endpoints when appropriate;
* enforce payload size limits on every write endpoint;
* reject malformed or multiple JSON documents;
* do not rely on frontend validation (Zod, React Hook Form) as enforcement — it exists for user experience only.

---

## Output Encoding and XSS

* never use `dangerouslySetInnerHTML` for untrusted content;
* render structured article content only through the explicit block-renderer registry defined by the `content-editor` skill — never render arbitrary component names or raw HTML received from the API;
* escape all user-supplied values in HTML contexts;
* validate and constrain links: allow only `https`, `http`, and `mailto` protocols; reject `javascript:` and unsafe `data:` URLs;
* apply a Content-Security-Policy header where practical.

---

## Injection

* SQL: always use parameterized queries generated by `sqlc`; never build SQL through string concatenation (see the `database` skill);
* never build shell commands from user-controlled input;
* validate and normalize any file path derived from user input to prevent path traversal;
* SSRF: never let the backend fetch a user-supplied URL without an explicit allowlist of destinations.

---

## CSRF and CORS

* restrict CORS to explicitly configured origins; never use `Access-Control-Allow-Origin: *` together with credentials;
* bearer-token-in-header authentication reduces classic CSRF risk, but does not eliminate the need for strong XSS protection, since a token-stealing XSS bypasses the benefit;
* if cookie-based sessions are ever introduced, require CSRF protections: `SameSite` policy, anti-CSRF tokens, and origin checks;
* CORS is not an authorization mechanism — it does not replace backend authorization.

---

## Security Headers

Recommended baseline for HTTP responses:

```text
X-Content-Type-Options: nosniff
Referrer-Policy
Permissions-Policy
Content-Security-Policy
Cross-Origin-Opener-Policy
Cross-Origin-Resource-Policy
Strict-Transport-Security  (production only — do not require it for local HTTP)
```

Do not copy a production header set unmodified into local development if it would break local HTTP workflows.

---

## Rate Limiting

Apply rate limiting deliberately to:

* authentication callback endpoints;
* profile updates;
* role management;
* activity-event submission;
* any endpoint with demonstrated abuse.

Do not rate-limit every authenticated read endpoint indiscriminately — use identity, IP, endpoint, and threat context to decide (see the `authentication` skill).

---

## Secrets Management

* secrets live outside the repository — in `.env` locally, and in Secrets Manager or Parameter Store on AWS;
* `.env.example` contains placeholders only, never real values;
* never commit real keys, tokens, or passwords, including in versioned examples or documentation;
* never expose backend secrets through `VITE_`-prefixed frontend variables — anything bundled into the frontend is public;
* never log secret values, raw tokens, cookies, or credentials;
* if a secret is ever committed, rotate it and treat the exposure as a real incident — deleting the file alone is not sufficient, since the value remains in Git history.

---

## Authentication and Authorization Baseline

This skill defines the general controls that apply regardless of identity provider. The `authentication` skill owns the detailed Keycloak/Cognito integration.

* the backend is the sole enforcer of authorization; frontend checks exist for user experience only;
* validate token signature, issuer, audience, expiration, and accepted signing algorithms on every protected request;
* use deny-by-default authorization — a valid token proves identity, not permission;
* enforce object-level access control, not only endpoint-level checks;
* prevent self-privilege escalation — reject role and permission fields on general profile-update endpoints; use separate, explicitly authorized administrative endpoints for role management;
* protect against mass assignment by using explicit request DTOs; never bind a request directly to a persistence model.

---

## Upload Security

* authenticate and authorize every upload;
* enforce file size limits, a MIME-type allowlist, and extension checks;
* do not trust the original filename; generate safe, unique storage keys;
* store uploads privately by default; expose them deliberately and only when required;
* validate image dimensions and reject malformed files;
* clean up orphaned uploaded objects after a failed metadata save.

---

## Editorial Content Security

* accept only known, explicitly validated content-block types (see the `content-editor` skill);
* sanitize or structurally render all persisted content; never trust raw HTML supplied by an author or the API;
* keep unpublished and preview content behind authorization; never expose predictable, unauthenticated preview URLs;
* apply defense in depth: editor constraints, frontend validation, backend schema validation, safe public rendering, and CSP, in combination — not any single layer alone.

---

## Dependency and Supply-Chain Security

* run `go mod verify` and `govulncheck` for backend dependencies, and the project's chosen npm audit/scanner for frontend dependencies, before adopting or updating a dependency;
* justify every new dependency (see the `go-backend` and `react-frontend` skills for the adoption checklist);
* pin container image versions; never use `latest`;
* scan production-oriented container images for vulnerable packages and embedded secrets.

---

## Infrastructure Security

Detailed infrastructure rules belong to the `terraform-aws` and `local-development` skills. This skill's review responsibility before completing infrastructure-adjacent work:

* no resource is publicly exposed without a documented reason;
* no wildcard IAM policy (`actions = ["*"]`, `resources = ["*"]`) without a documented, temporary bootstrap justification;
* no hardcoded AWS credentials anywhere in source;
* no LocalStack endpoint is reachable from a real-AWS/production configuration, and no local command silently falls back to a real AWS account;
* `terraform apply` and `terraform destroy` are never run against a real AWS account without explicit, unambiguous authorization.

---

## Logging and Sensitive Data

Never log:

* passwords;
* complete or raw access/refresh tokens;
* authorization headers or cookies;
* recovery codes;
* client secrets or database credentials;
* private keys;
* complete request bodies;
* article bodies or uploaded file contents;
* raw search queries;
* unnecessary personal data.

See the `observability` skill for the full structured-logging contract, including which fields are safe to include (correlation ID, route, status, duration, safe resource identifiers).

---

## Testing Strategy

* add a negative-path test for every new security control: missing authentication, invalid or expired token, forbidden role, oversized payload, invalid MIME type, disallowed origin, malformed input;
* do not mock away the exact boundary being tested — an authorization test that mocks the authorization check verifies nothing;
* authorization changes require an explicit matrix of actor × action × expected result, consistent with the matrix format used in the `authentication` skill;
* prefer integration tests over unit tests when the control depends on real middleware, database constraints, or provider behavior.

---

## Security Review Checklist

Before completing any externally reachable change, verify:

* input is validated at the transport and domain boundaries;
* output is safely encoded or structurally rendered, never raw HTML from an untrusted source;
* authorization is enforced on the backend, at the object level where relevant;
* no secret, credential, or raw token is exposed, logged, or committed;
* CORS and security headers are correctly scoped to the environment;
* uploads, if any, are validated, authorized, and stored safely;
* new dependencies are justified and scanned;
* error responses do not leak internal details (stack traces, SQL, infrastructure hostnames);
* rate limiting is applied where abuse is plausible.

Do not mark a change as reviewed if any item above was not actually checked.

---

## Documentation Requirements

When a security-relevant decision is made, evaluate updates to:

```text
docs/security/
docs/adr/
docs/architecture/
README.md
```

Recommended security documents (create only when real content exists):

```text
docs/security/security-baseline.md
docs/security/threat-model.md
docs/security/access-control.md
docs/security/upload-security.md
```

Do not publish real secrets, real AWS account IDs (unless intentionally public), private keys, or unredacted incident evidence in any repository document.

---

## Implementation Workflow

When using this skill:

1. identify the trust boundary and the actor crossing it;
2. identify the specific, concrete threat(s) relevant to the change;
3. define the minimum controls needed to address them;
4. implement validation, authorization, and safe error handling at the correct layer;
5. add negative-path tests;
6. run relevant static and dependency scans;
7. update security documentation when a security-relevant decision was made;
8. report residual risk honestly.

---

## Expected Deliverables

Depending on the task, deliverables may include:

* input validation and payload limits;
* authorization checks, including object-level checks;
* safe error responses;
* security headers and CORS configuration;
* upload validation;
* secrets-handling corrections;
* negative-path tests;
* security documentation updates.

Do not implement unrelated features while addressing a security task.

---

## Definition of Done

A security-relevant task is complete only when:

* the trust boundary and threat are explicitly identified;
* validation and authorization exist at the correct layer;
* no secret, token, or credential is exposed or logged;
* negative-path tests exist and pass;
* dependency and infrastructure implications were considered;
* documentation is updated when a security-relevant decision was made;
* residual risk is reported honestly.

---

## Prohibited Practices

Do not:

* trust frontend validation or role checks as enforcement;
* decode or trust a token without verifying its signature;
* use wildcard CORS together with credentials;
* log secrets, raw tokens, cookies, or credentials;
* commit real keys, tokens, or passwords, including in examples or documentation;
* bind request DTOs directly to persistence models;
* accept role or permission fields on general, non-administrative endpoints;
* use `dangerouslySetInnerHTML` for untrusted content;
* build SQL through string concatenation;
* let the backend fetch a user-supplied URL without an allowlist;
* run real AWS `apply` or `destroy` without explicit authorization;
* declare a change secure without an accompanying negative-path test.

---

## Completion Report

After completing a security-relevant task, report:

```markdown
## Security scope

## Trust boundary and threat

## Controls implemented

## Tests added

## Validation performed

## Residual risk

## Documentation updates
```

Keep the report factual and based on actual controls implemented and verified, not assumed.

---

name: authentication
description: Defines authentication and authorization standards for the reptile knowledge platform. Use this skill for Keycloak, Cognito, JWT validation, user identity, roles, permissions, session handling, account lifecycle, protected routes, and access-control testing.
when_to_use: Use whenever a task creates, changes, reviews, debugs, or tests login, registration, token validation, identity synchronization, RBAC, permissions, protected APIs, protected frontend routes, account recovery, email confirmation, or identity-provider integration.
argument-hint: "[authentication-or-authorization-task]"
disable-model-invocation: false
user-invocable: true
model: inherit
effort: high
paths:

* "apps/api/internal/authentication/**"
* "apps/api/internal/users/**"
* "apps/api/internal/platform/auth/**"
* "apps/api/**/*.go"
* "apps/web/src/features/auth/**"
* "apps/web/src/features/profile/**"
* "apps/web/src/app/providers/**"
* "infrastructure/keycloak/**"
* "infrastructure/localstack/**"
* "infrastructure/terraform/modules/authentication/**"
* "infrastructure/terraform/environments/**"

---

# Authentication and Authorization

## Objective

Define and enforce authentication and authorization standards for the reptile knowledge platform.

Use this skill to guide:

* local Keycloak integration;
* future AWS Cognito integration;
* JWT validation;
* identity mapping;
* account lifecycle;
* registration;
* login;
* logout;
* email confirmation;
* account recovery;
* user synchronization;
* roles;
* permissions;
* protected backend routes;
* protected frontend routes;
* authorization policies;
* session safety;
* authentication testing.

The current task is:

```text
$ARGUMENTS
```

If no arguments were provided, infer the task from the current conversation.

---

## Mandatory Context

Before changing authentication or authorization:

1. Read `${CLAUDE_PROJECT_DIR}/CLAUDE.md`.
2. Read the `security`, `go-backend`, `react-frontend`, `database`, and `local-development` skills when relevant.
3. Inspect current identity-provider configuration.
4. Inspect token validation middleware.
5. Inspect user and role persistence.
6. Inspect frontend session handling.
7. Identify the current project phase.
8. Identify which actor types are involved.
9. Identify which permissions are required.
10. Identify whether the change affects local Keycloak, future Cognito compatibility, or both.

Do not implement authentication as an isolated frontend feature.

Do not trust client-side role checks as authorization.

---

## Authentication Strategy

Use:

* Keycloak in the local environment;
* AWS Cognito in the future AWS environment;
* OpenID Connect;
* OAuth 2.0 authorization flows;
* JWT access tokens;
* backend token validation;
* internal identity abstraction;
* role- and permission-based authorization.

The application must not depend directly on Keycloak-specific behavior in its domain or application rules.

The identity provider authenticates users.

The application authorizes actions.

---

## Responsibility Boundaries

### Identity Provider

The identity provider owns:

* credentials;
* password policy;
* password hashing;
* login;
* account confirmation;
* account recovery;
* MFA when introduced;
* token issuance;
* refresh-token lifecycle;
* identity-provider session;
* external subject identifier.

### Application

The application owns:

* local user profile;
* application roles;
* application permissions;
* editorial access;
* business authorization;
* activity history;
* user preferences;
* account-specific domain data.

Do not store user passwords in the application database.

Do not move business permissions entirely into the identity provider.

---

## Internal Identity Abstraction

Use a provider-neutral identity representation.

Example:

```go
type Identity struct {
	Subject     string
	Email       string
	DisplayName string
	Roles       []string
	Permissions map[string]struct{}
}
```

Potential additional fields:

* issuer;
* audience;
* token ID;
* account status;
* email verification state.

The identity abstraction must not expose Keycloak-specific or Cognito-specific types to the domain layer.

Do not pass raw JWT claims throughout the application.

---

## External Subject Identifier

Store the provider subject as a stable external identity reference.

Example database fields:

```text
identity_provider
external_subject
```

Possible unique constraint:

```text
UNIQUE (identity_provider, external_subject)
```

Do not use email as the only identity key.

Email may change.

The provider subject is the primary external identity identifier.

---

## Local User Record

The application may maintain a local user record containing:

* internal user ID;
* identity provider;
* external subject;
* email;
* display name;
* account status;
* created timestamp;
* updated timestamp;
* last login timestamp when needed.

Avoid duplicating identity-provider data without a product need.

Do not store:

* password hashes;
* password-reset tokens owned by the provider;
* MFA secrets owned by the provider;
* full raw token payloads.

---

## Initial Roles

Use these initial roles:

```text
visitor
member
editor
administrator
```

### Visitor

Represents an unauthenticated user.

A visitor is not usually persisted as a role assignment.

### Member

A registered user.

May:

* view public content;
* manage their profile;
* participate in future gamification;
* record permitted activity events.

### Editor

May:

* create species drafts;
* update species drafts;
* create articles;
* update articles;
* upload media;
* submit content for review.

Publishing permissions may be separated.

### Administrator

May:

* manage users;
* assign roles;
* publish content;
* manage taxonomy;
* perform administrative operations.

Do not assume every editor can publish.

Use explicit permissions.

---

## Initial Permissions

Use:

```text
species:read
species:create
species:update
species:publish
articles:read
articles:create
articles:update
articles:publish
media:upload
users:manage
```

Possible future permissions:

```text
taxonomy:manage
articles:review
species:review
media:delete
roles:assign
activity:read
gamification:manage
```

Do not create dozens of permissions before real use cases exist.

Roles are collections of permissions.

Authorization decisions should evaluate permissions rather than hardcoding role names whenever practical.

---

## Role-to-Permission Mapping

A directional initial mapping:

### Member

```text
species:read
articles:read
```

### Editor

```text
species:read
species:create
species:update
articles:read
articles:create
articles:update
media:upload
```

### Administrator

All current permissions.

This mapping must be documented and tested.

Do not duplicate inconsistent role mappings across:

* Keycloak;
* backend;
* frontend;
* seed data;
* Terraform.

Prefer one documented source of truth and generated or synchronized configuration where practical.

---

## Authorization Principles

Authorization must be:

* enforced on the backend;
* explicit;
* deny-by-default;
* testable;
* independent from UI visibility;
* based on identity and resource context;
* protected against object-level access violations.

A hidden button is not authorization.

A valid token does not imply permission.

A role does not automatically imply ownership.

---

## Authentication vs Authorization

### Authentication

Answers:

```text
Who is this user?
```

### Authorization

Answers:

```text
May this user perform this action on this resource?
```

Do not mix these concerns in one large middleware.

Authentication middleware may establish identity.

Application use cases should enforce business authorization.

---

## Token Validation

The backend must validate:

* token signature;
* issuer;
* audience;
* expiration;
* not-before time when present;
* token type when relevant;
* accepted signing algorithms;
* key source;
* required claims.

Do not decode a token without verifying its signature.

Do not accept arbitrary issuers.

Do not skip audience validation.

Do not trust claims from an unverified token.

---

## JWKS

Use the provider JWKS endpoint for public signing keys.

The validator should support:

* key caching;
* key rotation;
* short network timeouts;
* unknown key ID refresh;
* safe failure;
* issuer-specific configuration.

Do not fetch JWKS on every request.

Do not cache keys forever.

Do not fall back to accepting unsigned tokens.

---

## Accepted Algorithms

Explicitly restrict accepted signing algorithms.

Do not accept:

```text
alg = none
```

Do not infer accepted algorithms only from the token header.

Use the provider configuration and trusted application configuration.

---

## Token Types

Access tokens are for API authorization.

ID tokens are primarily for client identity information.

Do not use an ID token as an API access token unless the provider and architecture explicitly require and document it.

The backend should expect access tokens with the correct audience.

---

## Token Claims

Potential claims include:

```text
sub
iss
aud
exp
iat
nbf
email
email_verified
preferred_username
name
realm_access
resource_access
scope
groups
```

Keycloak and Cognito may represent roles differently.

Map provider claims into the internal identity abstraction.

Do not expose provider-specific claim parsing to every handler.

---

## Claim Mapping

Implement provider adapters.

Example conceptual interface:

```go
type TokenVerifier interface {
	Verify(ctx context.Context, rawToken string) (VerifiedToken, error)
}
```

```go
type IdentityMapper interface {
	Map(token VerifiedToken) (Identity, error)
}
```

Or a combined provider-neutral boundary when simpler.

Do not introduce unnecessary interface fragmentation.

The implementation must support future replacement without rewriting domain rules.

---

## Authentication Middleware

Authentication middleware should:

1. read the authorization header;
2. validate the Bearer scheme;
3. reject malformed credentials;
4. verify the token;
5. map claims;
6. place identity in context;
7. continue the request.

It should not:

* load every business permission from many tables on every request without a strategy;
* contain content publishing rules;
* return provider internals;
* log raw tokens.

Example authorization header:

```text
Authorization: Bearer <access-token>
```

---

## Optional Authentication

Some public routes may support optional authentication.

Examples:

* public article page with personalized reading progress;
* species page with future collection state.

Optional authentication must:

* treat absent tokens as anonymous;
* reject malformed or invalid supplied tokens;
* never silently ignore an invalid token.

Do not implement optional authentication before a real use case exists.

---

## Required Authentication

Protected routes must reject missing or invalid credentials.

Recommended outcomes:

```text
401 Unauthorized
```

Use `401` when authentication is missing or invalid.

Use `403 Forbidden` when identity is valid but lacks permission.

Do not return `404` for every permission failure unless resource-hiding is a deliberate policy.

---

## Permission Checks

Provide explicit permission checks.

Example:

```go
func (i Identity) HasPermission(permission string) bool {
	_, ok := i.Permissions[permission]
	return ok
}
```

Application use cases may enforce:

```go
if !identity.HasPermission("articles:publish") {
	return ErrForbidden
}
```

Do not scatter raw role-name comparisons throughout the codebase.

Do not accept permission names sent by the frontend.

---

## Resource-Level Authorization

Some actions require more than a global permission.

Examples:

* an editor may update only drafts they own;
* an administrator may update any article;
* a member may update only their profile;
* a user may access only their own private progress data.

Authorization may consider:

* permission;
* ownership;
* resource status;
* organization scope if introduced;
* account status.

Do not implement only endpoint-level authorization when object-level checks are required.

---

## Authorization Policies

When rules become nontrivial, use named policies.

Examples:

```text
CanEditArticle
CanPublishArticle
CanManageUser
CanUpdateOwnProfile
```

A policy may evaluate:

* identity;
* resource;
* requested action;
* current state.

Keep policies in the application or domain boundary.

Do not place policy logic only in React components or route middleware.

---

## Account Status

Potential statuses:

```text
active
disabled
pending
blocked
deleted
```

Do not introduce all statuses without a real lifecycle requirement.

At minimum, the application should be capable of rejecting disabled local users even when the identity-provider token is valid, if local disabling is part of the product.

Document the source of truth for account status.

---

## Registration

Initial registration should be handled by the identity provider.

Possible flow:

1. user opens registration;
2. frontend redirects to Keycloak;
3. user creates account;
4. provider confirms email if configured;
5. user authenticates;
6. backend receives a valid token;
7. backend creates or synchronizes the local user record.

Do not build custom password registration endpoints in the Go backend when Keycloak owns credentials.

---

## Just-in-Time User Provisioning

A local user record may be created on first authenticated request.

This is just-in-time provisioning.

Requirements:

* use provider subject as the stable external key;
* avoid duplicate creation;
* use a unique database constraint;
* update allowed profile fields;
* handle concurrent first requests;
* preserve local roles and application state.

Do not overwrite local administrative roles based only on user-controlled claims.

---

## User Synchronization

Synchronize only required fields.

Potential synchronized fields:

* email;
* display name;
* email verification;
* provider metadata.

Decide whether the provider or application owns each field.

Example:

```text
provider owns email
application owns editorial roles
user owns optional display preferences
```

Do not overwrite user-editable local profile fields on every login unless that is the intended policy.

---

## Role Synchronization

Choose one strategy deliberately.

### Strategy A — Roles from the application database

Token identifies the user.

Backend loads application roles and permissions locally.

Advantages:

* provider-neutral;
* easy application-level management;
* reduced coupling.

Trade-off:

* database lookup or caching.

### Strategy B — Roles from token claims

Provider issues application roles.

Advantages:

* fewer local authorization lookups.

Trade-offs:

* provider coupling;
* propagation delay;
* administrative synchronization complexity.

### Recommended Initial Direction

Use the identity provider for authentication and the application database for application roles and permissions.

Keycloak may contain coarse roles for local development, but backend authorization should not be irreversibly coupled to Keycloak realm-role claim formats.

Document the final choice through an ADR.

---

## Permission Caching

Do not add permission caching prematurely.

If introduced, define:

* cache key;
* TTL;
* invalidation after role changes;
* disabled-account behavior;
* fallback on cache failure;
* security impact.

Never allow stale cached permissions to persist indefinitely.

For the initial scale, a database lookup with appropriate indexing may be sufficient.

---

## Keycloak Local Configuration

The local Keycloak setup should be reproducible.

Recommended structure:

```text
infrastructure/keycloak/
├── realm-export.json
├── themes/
└── README.md
```

Or an initialization script if preferred.

Configure:

* realm;
* frontend client;
* backend audience or resource;
* redirect URIs;
* logout URIs;
* web origins;
* roles;
* test users;
* email behavior;
* local-only credentials.

Do not require manual configuration after every reset.

---

## Keycloak Realm

Use a project-specific realm.

Example:

```text
reptile-archive
```

Do not use the `master` realm for application users.

The `master` realm is administrative.

---

## Frontend Client

The React frontend is a public client.

Use:

* Authorization Code Flow;
* PKCE;
* no client secret in browser;
* exact redirect URIs;
* exact web origins.

Do not put a confidential client secret in React environment variables.

Anything in frontend code is public.

---

## Backend API Audience

Access tokens should be intended for the backend API.

Configure a stable API audience or client identifier.

The backend must reject tokens intended only for unrelated clients.

Do not skip audience checks merely because local configuration is inconvenient.

---

## Redirect URIs

Use exact redirect URIs where possible.

Local examples:

```text
http://localhost:3000/*
```

A wildcard may be acceptable locally but should be narrowed in real environments.

Production redirect URIs must not use broad wildcards.

Do not allow arbitrary post-login redirect targets.

---

## Web Origins and CORS

Keycloak web origins and backend CORS must be configured consistently.

Local example:

```text
http://localhost:3000
```

Do not use unrestricted `*` origins with credentials.

CORS is not an authorization mechanism.

---

## Local Users

Local initialization may create:

* one administrator;
* one editor;
* one member.

Use clearly local-only credentials from environment variables or local realm import values.

Document them in local setup instructions.

Never reuse local credentials in real environments.

Never commit real personal credentials.

---

## Keycloak Administrative Credentials

Keycloak bootstrap administrator credentials are local infrastructure credentials.

Store them in `.env`.

Use placeholders in `.env.example`.

Do not expose them to the frontend.

Do not use the Keycloak admin account as an application user.

---

## Future Cognito Compatibility

The architecture should support Cognito by replacing provider adapters and infrastructure configuration.

Potential differences to isolate:

* issuer structure;
* audience or client ID claims;
* groups claim;
* custom attributes;
* confirmation flow;
* logout behavior;
* hosted UI configuration;
* refresh behavior.

Do not build a false universal abstraction that hides all provider differences.

Abstract only what the application needs:

* token verification;
* identity mapping;
* authentication redirects in the frontend;
* logout;
* account lifecycle integration.

---

## Frontend Authentication

The frontend may use an OIDC client library.

Before adding one, evaluate:

* maintenance;
* PKCE support;
* token storage strategy;
* silent renewal;
* logout;
* callback handling;
* bundle impact;
* Keycloak and Cognito compatibility.

Do not implement OAuth protocol details manually unless necessary.

Do not add multiple authentication libraries.

---

## Frontend Session Model

Expose a typed session state.

Example:

```ts
type AuthStatus =
  | "loading"
  | "anonymous"
  | "authenticated"
  | "error";
```

Session data may include:

```ts
interface AuthSession {
  subject: string;
  email?: string;
  displayName?: string;
  roles: string[];
  permissions: string[];
}
```

The UI may use permissions for presentation.

The backend remains authoritative.

---

## Token Storage

Prefer secure, standards-aligned storage.

Potential browser strategies:

### In-memory access token

Reduces persistence exposure.

Requires session restoration or refresh strategy.

### Provider-managed session plus authorization-code flow

Preferred where supported.

### HTTP-only secure cookies

Requires a backend-for-frontend or server-side session design.

Do not store long-lived access or refresh tokens in `localStorage` without an explicit security decision.

Do not expose refresh tokens to unnecessary application code.

---

## Token Refresh

Refresh behavior must be controlled by the OIDC integration.

Requirements:

* avoid infinite refresh loops;
* handle expired sessions;
* handle revoked sessions;
* retry the original request only when safe;
* return the user to sign-in when recovery fails.

Do not refresh independently for every concurrent request.

Use a single-flight or library-managed strategy when needed.

---

## Logout

Logout may require:

* clearing local session state;
* clearing in-memory tokens;
* redirecting to the provider logout endpoint;
* specifying an allowed post-logout URI;
* invalidating server-side session state if introduced.

Do not implement logout as only deleting a frontend variable while the provider session remains active, unless that behavior is intentionally documented.

---

## Protected Frontend Routes

Frontend route protection improves user experience.

It may:

* wait for authentication state;
* redirect anonymous users;
* show forbidden state;
* preserve intended destination.

It must not replace backend authorization.

Do not render protected content before session resolution if that causes data leakage.

---

## Permission-Based UI

Use helpers such as:

```tsx
<RequirePermission permission="articles:create">
  <CreateArticleButton />
</RequirePermission>
```

Or explicit hooks:

```ts
const canPublish = usePermission("articles:publish");
```

Keep helpers simple.

Do not hide all permission logic behind opaque abstractions.

When an action is unavailable, decide whether to:

* hide it;
* disable it with explanation;
* show a permission message.

Choose based on usability and security context.

---

## Profile Updates

A member may update only application-owned profile fields.

Do not allow clients to update:

* roles;
* permissions;
* external subject;
* identity provider;
* account status;
* administrative metadata.

Use explicit request DTOs.

Protect against mass assignment.

---

## Role Management

Role assignment is an administrative operation.

Requirements:

* `users:manage` or a narrower permission;
* backend enforcement;
* audit record;
* prevention of invalid role names;
* transaction safety;
* self-demotion considerations;
* last-administrator protection when relevant.

Do not implement complex administrator safety rules before needed, but identify them before production.

---

## Self-Privilege Escalation

Prevent users from assigning themselves higher privileges unless explicitly allowed.

Do not accept role or permission fields in general profile requests.

Do not trust hidden frontend fields.

Use separate administrative endpoints and DTOs.

---

## Account Recovery

Keycloak owns password recovery locally.

The frontend should redirect users to the provider-supported recovery flow.

Do not implement custom recovery tokens in the application database unless the architecture changes.

Do not reveal whether an email address exists through application error messages.

---

## Email Confirmation

The identity provider owns email verification.

The application may use an `email_verified` claim.

Decide whether unverified users may access the application.

Possible policy:

* allow login but restrict selected actions;
* deny application access until verified.

Document and test the chosen behavior.

Do not rely on a frontend-only email verification check.

---

## Multi-Factor Authentication

MFA is a future security capability.

Do not implement custom MFA in the application.

Use identity-provider capabilities.

The architecture should not prevent future provider-managed MFA.

---

## Service-to-Service Authentication

Do not introduce service-to-service authentication during the modular-monolith phase without a concrete requirement.

Future workers within the same deployment may use internal application boundaries rather than public HTTP authentication.

If external automation is introduced, consider:

* client credentials;
* dedicated service accounts;
* scoped permissions;
* audience validation;
* secret rotation.

Do not reuse personal user credentials for automation.

---

## CSRF

CSRF risk depends on token transport.

### Bearer token in Authorization header

Classic CSRF risk is reduced, but XSS remains critical.

### Cookie-based authentication

Requires CSRF protections such as:

* SameSite policy;
* anti-CSRF tokens;
* origin checks.

Do not claim CSRF is universally irrelevant.

Document the final session architecture.

---

## XSS and Authentication

XSS can expose tokens and authenticated actions.

Requirements:

* do not render untrusted HTML;
* use Content Security Policy when appropriate;
* avoid unsafe token storage;
* validate redirect targets;
* sanitize editorial content;
* minimize token exposure.

Authentication design must be reviewed alongside frontend content rendering.

---

## Open Redirect Protection

Login and logout flows may preserve a return path.

Allow only:

* relative application paths;
* explicitly allowlisted origins.

Do not redirect to arbitrary user-supplied URLs.

Example safe validation:

```text
/profile
/articles/example
```

Reject:

```text
https://attacker.example
//attacker.example
```

---

## CORS

Backend CORS should allow only configured origins.

Local example:

```text
http://localhost:3000
```

Configure:

* allowed origins;
* allowed methods;
* allowed headers;
* exposed correlation headers when needed;
* credentials only if required.

Do not use `Access-Control-Allow-Origin: *` with credentials.

Do not treat CORS as API security.

---

## Rate Limiting

Consider rate limiting for:

* authentication callback abuse;
* profile update;
* role management;
* activity-event submission;
* recovery-related application endpoints if any.

The identity provider should protect its own login flows.

Do not rate-limit every authenticated read endpoint indiscriminately.

Use identity, IP, endpoint, and threat context appropriately.

---

## Error Handling

Authentication errors must be safe and consistent.

Suggested categories:

```text
missing_credentials
invalid_credentials
expired_token
invalid_issuer
invalid_audience
account_disabled
forbidden
```

Public API responses should not expose cryptographic or provider-internal details.

Example:

```json
{
  "type": "unauthenticated",
  "title": "Authentication required",
  "status": 401,
  "detail": "A valid access token is required."
}
```

Log internal diagnostic detail safely.

Do not log raw tokens.

---

## Logging

Authentication logs may include:

* correlation ID;
* provider;
* subject when verified and safe;
* outcome;
* failure category;
* route;
* permission name;
* actor ID for role changes.

Do not log:

* raw token;
* authorization header;
* refresh token;
* password;
* recovery code;
* client secret;
* complete JWT claims.

Avoid logging invalid-token failures as critical system errors unless they indicate infrastructure failure.

---

## Audit Events

Audit important authorization changes.

Examples:

* role assigned;
* role removed;
* account disabled;
* account re-enabled;
* administrator action;
* publishing action.

An audit event may include:

* actor;
* target;
* action;
* timestamp;
* correlation ID;
* safe metadata.

Do not store secret values or full request payloads.

---

## Database Modeling

Potential tables:

```text
users
roles
permissions
user_roles
role_permissions
```

An initial simplified model may use:

```text
users
roles
user_roles
```

with permissions mapped in code or seed configuration.

Choose based on current management requirements.

Do not create fully dynamic permission administration before needed.

---

## Suggested User Table

Directional example:

```sql
CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  identity_provider text NOT NULL,
  external_subject text NOT NULL,
  email text NOT NULL,
  display_name text,
  account_status text NOT NULL DEFAULT 'active',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  last_login_at timestamptz,
  UNIQUE (identity_provider, external_subject)
);
```

Evaluate email normalization and uniqueness carefully.

Do not assume email is globally unique across identity providers unless that is a product rule.

---

## Suggested Role Tables

Directional example:

```sql
CREATE TABLE roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  description text,
  created_at timestamptz NOT NULL DEFAULT now()
);
```

```sql
CREATE TABLE user_roles (
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role_id uuid NOT NULL REFERENCES roles(id) ON DELETE RESTRICT,
  assigned_by uuid REFERENCES users(id),
  assigned_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, role_id)
);
```

Do not add a surrogate ID to a pure join table without a reason.

---

## Role Seed Data

Seed these roles locally:

```text
member
editor
administrator
```

`visitor` is typically an anonymous state rather than a persisted role.

Use deterministic role IDs if helpful for local seeds.

Do not assign administrator to every local user.

---

## API Guidance

Potential authenticated endpoints:

```text
GET /api/v1/me
PATCH /api/v1/me
```

Potential administrative endpoints:

```text
GET /api/v1/admin/users
PATCH /api/v1/admin/users/{id}/roles
```

Authentication-provider redirects may remain frontend-driven.

Do not create backend password endpoints when credentials are provider-owned.

---

## `/me` Endpoint

`GET /api/v1/me` may return:

* internal user ID;
* external subject only if needed;
* email;
* display name;
* roles;
* permissions;
* account status;
* profile metadata.

Do not return raw token claims.

Do not expose provider secrets or internal administrative notes.

---

## Local Development

Local authentication must be reproducible through Docker Compose.

Expected services:

* Keycloak;
* PostgreSQL;
* backend;
* frontend;
* Mailpit when Keycloak email is configured.

Local setup should support:

```bash
make up
make auth-seed
make auth-reset
```

Only add commands that the project actually implements.

Document URLs and local users.

Do not require developers to click through manual realm configuration on every reset.

---

## Keycloak Health Checks

Docker Compose should wait for Keycloak readiness before dependent flows are tested.

Do not rely only on container process existence.

Use a supported health or readiness endpoint when available.

Avoid brittle sleep-based initialization when a real health check is possible.

---

## Realm Import Safety

A realm import may contain local-only passwords and client settings.

Mark it clearly as development configuration.

Do not reuse the same file directly in production.

Do not commit production client secrets.

---

## Terraform and Cognito

The future Terraform authentication module may create:

* Cognito user pool;
* application client;
* hosted UI domain;
* callback URLs;
* logout URLs;
* groups;
* email settings;
* password policy;
* MFA configuration;
* outputs for frontend and backend.

Do not create real Cognito resources during the local-only phase unless explicitly instructed.

Do not store sensitive client secrets in Terraform outputs unnecessarily.

---

## Testing Strategy

Authentication requires tests at multiple levels.

### Unit Tests

Test:

* claim mapping;
* permission checks;
* authorization policies;
* return-path validation;
* account-status rules;
* role-to-permission mapping.

### Middleware Tests

Test:

* missing authorization header;
* malformed Bearer header;
* invalid token;
* expired token;
* wrong issuer;
* wrong audience;
* valid token;
* identity context;
* safe error responses.

### Application Tests

Test:

* forbidden actions;
* permitted actions;
* ownership rules;
* disabled account;
* self-profile updates;
* role assignment.

### Integration Tests

Test:

* local user provisioning;
* database role lookup;
* Keycloak-issued token against backend;
* user synchronization;
* protected endpoint access.

### End-to-End Tests

Critical future flows:

* registration;
* login;
* logout;
* profile access;
* editor access;
* administrator role management;
* session expiration.

Do not mock all authorization layers in tests intended to validate access control.

---

## Test Tokens

For unit tests, use controlled signing keys and locally generated test tokens.

Do not use production tokens.

Do not commit long-lived real tokens.

Integration tests may request tokens from the local Keycloak instance using test users when appropriate.

Keep test credentials local and documented.

---

## Authorization Test Matrix

For every protected use case, define a matrix.

Example:

| Actor         | Create article | Update own draft | Publish article | Manage users |
| ------------- | -------------: | ---------------: | --------------: | -----------: |
| Visitor       |             No |               No |              No |           No |
| Member        |             No |               No |              No |           No |
| Editor        |            Yes |              Yes |              No |           No |
| Administrator |            Yes |              Yes |             Yes |          Yes |

Update this matrix when permissions change.

Do not rely on assumptions.

---

## Security Review Checklist

Before completing authentication work, verify:

### Token validation

* signature is verified;
* issuer is restricted;
* audience is restricted;
* expiration is checked;
* algorithms are restricted;
* JWKS caching is safe.

### Session

* tokens are stored safely;
* refresh does not loop;
* logout clears local state;
* redirects are allowlisted.

### Authorization

* backend enforcement exists;
* object-level checks exist where required;
* default behavior denies access;
* role changes are audited;
* self-escalation is prevented.

### Data

* passwords are not stored;
* raw tokens are not logged;
* personal data is minimized;
* provider subject is stable.

### Local environment

* realm setup is reproducible;
* local credentials are clearly local;
* no production secret is committed;
* redirect URIs and origins are constrained.

---

## Documentation Requirements

When authentication changes, evaluate updates to:

```text
README.md
docs/architecture/
docs/adr/
docs/development/
docs/runbooks/
docs/api/
infrastructure/keycloak/README.md
```

Recommended ADRs:

```text
Use Keycloak locally and Cognito on AWS
Store application roles in PostgreSQL
Use Authorization Code Flow with PKCE
Use provider-neutral backend identity abstraction
```

Document:

* realm name;
* local clients;
* local users;
* redirect URIs;
* role mapping;
* permission matrix;
* token validation;
* environment variables;
* troubleshooting.

Do not leave access-control rules undocumented.

---

## Environment Variables

Potential backend variables:

```text
AUTH_ISSUER_URL
AUTH_AUDIENCE
AUTH_JWKS_URL
AUTH_PROVIDER
AUTH_REQUIRED_EMAIL_VERIFIED
```

Potential frontend variables:

```text
VITE_AUTH_ISSUER_URL
VITE_AUTH_CLIENT_ID
VITE_AUTH_REDIRECT_URI
VITE_AUTH_POST_LOGOUT_REDIRECT_URI
```

Potential Keycloak variables:

```text
KEYCLOAK_ADMIN
KEYCLOAK_ADMIN_PASSWORD
KEYCLOAK_REALM
```

Names may evolve.

Centralize and validate configuration.

Do not expose backend secrets through `VITE_` variables.

---

## Implementation Workflow

When using this skill:

1. identify the actor and protected action;
2. identify authentication and authorization boundaries;
3. inspect current provider configuration;
4. define token requirements;
5. define internal identity mapping;
6. define roles and permissions;
7. define application authorization policy;
8. define persistence impact;
9. define frontend session behavior;
10. define local Keycloak changes;
11. add tests;
12. validate protected flows;
13. update documentation.

Implement the smallest complete security boundary needed for the current phase.

---

## Expected Deliverables

Depending on the task, deliverables may include:

* Keycloak realm configuration;
* OIDC frontend configuration;
* JWT verifier;
* identity mapper;
* authentication middleware;
* authorization policies;
* role and permission models;
* user provisioning;
* protected routes;
* profile endpoints;
* frontend auth provider;
* route guards;
* tests;
* documentation;
* ADRs.

Do not implement unrelated account features.

---

## Definition of Done

An authentication task is complete only when:

* the authentication flow is explicit;
* token validation is complete;
* issuer and audience are checked;
* internal identity is provider-neutral;
* backend authorization is enforced;
* role and permission rules are documented;
* object-level checks are implemented when needed;
* local Keycloak setup is reproducible;
* frontend session behavior is safe;
* tests cover success and failure paths;
* no password or raw token is stored improperly;
* no secret is committed;
* documentation is updated;
* validation results are reported honestly.

---

## Prohibited Practices

Do not:

* implement custom password storage;
* trust frontend role checks;
* decode JWTs without verifying them;
* skip issuer validation;
* skip audience validation;
* accept unsigned tokens;
* accept arbitrary algorithms;
* log raw tokens;
* store passwords in the application database;
* store long-lived tokens in `localStorage` without an explicit decision;
* expose client secrets in React;
* use email as the only stable identity key;
* allow profile requests to change roles;
* accept permission names from clients as authorization evidence;
* hardcode provider-specific claims throughout the application;
* configure unrestricted production redirect URIs;
* use wildcard CORS with credentials;
* implement authentication only in middleware without application authorization;
* create real Cognito resources without explicit authorization;
* declare access control complete without testing forbidden paths.

---

## Completion Report

After completing an authentication task, report:

```markdown
## Authentication scope

## Identity provider changes

## Token validation

## Identity mapping

## Roles and permissions

## Backend authorization

## Frontend session behavior

## Persistence changes

## Security considerations

## Tests

## Validation performed

## Documentation updates

## Limitations
```

Keep the report factual and based on actual work performed.

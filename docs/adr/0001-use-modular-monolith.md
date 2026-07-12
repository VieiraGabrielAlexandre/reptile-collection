# ADR-0001: Use a Modular Monolith

## Status

Accepted

## Context

The platform needs an architecture that supports evolutionary growth (foundation → public catalog → authentication → administration → advanced editorial → gamification → AWS deployment) without introducing premature operational complexity. A distributed, microservices-based architecture would require independent deployment, service discovery, distributed transactions, and network-boundary concerns that this project does not currently need.

## Decision

The backend is a single Go application structured as a **modular monolith**. The API is organized into modules — `taxonomy`, `species`, `articles`, `media`, `users`, `authentication`, `administration`, `gamification`, `search`, `platform` — each of which may contain `domain/`, `application/`, `infrastructure/`, and `transport/` layers, created only when a layer has real responsibility. Modules must not depend on each other's internals; the domain layer must not depend on HTTP, PostgreSQL, Redis, AWS, Keycloak, or Cognito.

## Consequences

Positive:

* one deployable unit, simple local development, and a single database connection pool;
* module boundaries are enforced in code review rather than by network calls;
* migration to extracted services remains possible later if a module's operational needs diverge significantly.

Negative:

* module boundaries require discipline, since there is no network boundary forcing separation;
* a poorly maintained boundary can degrade into a big ball of mud without ongoing review.

## Alternatives Considered

* **Microservices** — rejected as premature; the current scale and team size do not justify the operational overhead, and `CLAUDE.md` explicitly prohibits transforming the application into microservices.
* **Single unstructured application (no module boundaries)** — rejected because it would make the domain and future extraction harder to reason about.

## Related Decisions

None yet.

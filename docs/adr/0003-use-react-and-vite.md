# ADR-0003: Use React and Vite

## Status

Accepted

## Context

The frontend needs a mature, widely supported component model capable of delivering an editorial, accessible, responsive reading experience for the public catalog, and later an administrative editorial interface. It also needs a fast local development loop and a straightforward production build.

## Decision

Use **React** with **TypeScript** and **Vite** as the frontend stack, together with React Router, TanStack Query, React Hook Form, Zod, and Tailwind CSS.

## Consequences

Positive:

* Vite provides fast local development (HMR) and a simple, standard production build;
* TanStack Query centralizes server-state handling (loading, caching, retries) instead of ad hoc data fetching in components;
* Zod plus React Hook Form gives typed, validated forms with a single source of truth for validation shape;
* Tailwind CSS supports a consistent, token-based design system.

Negative:

* React's flexibility requires explicit project conventions (feature-oriented structure, component ownership) to avoid inconsistency — addressed in the `react-frontend` and `ux-design-system` skills;
* a build step is required for both development and production (no zero-build option).

## Alternatives Considered

* **A meta-framework with server-side rendering** (e.g. Next.js-style) — deferred; the initial phases favor a straightforward SPA behind a versioned JSON API. This may be revisited if SEO or performance requirements demand server rendering.
* **A different frontend framework** (Vue, Svelte) — rejected; React has the largest ecosystem overlap with the project's accessibility and component-library needs.

## Related Decisions

None yet.

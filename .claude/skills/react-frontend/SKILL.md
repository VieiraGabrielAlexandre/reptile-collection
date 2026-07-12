---

name: react-frontend
description: Defines frontend engineering standards for the reptile knowledge platform. Use this skill for React, TypeScript, Vite, routing, API integration, forms, state management, accessibility, responsive layouts, editorial pages, component design, testing, and frontend performance.
when_to_use: Use whenever a task creates, changes, reviews, debugs, or tests React pages, components, routes, forms, data fetching, API clients, frontend architecture, responsive behavior, accessibility, or user interface states.
argument-hint: "[frontend-task-or-feature]"
disable-model-invocation: false
user-invocable: true
model: inherit
effort: high
paths:

* "apps/web/**/*.{ts,tsx,js,jsx,css}"
* "apps/web/package.json"
* "apps/web/vite.config.*"
* "apps/web/tailwind.config.*"
* "apps/web/tsconfig*.json"
* "apps/web/public/**"
* "test/e2e/**"

---

# React Frontend

## Objective

Define and enforce frontend engineering standards for the reptile knowledge platform.

Use this skill to guide implementation of:

* React applications;
* TypeScript code;
* routes;
* layouts;
* pages;
* components;
* API integration;
* forms;
* validation;
* authentication flows;
* responsive behavior;
* accessibility;
* editorial interfaces;
* user feedback states;
* frontend testing;
* performance;
* maintainability.

The current task is:

```text
$ARGUMENTS
```

If no arguments were provided, infer the task from the current conversation.

---

## Mandatory Context

Before changing frontend code:

1. Read `${CLAUDE_PROJECT_DIR}/CLAUDE.md`.
2. Read the relevant domain and UX skills.
3. Inspect the current frontend structure.
4. Inspect related routes, pages, components, hooks, and tests.
5. Inspect the API contract when backend data is involved.
6. Identify the current project phase.
7. Identify the user role and primary user journey.
8. Identify loading, empty, error, success, unauthorized, and not-found states.
9. Preserve existing conventions unless there is a documented reason to change them.

Do not assume the frontend is empty.

Do not redesign unrelated areas while implementing a focused feature.

---

## Official Frontend Stack

Use:

* React;
* TypeScript;
* Vite;
* React Router;
* TanStack Query;
* React Hook Form;
* Zod;
* Tailwind CSS;
* accessible UI primitives;
* Vitest;
* Testing Library;
* Playwright for critical flows.

Additional libraries must be justified.

Do not add a global state library before a concrete need exists.

Do not add a component library that conflicts with the visual identity or accessibility requirements.

---

## Frontend Architecture

Use a feature-oriented structure.

Recommended structure:

```text
apps/web/src/
├── app/
│   ├── router/
│   ├── providers/
│   ├── config/
│   └── styles/
├── components/
│   ├── ui/
│   ├── feedback/
│   ├── layout/
│   └── content/
├── features/
│   ├── home/
│   ├── species/
│   ├── articles/
│   ├── search/
│   ├── auth/
│   ├── profile/
│   └── admin/
├── hooks/
├── services/
├── types/
├── utils/
└── main.tsx
```

Feature folders may contain:

```text
feature-name/
├── api/
├── components/
├── hooks/
├── pages/
├── schemas/
├── types/
└── utils/
```

Only create directories that have real content and responsibility.

Do not create deeply nested structures without need.

---

## Separation of Responsibilities

### Pages

Pages are responsible for:

* route-level composition;
* layout selection;
* loading boundaries;
* not-found behavior;
* feature integration;
* SEO metadata when applicable.

Pages should not contain large amounts of reusable UI logic.

### Feature Components

Feature components are responsible for:

* domain-specific presentation;
* user interactions;
* orchestrating local feature behavior;
* composing shared UI components.

### Shared UI Components

Shared UI components are responsible for:

* reusable visual primitives;
* consistent interaction patterns;
* accessibility;
* design-system behavior.

Examples:

* `Button`;
* `Input`;
* `Dialog`;
* `Card`;
* `Badge`;
* `Pagination`;
* `Skeleton`;
* `Alert`;
* `EmptyState`.

Do not move a component into shared scope before it has multiple real consumers.

### Hooks

Hooks may encapsulate:

* reusable stateful behavior;
* TanStack Query integration;
* media queries;
* form orchestration;
* accessibility behavior.

Do not use hooks as generic dumping grounds.

### Services

Services may contain:

* API client configuration;
* request helpers;
* authentication integration;
* environment-based frontend configuration.

Do not put rendering logic into services.

---

## Component Design

Components should be:

* focused;
* composable;
* typed;
* accessible;
* predictable;
* easy to test;
* explicit about states.

Prefer small components with clear names.

Avoid excessively generic components with many conditional props.

Prefer:

```tsx
<SpeciesCard species={species} />
```

over:

```tsx
<Card
  variant="species"
  mode="compact"
  showImage
  showMeta
  item={species}
  renderFooter={...}
/>
```

Do not create a generic component system before real repetition exists.

---

## TypeScript

Use strict TypeScript.

Requirements:

* avoid `any`;
* prefer explicit domain types;
* narrow unknown values;
* type component props;
* type API responses;
* type form schemas;
* avoid unsafe assertions;
* avoid duplicating backend models without purpose.

Use `unknown` for untrusted data.

Example:

```ts
function isApiProblem(value: unknown): value is ApiProblem {
  return (
    typeof value === "object" &&
    value !== null &&
    "type" in value &&
    "status" in value
  );
}
```

Do not use `as` to silence type errors without validating assumptions.

---

## Domain Types

Frontend domain types must represent the API contract, not database structures.

Example:

```ts
export interface SpeciesSummary {
  id: string;
  slug: string;
  commonName: string;
  scientificName: string;
  summary: string;
  primaryImage?: MediaAssetSummary;
  editorialGroup: EditorialGroup;
}
```

Do not expose internal backend-only fields in UI types.

Do not reuse one oversized type for list, detail, edit, and create screens.

Prefer separate types when payloads have different responsibilities.

---

## Routing

Use React Router.

Routes should be grouped by responsibility.

Example:

```tsx
const router = createBrowserRouter([
  {
    element: <PublicLayout />,
    children: [
      { path: "/", element: <HomePage /> },
      { path: "/species", element: <SpeciesListPage /> },
      { path: "/species/:slug", element: <SpeciesDetailPage /> },
      { path: "/articles", element: <ArticleListPage /> },
      { path: "/articles/:slug", element: <ArticleDetailPage /> },
    ],
  },
]);
```

Future authenticated routes may include:

```text
/profile
/admin
/admin/species
/admin/articles
```

Do not register all routes inside one oversized component.

Use route-level code splitting when useful.

Do not create route guards that trust client-side roles as the only authorization mechanism.

Frontend route guards improve UX but do not replace backend authorization.

---

## Layouts

Use explicit layouts.

Possible layouts:

* `PublicLayout`;
* `AuthLayout`;
* `ProfileLayout`;
* `AdminLayout`;
* `ArticleLayout`.

Layouts may own:

* header;
* navigation;
* footer;
* breadcrumbs;
* sidebars;
* content width;
* route outlet;
* skip links.

Do not duplicate the global header and footer across pages.

Do not create a separate layout for minor visual differences that can be expressed through composition.

---

## API Client

Create a centralized API client.

Responsibilities:

* base URL;
* JSON headers;
* authentication token handling;
* correlation ID exposure when useful;
* error normalization;
* request cancellation;
* timeout policy when applicable.

Example:

```ts
export class ApiError extends Error {
  constructor(
    public readonly status: number,
    public readonly problem?: ApiProblem,
  ) {
    super(problem?.detail ?? "Unexpected API error");
  }
}
```

Do not call `fetch` independently in many components without shared behavior.

Do not hide every request behind overly generic abstractions.

Prefer feature-specific API functions.

Example:

```ts
export async function getSpeciesBySlug(
  slug: string,
  signal?: AbortSignal,
): Promise<SpeciesDetail> {
  return apiClient.get(`/api/v1/species/${slug}`, { signal });
}
```

---

## TanStack Query

Use TanStack Query for server state.

Use it for:

* fetching;
* caching;
* loading state;
* retries;
* request deduplication;
* invalidation;
* mutations.

Do not use it as a replacement for local UI state.

Query keys must be stable and structured.

Example:

```ts
export const speciesKeys = {
  all: ["species"] as const,
  lists: () => [...speciesKeys.all, "list"] as const,
  list: (filters: SpeciesFilters) =>
    [...speciesKeys.lists(), filters] as const,
  details: () => [...speciesKeys.all, "detail"] as const,
  detail: (slug: string) =>
    [...speciesKeys.details(), slug] as const,
};
```

Do not use ad hoc string query keys.

---

## Query Behavior

Configure retries deliberately.

Recommended behavior:

* do not retry `400`, `401`, `403`, or `404` by default;
* allow limited retries for transient server or network errors;
* avoid infinite retries;
* show meaningful feedback.

Use request cancellation through the query function signal.

Example:

```ts
useQuery({
  queryKey: speciesKeys.detail(slug),
  queryFn: ({ signal }) => getSpeciesBySlug(slug, signal),
});
```

Do not ignore stale data and refetch behavior.

---

## Local State

Use local component state for:

* dialogs;
* expanded sections;
* transient selection;
* simple filters;
* UI toggles.

Use URL state for:

* search query;
* pagination;
* sorting;
* shareable filters;
* selected tab when shareable.

Use context only for truly cross-cutting client state such as:

* authenticated session;
* theme;
* global notifications.

Do not create a global state store for simple feature-local state.

---

## Forms

Use React Hook Form and Zod.

Forms must support:

* typed values;
* client-side validation;
* backend validation errors;
* loading state;
* success feedback;
* focus management;
* accessible labels;
* disabled state;
* accidental double-submit prevention.

Example:

```ts
const speciesSchema = z.object({
  commonName: z.string().trim().min(1, "Common name is required."),
  scientificName: z.string().trim().min(1, "Scientific name is required."),
  summary: z.string().trim().min(20, "Summary is too short."),
});
```

The backend remains the source of truth.

Do not duplicate complex business rules only in the frontend.

---

## Form Error Handling

Map backend field errors to form fields.

Example:

```ts
for (const fieldError of problem.errors ?? []) {
  form.setError(fieldError.field as keyof FormValues, {
    type: "server",
    message: fieldError.message,
  });
}
```

Validate the field name before applying it.

Display non-field errors in a visible alert.

Do not show only a generic toast when the user can correct a specific field.

---

## Loading States

Every asynchronous screen must have an explicit loading state.

Use:

* skeletons;
* progress indicators;
* disabled controls;
* inline pending states.

Prefer skeletons that resemble final content.

Avoid large blank screens.

Do not use multiple competing loading indicators for the same operation.

For mutations, preserve user input while pending.

---

## Empty States

Empty states must explain:

* what is missing;
* why it may be missing;
* what action is available.

Example:

```text
No species were found for these filters.
Clear the filters or try another search term.
```

Do not display only “No data”.

Administrative empty states may include a create action when the user has permission.

---

## Error States

Error states must distinguish:

* network failure;
* validation failure;
* unauthorized;
* forbidden;
* not found;
* server failure;
* dependency unavailable.

Provide recovery actions when appropriate:

* retry;
* go back;
* sign in;
* clear filters;
* return home.

Do not expose technical stack traces or raw server errors.

Display correlation IDs only when useful for support.

---

## Not Found

Use dedicated not-found experiences for:

* unknown routes;
* missing species;
* missing articles;
* archived or unpublished resources.

Do not render a generic server-error page for `404`.

Public endpoints must not reveal unpublished resource details.

---

## Authentication UX

When authentication is introduced, the frontend may handle:

* redirect to identity provider;
* callback processing;
* session state;
* logout;
* token refresh through the chosen integration;
* protected navigation;
* role-aware UI.

Do not store long-lived access tokens in unsafe browser storage without an explicit security decision.

Do not trust role checks in the UI as authorization.

Hide or disable unavailable actions for usability, but rely on backend enforcement.

---

## Accessibility

Accessibility is mandatory.

Every UI change must evaluate:

* semantic HTML;
* keyboard navigation;
* visible focus;
* labels;
* instructions;
* contrast;
* heading hierarchy;
* landmarks;
* screen-reader text;
* form errors;
* dialog behavior;
* reduced motion;
* image alternative text.

Use native HTML elements whenever possible.

Prefer:

```tsx
<button type="button">Open filters</button>
```

over:

```tsx
<div role="button" tabIndex={0}>Open filters</div>
```

Do not remove focus outlines without providing a visible replacement.

---

## Skip Link

The public layout should provide a skip link.

Example:

```tsx
<a
  href="#main-content"
  className="sr-only focus:not-sr-only"
>
  Skip to main content
</a>
```

The main content should have:

```tsx
<main id="main-content" tabIndex={-1}>
```

Use focus behavior carefully after route navigation when necessary.

---

## Headings

Maintain a logical heading hierarchy.

Each page should generally have one primary `h1`.

Do not choose heading levels based only on visual size.

Use typography classes for appearance rather than skipping semantic levels.

---

## Images

All meaningful images require alternative text.

Decorative images should use:

```tsx
alt=""
```

Species images should include useful alt text, not file names.

Avoid redundant alt text such as:

```text
Image of a green sea turtle image
```

Prefer:

```text
Green sea turtle swimming above a seagrass bed
```

Image credits and licenses must be visible where required.

---

## Dialogs and Modals

Dialogs must support:

* focus trapping;
* initial focus;
* escape to close when safe;
* accessible title;
* accessible description when needed;
* focus restoration;
* background inert behavior.

Use a tested accessible primitive.

Do not build dialog focus management from scratch unless required.

Destructive actions should have explicit confirmation.

---

## Tables

Use tables only for tabular data.

Provide:

* headers;
* captions when useful;
* responsive behavior;
* accessible sorting controls.

Do not use tables for layout.

For mobile, consider:

* horizontal scrolling;
* reduced columns;
* card alternatives only when semantics remain understandable.

---

## Responsive Design

Design mobile-first.

Validate at least:

* narrow mobile;
* larger mobile;
* tablet;
* desktop;
* wide desktop.

Avoid fixed widths that cause overflow.

Use readable content widths for articles.

Recommended article text width should prioritize legibility rather than filling the full viewport.

Do not hide critical functionality on mobile.

Do not create separate mobile and desktop components unless behavior genuinely differs.

---

## Editorial Layout

The public platform should feel editorial and scientific.

Use:

* strong typographic hierarchy;
* generous spacing;
* high-quality imagery;
* readable line lengths;
* clear section separation;
* restrained decorative elements;
* scientific-name styling;
* references and metadata;
* subtle motion.

Avoid:

* dashboard-like public pages;
* excessive card grids;
* generic SaaS appearance;
* neon colors;
* cluttered sidebars;
* dense administrative styling on editorial content.

---

## Species Pages

A species detail page may contain:

* common name;
* scientific name;
* hero image;
* summary;
* taxonomy;
* geographic distribution;
* habitat;
* diet;
* behavior;
* reproduction;
* ecological importance;
* conservation;
* risk information;
* curiosities;
* gallery;
* references;
* related articles.

Use sections with clear headings.

Scientific names should render in italics.

Taxonomic values should be easy to scan.

Risk content must not dominate the page sensationally.

---

## Article Pages

An article page may contain:

* category or topic;
* title;
* subtitle;
* author;
* publication date;
* updated date;
* estimated reading time;
* cover image;
* table of contents;
* structured content;
* references;
* related species;
* related articles.

Article content must preserve readable line length.

Long pages should support meaningful navigation.

The table of contents should reflect headings in the content.

Do not render unsanitized HTML.

---

## Home Page

The home page should plan for:

* editorial hero;
* primary search;
* featured species;
* popular groups;
* recent articles;
* ecological importance section;
* registration call to action;
* footer.

The hero should communicate the platform purpose immediately.

Do not make the home page only a grid of cards.

---

## Search Experience

Search should support:

* query input;
* debounced behavior only when useful;
* explicit submit behavior when preferred;
* filter controls;
* result counts;
* resource-type labels;
* empty states;
* pagination;
* URL-synchronized state.

Do not make every keystroke produce uncontrolled network traffic.

Do not mix species and article results without identifying their types.

---

## Filters

Filters should:

* use domain labels;
* remain accessible;
* preserve URL state;
* support clear-all;
* indicate active filters;
* avoid overwhelming the user.

Mobile filters may use a dialog or drawer.

Desktop filters may use a sidebar or inline controls.

Do not create filters that the API cannot support.

---

## Pagination

Pagination must be:

* keyboard accessible;
* linked to URL state;
* clear about current page;
* disabled appropriately;
* compatible with server metadata.

Do not fetch unbounded datasets and paginate only in the browser.

Use stable query parameters.

---

## SEO

Public pages should support:

* unique title;
* meta description;
* canonical URL;
* Open Graph metadata;
* social image when available;
* semantic headings;
* structured data when justified.

Species pages may eventually use structured data such as `Taxon`-related concepts where standards and search-engine support justify it.

Do not invent structured-data properties.

Do not expose unpublished content in metadata.

---

## Environment Configuration

Frontend environment variables must use Vite-compatible naming.

Example:

```text
VITE_API_BASE_URL=http://localhost:8080
```

Centralize environment parsing.

Example:

```ts
const envSchema = z.object({
  VITE_API_BASE_URL: z.string().url(),
});

export const env = envSchema.parse(import.meta.env);
```

Do not read `import.meta.env` throughout the application.

Do not expose secrets in frontend environment variables.

Anything bundled into the frontend is public.

---

## Styling

Use Tailwind CSS consistently.

Create design tokens for:

* colors;
* spacing;
* typography;
* radius;
* shadows;
* content widths;
* transitions.

Prefer semantic tokens over raw one-off values.

Example concepts:

```text
background
foreground
surface
surface-muted
border
accent
accent-foreground
success
warning
danger
```

Do not hardcode arbitrary colors repeatedly across components.

Detailed visual rules belong to the `ux-design-system` skill.

---

## Class Management

Use a small class-composition helper when necessary.

Example:

```ts
cn("base-class", condition && "conditional-class")
```

Do not create complex styling abstractions that hide the rendered result.

Avoid excessively long class strings when extracting a component improves readability.

Do not extract a component solely to shorten Tailwind classes.

---

## Motion

Motion should be subtle and purposeful.

Use it for:

* state transitions;
* opening and closing;
* navigation context;
* feedback.

Respect reduced-motion preferences.

Do not animate large sections unnecessarily.

Do not use motion that delays access to content.

---

## Notifications

Use notifications for transient outcomes such as:

* saved successfully;
* upload completed;
* temporary failure;
* action completed.

Do not use toasts as the only presentation of critical errors.

Form errors should remain near fields.

Destructive or persistent errors should remain visible.

---

## Optimistic Updates

Use optimistic updates only when:

* rollback is reliable;
* the action is low-risk;
* user experience benefits;
* conflicts are manageable.

Appropriate examples may include:

* toggling a bookmark;
* updating a lightweight preference.

Avoid optimistic updates for:

* publishing;
* role assignment;
* destructive actions;
* complex content edits;
* media uploads.

---

## Performance

Optimize based on evidence.

Evaluate:

* route bundle size;
* large dependencies;
* unnecessary rerenders;
* image loading;
* query duplication;
* expensive derived state;
* long lists;
* blocking scripts.

Use:

* route-level lazy loading;
* image dimensions;
* responsive images;
* memoization only when useful;
* list virtualization only for large lists;
* bundle analysis when needed.

Do not use `useMemo` and `useCallback` everywhere automatically.

Do not prematurely virtualize small lists.

---

## React Rules

Follow React best practices.

Requirements:

* keep rendering pure;
* avoid side effects during render;
* clean up effects;
* use stable keys;
* avoid copying props into state without reason;
* derive values instead of duplicating state;
* avoid deeply nested prop drilling when composition solves it;
* do not use index as key for reorderable lists.

Effects should synchronize with external systems.

Do not use effects for calculations that can happen during render.

---

## Error Boundaries

Use error boundaries at meaningful application boundaries.

Possible boundaries:

* application root;
* public route layout;
* admin area;
* article editor.

Error boundaries should provide:

* safe fallback;
* recovery action;
* logging integration when available.

Do not use error boundaries to hide expected API errors.

---

## Content Rendering

Structured article content must be rendered through an explicit block registry.

Example:

```ts
const blockRenderers = {
  paragraph: ParagraphBlock,
  heading: HeadingBlock,
  image: ImageBlock,
  quote: QuoteBlock,
  curiosity: CuriosityBlock,
} satisfies Record<SupportedBlockType, ComponentType<BlockProps>>;
```

Each block type must have a validated schema.

Do not render arbitrary component names received from the API.

Do not use `dangerouslySetInnerHTML` for untrusted content.

---

## Admin Interfaces

Administrative pages should prioritize:

* clarity;
* validation;
* workflow visibility;
* save status;
* preview;
* revision safety;
* permission feedback.

Admin design may be denser than public content, but must remain accessible and consistent.

Do not expose actions the user cannot perform.

Do not rely only on disabled buttons to explain missing permissions.

---

## Unsaved Changes

For content editing, consider:

* dirty state;
* autosave only when explicitly designed;
* navigation warning;
* save confirmation;
* failure recovery;
* draft persistence.

Do not introduce autosave without conflict, retry, and status behavior.

Do not silently discard user content.

---

## Testing Strategy

Frontend testing should focus on user-visible behavior.

### Unit tests

Use for:

* pure utilities;
* schemas;
* data mapping;
* small state logic.

### Component tests

Use Testing Library for:

* rendering;
* user interactions;
* accessibility behavior;
* form validation;
* loading and error states;
* permission-based UI.

### Integration tests

Use for:

* page plus query behavior;
* form submission;
* API error mapping;
* routing behavior.

### End-to-end tests

Use Playwright for critical flows such as:

* public species navigation;
* article reading;
* search and filtering;
* login;
* administrative content creation;
* publishing.

Do not test implementation details such as internal component state.

---

## Testing Library

Prefer queries that reflect user behavior.

Recommended order:

1. `getByRole`;
2. `getByLabelText`;
3. `getByText`;
4. `getByTestId` only when necessary.

Example:

```ts
expect(
  screen.getByRole("heading", { name: "Green sea turtle" }),
).toBeVisible();
```

Do not select elements by CSS class in behavior tests.

---

## API Mocking in Tests

Use request-level mocking such as MSW when adopted.

Mock realistic API responses.

Test:

* success;
* empty;
* validation error;
* unauthorized;
* not found;
* server failure.

Do not mock TanStack Query itself.

Do not mock every internal hook.

---

## Accessibility Testing

Include automated accessibility checks where practical.

Also test manually important flows for:

* keyboard use;
* focus order;
* dialogs;
* forms;
* navigation;
* headings.

Automated tools do not replace manual accessibility review.

---

## Code Quality

Run:

```bash
npm run typecheck
npm run lint
npm run test
npm run build
```

For E2E changes:

```bash
npm run test:e2e
```

Use the package manager chosen by the repository consistently.

Do not mix npm, pnpm, and Yarn lockfiles.

Do not report commands as executed unless they were actually run.

---

## Dependency Management

Before adding a frontend dependency:

1. verify the platform or existing stack cannot solve the problem;
2. verify maintenance activity;
3. verify bundle impact;
4. verify accessibility;
5. verify license;
6. verify TypeScript support;
7. verify security;
8. justify adoption.

Do not add a large dependency for one small helper.

Do not add overlapping UI libraries.

---

## Security

Frontend changes must evaluate:

* XSS;
* unsafe HTML;
* token storage;
* open redirects;
* sensitive data exposure;
* CSRF depending on auth strategy;
* untrusted URLs;
* file upload validation;
* permission visibility;
* dependency risks.

Never place secrets in frontend code.

Do not trust client-side validation as security enforcement.

Sanitize or structurally render editorial content.

---

## Documentation

When frontend behavior changes, evaluate updates to:

```text
README.md
docs/product/
docs/architecture/
docs/development/
docs/api/
```

Document:

* routes;
* environment variables;
* setup;
* design decisions;
* accessibility behavior;
* component conventions;
* testing commands.

Do not leave significant frontend conventions only implicit in code.

---

## Implementation Workflow

When using this skill:

1. identify the user journey;
2. identify the route and layout;
3. inspect the API contract;
4. define all UI states;
5. define accessibility requirements;
6. design component boundaries;
7. define server and local state ownership;
8. implement the smallest complete vertical slice;
9. add tests;
10. validate responsiveness;
11. run quality commands;
12. update documentation.

---

## Expected Deliverables

Depending on the task, deliverables may include:

* routes;
* layouts;
* pages;
* components;
* hooks;
* API functions;
* query keys;
* forms;
* Zod schemas;
* state handling;
* responsive styles;
* accessibility improvements;
* tests;
* documentation.

Do not create unrelated UI areas.

---

## Definition of Done

A frontend task is complete only when:

* the requested user journey works;
* all relevant states are handled;
* TypeScript passes;
* lint passes;
* tests pass;
* build passes;
* accessibility is evaluated;
* mobile and desktop behavior are verified;
* API contracts are respected;
* unauthorized actions are not presented incorrectly;
* content is rendered safely;
* documentation is updated;
* no secret is exposed;
* no validation result is falsely claimed.

---

## Prohibited Practices

Do not:

* use `any` indiscriminately;
* silence errors with unsafe assertions;
* fetch directly in many unrelated components;
* create global state without need;
* duplicate server state in local state;
* place business rules in React components;
* use client-side permissions as authorization;
* render unsanitized HTML;
* ignore loading, empty, or error states;
* remove focus outlines without replacement;
* use non-semantic elements as controls;
* use headings only for visual styling;
* use index keys for reorderable data;
* create oversized components;
* create generic component abstractions prematurely;
* add overlapping UI libraries;
* expose frontend secrets;
* paginate only in the browser for server-owned datasets;
* hide critical errors only in toasts;
* declare completion without testing relevant behavior.

---

## Completion Report

After completing a frontend task, report:

```markdown
## Frontend scope

## User journey

## Routes and layouts

## Components and state

## API integration

## Accessibility

## Responsive behavior

## Tests

## Validation performed

## Documentation updates

## Limitations
```

Keep the report factual and based on actual work performed.

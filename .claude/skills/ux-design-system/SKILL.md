---

name: ux-design-system
description: Defines the visual, interaction, accessibility, and responsive design standards for the reptile knowledge platform. Use this skill for design tokens, typography, colors, spacing, components, layouts, navigation, editorial pages, admin interfaces, accessibility, responsiveness, visual consistency, and user experience reviews.
when_to_use: Use whenever a task creates, changes, reviews, or tests layouts, pages, components, navigation, visual hierarchy, responsive behavior, accessibility, interaction states, design tokens, editorial presentation, or administrative user experience.
argument-hint: "[ux-or-design-system-task]"
disable-model-invocation: false
user-invocable: true
model: inherit
effort: high
paths:

* "apps/web/src/**/*.{ts,tsx,css}"
* "apps/web/public/**"
* "apps/web/tailwind.config.*"
* "apps/web/src/app/styles/**"
* "apps/web/src/components/**"
* "apps/web/src/features/**"
* "docs/product/**"
* "docs/architecture/**"
* "docs/design/**"

---

# UX and Design System

## Objective

Define and enforce the visual, interaction, accessibility, and responsive design standards of the reptile knowledge platform.

Use this skill to guide:

* visual identity;
* design tokens;
* typography;
* color system;
* spacing;
* grids;
* layouts;
* navigation;
* shared components;
* editorial pages;
* administrative interfaces;
* interaction states;
* responsive behavior;
* accessibility;
* consistency;
* content hierarchy;
* user journeys;
* interface reviews.

The current task is:

```text
$ARGUMENTS
```

If no arguments were provided, infer the task from the current conversation.

---

## Mandatory Context

Before changing visual or interaction behavior:

1. Read `${CLAUDE_PROJECT_DIR}/CLAUDE.md`.
2. Read the `react-frontend`, `product-domain`, `content-editor`, `security`, and `testing-quality` skills when relevant.
3. Inspect the current design tokens.
4. Inspect existing components and layouts.
5. Inspect affected routes and user journeys.
6. Identify the current project phase.
7. Identify the target user.
8. Identify whether the interface is public, authenticated, editorial, or administrative.
9. Identify loading, empty, error, success, forbidden, and not-found states.
10. Identify keyboard and screen-reader requirements.
11. Preserve visual consistency unless a deliberate redesign is required.
12. Avoid changing unrelated visual areas.

Do not redesign the entire product while implementing a focused component.

Do not introduce a new design language without documenting the transition.

---

## Product Experience Principles

The platform should communicate:

* scientific credibility;
* curiosity;
* nature;
* preservation;
* discovery;
* editorial quality;
* clarity;
* calmness;
* trust.

The experience should not feel:

* childish;
* sensationalist;
* overly playful;
* generic;
* visually noisy;
* like a standard SaaS dashboard;
* like a pet store;
* like a zoo attraction;
* like a news portal overloaded with cards.

The platform is an editorial and educational archive.

Design decisions should support reading, discovery, and trust.

---

## Core UX Principles

Follow these principles:

* clarity before decoration;
* content before chrome;
* accessibility by default;
* mobile-first responsiveness;
* consistent interaction patterns;
* visible system status;
* predictable navigation;
* strong information hierarchy;
* progressive disclosure;
* restrained motion;
* readable editorial layouts;
* errors with recovery paths;
* empty states with guidance;
* permission-aware interfaces;
* no hidden critical functionality.

Do not add visual elements without a clear purpose.

Do not make users infer application state.

---

## Public vs Administrative Experience

The public and administrative interfaces have different priorities.

### Public Experience

Priorities:

* reading;
* discovery;
* navigation;
* visual storytelling;
* scientific context;
* trust;
* image quality;
* accessibility.

It may use:

* generous spacing;
* editorial typography;
* large imagery;
* wider composition;
* restrained interaction density.

### Administrative Experience

Priorities:

* clarity;
* efficiency;
* content status;
* validation;
* workflow;
* save state;
* permissions;
* error recovery.

It may use:

* denser layouts;
* tables;
* forms;
* side navigation;
* status indicators;
* action toolbars.

Do not make public article pages look like admin dashboards.

Do not make admin interfaces visually decorative at the expense of task clarity.

---

## Design System Ownership

The design system should define:

* colors;
* typography;
* spacing;
* sizing;
* radii;
* shadows;
* borders;
* motion;
* breakpoints;
* content widths;
* component variants;
* focus states;
* semantic states.

Avoid scattering arbitrary values across components.

Prefer reusable semantic tokens.

Do not create a complete enterprise design system before real components exist.

Build incrementally from actual interface needs.

---

## Token Categories

Recommended categories:

```text
color
typography
spacing
size
radius
shadow
border
motion
breakpoint
content-width
z-index
```

Tokens should be named semantically rather than by appearance alone.

Prefer:

```text
color-surface
color-surface-muted
color-text-primary
color-text-secondary
color-border
color-accent
color-success
color-warning
color-danger
```

Avoid:

```text
green-1
gray-7
blue-dark
pretty-shadow
```

Raw palette values may exist internally, but components should consume semantic tokens.

---

## Color Direction

The visual identity may draw from:

* deep forest tones;
* moss;
* stone;
* sand;
* mineral;
* dark water;
* muted earth;
* warm neutral backgrounds;
* restrained accent tones.

Avoid excessive saturated green.

The platform should not become monochromatic.

Use color to support hierarchy and state.

Do not use color as the only way to communicate meaning.

---

## Semantic Color Roles

Define at least:

```text
background
foreground
surface
surface-muted
surface-elevated
border
border-strong
accent
accent-hover
accent-foreground
link
focus
success
warning
danger
info
```

Potential dark-theme tokens may be introduced later.

Do not implement dark mode before it is requested or supported consistently.

---

## Contrast

Text and interactive elements must meet appropriate contrast expectations.

Verify:

* body text;
* secondary text;
* links;
* buttons;
* form borders;
* disabled controls;
* focus indicators;
* badges;
* overlays;
* text on images.

Do not use low-contrast muted text for essential information.

Do not place important text directly over busy images without a protective layer.

---

## Typography

Use a deliberate editorial pairing.

Potential roles:

### Display or Editorial Heading Font

Used for:

* hero titles;
* article titles;
* species names;
* major section headings.

### Interface and Body Font

Used for:

* paragraphs;
* navigation;
* forms;
* metadata;
* buttons;
* tables.

Choose fonts with:

* strong readability;
* appropriate language support;
* available weights;
* acceptable loading cost;
* clear licensing.

Do not use decorative fonts for body content.

Do not use too many font families.

---

## Typography Scale

Define a consistent scale.

Example roles:

```text
display
page-title
section-title
subsection-title
body-large
body
body-small
caption
label
code
```

Do not choose font sizes independently in every component.

Typography must adapt at breakpoints without abrupt jumps.

---

## Scientific Names

Scientific names must:

* render in italics;
* preserve correct capitalization;
* remain visually distinct from common names;
* not be transformed to uppercase;
* remain readable at small sizes.

Example:

```tsx
<em>Boa constrictor</em>
```

Do not rely only on color to distinguish scientific names.

---

## Reading Width

Editorial content should use a comfortable line length.

Recommended direction:

```text
approximately 60 to 75 characters per line
```

The article body should not stretch across very wide screens.

Use wider containers for:

* images;
* galleries;
* maps;
* comparison tables.

Do not force every block into the same narrow width.

---

## Spacing System

Use a consistent spacing scale.

Potential base progression:

```text
4
8
12
16
24
32
48
64
96
```

Exact values may follow Tailwind configuration.

Use spacing to express hierarchy.

Do not compensate for poor structure with random margins.

Do not use dozens of one-off spacing values.

---

## Border Radius

Use radius deliberately.

Potential roles:

```text
small
medium
large
pill
```

Public editorial surfaces may use subtle rounded corners.

Do not make every content section a heavily rounded card.

Do not use large radii on dense admin tables without purpose.

---

## Shadows

Use shadows sparingly.

Appropriate uses:

* dialogs;
* floating menus;
* elevated navigation;
* selected media;
* subtle card elevation.

Avoid heavy shadows around every surface.

The platform should feel editorial, not like a collection of floating panels.

---

## Borders

Borders may provide structure more effectively than shadows.

Use them for:

* cards;
* tables;
* input fields;
* section separation;
* blockquotes;
* metadata panels.

Use subtle but visible contrast.

Do not use borders on every nested element.

---

## Motion

Motion must be:

* subtle;
* fast;
* purposeful;
* interruptible;
* respectful of reduced motion.

Use motion for:

* state changes;
* menu opening;
* dialog transitions;
* accordion expansion;
* feedback;
* route continuity when appropriate.

Avoid:

* large parallax;
* decorative continuous animation;
* delayed content reveal;
* excessive entrance effects;
* motion that blocks interaction.

---

## Reduced Motion

Respect:

```css
@media (prefers-reduced-motion: reduce)
```

Reduce or disable non-essential motion.

Do not assume subtle animation is harmless to every user.

---

## Breakpoints

Use a mobile-first breakpoint strategy.

Typical categories:

```text
mobile
large-mobile
tablet
desktop
wide-desktop
```

Tailwind defaults may be used or adjusted deliberately.

Do not create many component-specific breakpoints.

Do not design only for common device presets.

Validate fluid behavior between breakpoints.

---

## Responsive Principles

On smaller screens:

* preserve primary content;
* reduce non-essential decoration;
* stack sections;
* keep controls reachable;
* avoid horizontal overflow;
* maintain readable typography;
* preserve critical actions;
* use drawers or dialogs for filters when needed.

Do not hide core features on mobile.

Do not shrink desktop layouts without rethinking hierarchy.

---

## Content Containers

Define content widths.

Possible roles:

```text
full-bleed
wide
standard
reading
narrow
```

Example usage:

* article text: reading;
* article image: wide;
* search results: standard;
* admin table: wide or full;
* auth form: narrow.

Do not hardcode max-width values repeatedly.

---

## Grid System

Use CSS Grid or Flexbox based on layout needs.

Examples:

* editorial cards: Grid;
* navigation: Flexbox;
* article body: block flow;
* species facts: Grid;
* admin forms: Grid.

Do not use tables for layout.

Do not use absolute positioning for normal responsive composition.

---

## Page Hierarchy

Each page should clearly communicate:

1. where the user is;
2. what the page is about;
3. what action is available;
4. what content is primary;
5. what content is secondary.

Avoid pages where hero, cards, sidebars, and calls to action compete equally.

One page should have one dominant visual objective.

---

## Public Navigation

The public header may include:

* logo;
* species;
* articles;
* categories;
* search;
* sign in;
* profile when authenticated.

Keep primary navigation concise.

Do not add every future feature to the header.

Mobile navigation must be keyboard accessible.

---

## Navigation States

Navigation should indicate:

* current route;
* hover;
* focus;
* expanded state;
* authenticated state;
* active filters when applicable.

Do not rely only on subtle color differences for the current route.

Use semantic attributes such as:

```text
aria-current="page"
```

---

## Skip Navigation

Provide a skip link to main content.

It should become visible on focus.

The main content must have a stable target.

Do not hide the skip link permanently.

---

## Breadcrumbs

Use breadcrumbs for hierarchical content when useful.

Good candidates:

* editorial group;
* species;
* article categories;
* admin hierarchy.

Do not use breadcrumbs on shallow pages where they add noise.

Use semantic navigation and ordered lists.

---

## Home Page

The home page should include:

1. editorial hero;
2. primary search;
3. featured species;
4. editorial groups;
5. recent or featured articles;
6. ecological importance section;
7. registration call to action;
8. informative footer.

The hero should explain the platform immediately.

Avoid vague marketing language.

Do not make the home page only a grid of cards.

---

## Hero Section

The hero may include:

* strong title;
* concise explanation;
* search;
* one primary call to action;
* one meaningful image or composition.

Do not include several competing primary buttons.

Do not use large background video.

Do not place unreadable text over complex imagery.

---

## Species Listing

The species listing should support:

* clear page title;
* concise introduction;
* search;
* filters;
* result count;
* sorting;
* cards or rows;
* pagination;
* empty state;
* active-filter summary.

Species cards may show:

* image;
* common name;
* scientific name;
* editorial group;
* short summary;
* conservation indicator when sourced.

Do not overload cards with full species details.

---

## Species Card

A species card should prioritize:

1. image;
2. common name;
3. scientific name;
4. concise contextual information.

It should be fully navigable.

Use one primary link pattern consistently.

Do not make every internal element a competing link.

Do not use hover-only information for essential content.

---

## Species Detail Page

A species detail page may contain:

* common name;
* scientific name;
* hero media;
* summary;
* scientific classification;
* distribution;
* habitat;
* diet;
* behavior;
* reproduction;
* ecological importance;
* risk context;
* conservation;
* curiosities;
* gallery;
* references;
* related articles.

Use progressive disclosure.

Do not present all information as identical cards.

Use section rhythm and varied editorial composition.

---

## Scientific Classification

Classification should be easy to scan.

Possible presentation:

* definition list;
* compact table;
* structured facts panel.

Use semantic markup.

Do not represent classification as decorative badges only.

Do not mix editorial groups into the scientific hierarchy.

---

## Conservation Presentation

Conservation status should show:

* status;
* authority;
* assessment date or year;
* explanatory context;
* source.

Avoid alarmist visuals.

Do not use a color badge without text.

Do not imply a global assessment applies locally without explanation.

---

## Risk Presentation

Risk content must be responsible and calm.

Use:

* explanatory text;
* context;
* high-level safety guidance;
* source-backed information.

Avoid:

* oversized red warnings;
* sensational icons;
* fear-based headlines;
* visual emphasis that overwhelms ecological context.

Do not present the species primarily through danger.

---

## Article Listing

Article cards may show:

* image;
* title;
* summary;
* category;
* date;
* reading time;
* related species count when useful.

Do not show every metadata field.

Keep titles and summaries readable.

---

## Article Page

The article page should include:

* topic or category;
* title;
* subtitle;
* author;
* date;
* updated date when relevant;
* reading time;
* cover image;
* table of contents;
* structured body;
* references;
* related species;
* related articles.

The body should remain the visual focus.

Do not surround every paragraph with containers.

---

## Article Header

The article header should establish:

* subject;
* tone;
* authorial context;
* reading commitment.

Keep metadata concise.

Do not let social-sharing controls dominate the header.

---

## Table of Contents

Use when an article is long enough.

Requirements:

* reflects actual headings;
* accessible links;
* visible focus;
* duplicate-heading handling;
* mobile behavior;
* current section indication only when useful.

Do not show an empty or trivial table of contents.

---

## Editorial Blocks

Each content block should have a clear visual role.

### Paragraph

Readable body typography.

### Heading

Strong hierarchy and spacing.

### Quote

Distinct but restrained.

### Curiosity

Visually identifiable, educational, not childish.

### Image

Includes caption and credit.

### Reference

Clear citation and source information.

Do not style every block as a card.

---

## Curiosity Block Design

A curiosity block may use:

* subtle accent;
* icon with accessible text;
* compact title;
* body text;
* restrained border or background.

Avoid cartoon-like styling.

Do not overuse curiosity blocks.

---

## Quote Design

Use a clear typographic treatment.

Possible elements:

* border;
* larger type;
* attribution;
* source link.

Do not use decorative quotation marks that reduce readability.

---

## Image Presentation

Images must support:

* responsive sizing;
* aspect ratio;
* alt text;
* caption;
* credit;
* loading behavior;
* error fallback.

Use width and height to reduce layout shift.

Do not crop scientifically relevant features without editorial control.

Do not use low-resolution images in large layouts.

---

## Gallery

A future gallery should support:

* keyboard navigation;
* accessible controls;
* captions;
* credits;
* thumbnails when useful;
* full-screen view only when accessible;
* touch support.

Do not create a carousel with autoplay.

Do not hide important captions.

---

## Search Experience

Search should feel central and reliable.

Support:

* clear label;
* placeholder as example, not replacement for label;
* submit behavior;
* search history only when privacy-reviewed;
* loading state;
* result count;
* no-result guidance;
* filters;
* keyboard use.

Do not trigger uncontrolled requests on every keystroke.

Do not store search terms without privacy review.

---

## Filter Design

Filters should be grouped logically.

Potential groups:

* editorial group;
* taxonomy;
* habitat;
* region;
* diet;
* conservation status;
* risk context.

Use domain language.

Do not expose technical database field names.

Mobile filters may use a drawer or dialog.

Desktop filters may use a sidebar.

---

## Active Filters

Show active filters visibly.

Support:

* removing one filter;
* clearing all;
* preserving URL state;
* result count updates.

Do not make users reopen the filter panel to understand active criteria.

---

## Pagination

Pagination should:

* identify current page;
* provide previous and next;
* expose page numbers when useful;
* preserve filters;
* work by keyboard;
* use real links when navigation is URL-based.

Do not create tiny click targets.

Do not load every result and paginate only visually.

---

## Authentication Pages

Authentication pages should be simple.

Potential content:

* platform identity;
* short explanation;
* sign-in or registration action;
* provider redirect;
* recovery support.

Do not create a custom password form when Keycloak owns authentication.

Do not imitate authentication UI that conflicts with the actual provider flow.

---

## Profile Page

The profile should prioritize:

* display information;
* account email;
* user role summary;
* future progress;
* sign-out;
* editable fields owned by the application.

Do not expose raw token claims.

Do not allow role editing through the regular profile interface.

---

## Registration Call to Action

The public registration call to action should explain future or current value.

Potential value:

* reading progress;
* collections;
* achievements;
* personalized experience.

Do not promise gamification features that do not yet exist.

Use honest product language.

---

## Admin Layout

The admin layout may include:

* top bar;
* side navigation;
* page title;
* breadcrumbs;
* primary action;
* status summary;
* content area.

Keep navigation focused.

Potential sections:

```text
Overview
Species
Articles
Media
Users
Taxonomy
```

Only show sections implemented in the current phase.

---

## Admin Dashboard

The dashboard should answer:

* what needs attention;
* what is in draft;
* what is awaiting review;
* what failed;
* what was recently published.

Do not fill the dashboard with vanity metrics.

Use actionable information.

---

## Admin Lists

Admin lists may use:

* tables;
* compact cards on mobile;
* filters;
* search;
* status;
* author;
* updated date;
* row actions.

Actions must be accessible.

Do not hide critical actions only in hover menus.

---

## Tables

Tables should have:

* semantic headers;
* caption when useful;
* sortable controls;
* clear row focus;
* responsive fallback;
* visible status;
* accessible actions.

Avoid excessive columns.

On mobile, consider:

* horizontal scrolling;
* prioritized columns;
* stacked row cards when semantics remain clear.

---

## Forms

Forms should provide:

* visible labels;
* help text;
* required indicators;
* field validation;
* server validation;
* grouped sections;
* logical tab order;
* save state;
* error summary when useful.

Do not use placeholders as labels.

Do not show validation only after submission when earlier feedback is useful.

---

## Form Layout

Use one-column forms for reading-intensive or complex content.

Use multi-column forms only for naturally related short fields.

Examples:

* size minimum and maximum;
* publication date and time;
* language and region.

Do not create wide dense grids for long text fields.

---

## Required Fields

Required fields should be clearly identified.

Do not rely only on an asterisk without explanation.

Avoid marking every field required.

Drafts may allow incomplete fields.

Publication readiness may impose stronger requirements.

---

## Validation Messages

Messages should explain:

* what is wrong;
* how to correct it;
* whether it blocks saving or publishing.

Prefer:

```text
Scientific name is required before publication.
```

Avoid:

```text
Invalid value.
```

Do not expose backend implementation details.

---

## Error Summary

For long forms, provide an error summary after failed submission.

It should:

* announce itself;
* list errors;
* link to fields;
* preserve user input;
* move focus appropriately.

Do not rely only on scattered red text.

---

## Save State

The interface should show:

```text
unsaved
saving
saved
save failed
conflict
```

when applicable.

Do not imply success before backend confirmation.

Do not hide failed saves in temporary toasts only.

---

## Status Indicators

Editorial statuses may use badges:

```text
Draft
In review
Scheduled
Published
Archived
```

Use:

* text;
* color;
* icon only when helpful.

Do not rely only on color.

Status colors should remain consistent across lists, details, and editor.

---

## Buttons

Define variants:

```text
primary
secondary
outline
ghost
danger
link
```

Use primary buttons sparingly.

A page should usually have one dominant primary action.

Do not use danger styling for ordinary cancellation.

Do not make text links look like disabled buttons.

---

## Button States

Support:

* default;
* hover;
* focus;
* active;
* disabled;
* loading.

Loading buttons should preserve width where practical.

Do not remove the button label and show only a spinner without accessible text.

---

## Icon Buttons

Icon-only buttons require accessible names.

Use tooltips as supplemental help, not as the only label for assistive technology.

Touch targets should be sufficiently large.

Do not use ambiguous icons.

---

## Links

Links should remain visually identifiable.

Do not remove underlines from inline body links unless another strong affordance exists.

External links should be identified only when helpful.

Do not force every external link to open in a new tab.

---

## Cards

Use cards only when content items are distinct.

Good uses:

* species previews;
* article previews;
* admin summary items;
* media assets.

Avoid turning:

* every article section;
* every fact;
* every paragraph

into a card.

Cards should not replace information hierarchy.

---

## Badges

Use badges for compact categorical information.

Examples:

* editorial status;
* editorial group;
* conservation category;
* content type.

Do not create a badge for every metadata value.

Avoid excessive visual noise.

---

## Alerts

Alert types may include:

```text
info
success
warning
danger
```

Use alerts for meaningful persistent messages.

Do not use danger alerts for normal informational content.

Alerts require:

* icon or label;
* text;
* appropriate role;
* action when relevant.

---

## Toasts

Use toasts for transient outcomes.

Examples:

* saved successfully;
* copied link;
* upload completed.

Do not use toasts as the only place for:

* validation errors;
* permission errors;
* destructive failures;
* unsaved-content failures.

---

## Dialogs

Dialogs must have:

* title;
* accessible description when needed;
* focus trap;
* escape handling;
* focus restoration;
* close control;
* clear actions.

Do not use dialogs for long complex workflows that deserve full pages.

Do not stack multiple dialogs.

---

## Drawers

Drawers may be useful for:

* mobile navigation;
* mobile filters;
* lightweight details.

They must preserve accessibility.

Do not use drawers as a universal replacement for page navigation.

---

## Confirmation

Destructive actions should clearly state:

* what will happen;
* what data is affected;
* whether it can be undone;
* the primary destructive action;
* safe cancellation.

Do not use vague confirmation text such as:

```text
Are you sure?
```

Prefer:

```text
Archive this article?
It will no longer appear in the public catalog.
```

---

## Empty States

An empty state should include:

* clear explanation;
* optional illustration or icon;
* next action;
* filter recovery when relevant.

Public example:

```text
No species matched these filters.
Try removing a filter or searching by scientific name.
```

Admin example:

```text
No article drafts yet.
Create the first draft to begin building the archive.
```

Do not use only “No data”.

---

## Loading States

Use loading states that preserve layout.

Options:

* skeleton;
* inline progress;
* button loading;
* page progress for route transitions.

Do not display a full-screen spinner for small local actions.

Do not cause large layout shifts.

---

## Skeletons

Skeletons should resemble final content.

Do not create skeletons with arbitrary decorative bars.

Respect reduced motion.

Avoid indefinite skeletons without error recovery.

---

## Error States

Error states should communicate:

* what failed;
* whether user action can recover;
* retry;
* navigation option;
* correlation ID when support may need it.

Do not show raw server messages.

Do not blame the user for system failures.

---

## Forbidden State

A forbidden state should explain that the user lacks permission.

Potential actions:

* return;
* switch account;
* contact administrator.

Do not render a blank page.

Do not expose restricted content details.

---

## Not Found State

A not-found page should provide:

* clear message;
* path back to catalog or home;
* search option;
* no internal technical details.

Species and articles may use contextual not-found pages.

Do not use a generic server-error style for missing content.

---

## Focus Management

Manage focus after:

* route changes when appropriate;
* dialog open and close;
* validation failure;
* content save conflict;
* dynamic filter result updates;
* deletion confirmation.

Do not move focus unexpectedly.

Do not trap focus outside dialogs.

---

## Keyboard Support

All functionality must be keyboard accessible.

Verify:

* navigation;
* menus;
* filters;
* dialogs;
* tabs;
* forms;
* editor toolbar;
* tables;
* galleries;
* pagination.

Do not make drag-and-drop the only interaction.

---

## Visible Focus

Every interactive element needs a visible focus state.

The focus color should work across surfaces.

Do not remove browser focus outlines without replacement.

Do not make focus indicators too subtle.

---

## Touch Targets

Interactive targets should be comfortable on touch devices.

Avoid tiny icons or closely packed controls.

Do not rely on hover for required actions.

---

## Semantic HTML

Prefer:

```text
header
nav
main
article
section
aside
footer
button
a
form
fieldset
legend
table
dl
```

Use the element matching behavior.

Do not use clickable `div` elements when a button or link is correct.

---

## Heading Hierarchy

Each page should generally have one `h1`.

Article content headings should begin below the page title.

Do not skip heading levels only for visual sizing.

Use CSS for appearance.

---

## Landmark Structure

Pages should expose meaningful landmarks.

Examples:

* banner;
* navigation;
* main;
* complementary;
* content info.

Do not create multiple unlabeled navigation landmarks when labels are needed.

---

## Accessible Names

Controls need clear accessible names.

Examples:

```text
Open filters
Close dialog
Next page
Upload image
Publish article
```

Avoid:

```text
Click here
More
Action
```

when context is unclear.

---

## Images and Alt Text

Meaningful images need useful alt text.

Species images should describe:

* animal;
* relevant visible action or context;
* environment when useful.

Avoid redundancy with nearby text.

Decorative images use empty alt text.

Do not automatically use captions as alt text when their functions differ.

---

## Color Independence

Statuses and errors must use more than color.

Use:

* text;
* icon;
* shape;
* label;
* pattern when appropriate.

Do not communicate conservation status only through a colored dot.

---

## Screen Reader Behavior

Dynamic messages should use appropriate live regions.

Examples:

* save success;
* validation summary;
* results updated;
* upload complete.

Do not announce every minor visual change.

Avoid overly verbose live regions.

---

## Language

The application should set page language correctly.

Content language may vary in the future.

Scientific names remain unchanged.

Do not mix translated labels inconsistently.

Do not hardcode user-facing copy throughout reusable components when localization is expected later.

---

## Content Tone

User-facing copy should be:

* precise;
* calm;
* informative;
* approachable;
* respectful of wildlife;
* free from sensationalism.

Avoid:

* exaggerated danger language;
* childish expressions;
* marketing clichés;
* vague calls to action;
* unsupported scientific certainty.

---

## Microcopy

Buttons and messages should use action-oriented language.

Prefer:

```text
Save draft
Publish article
Clear filters
View species
Try again
```

Avoid:

```text
Submit
Continue
Click here
OK
```

when a clearer action exists.

---

## Responsive Navigation

On mobile:

* use a menu button;
* expose current route;
* support keyboard and screen reader;
* close after navigation;
* restore focus.

Do not hide search entirely unless another accessible route exists.

---

## Mobile Admin

Admin interfaces must remain usable on mobile.

Strategies:

* stack form sections;
* simplify tables;
* move secondary actions into menus;
* preserve primary action;
* use drawers for navigation.

Do not assume administration occurs only on desktop.

---

## Desktop Density

Use available space without harming readability.

Public content should remain centered and editorial.

Admin content may use wider layouts.

Do not stretch article text across the full viewport.

---

## Design Tokens in Tailwind

Map semantic tokens into Tailwind configuration.

Directional example:

```ts
theme: {
  extend: {
    colors: {
      background: "hsl(var(--background))",
      foreground: "hsl(var(--foreground))",
      surface: "hsl(var(--surface))",
      accent: "hsl(var(--accent))",
      border: "hsl(var(--border))",
    },
  },
}
```

Exact implementation may differ.

Do not use repeated arbitrary hex values in components.

---

## CSS Variables

CSS variables may support semantic tokens.

Example:

```css
:root {
  --background: 42 35% 96%;
  --foreground: 150 20% 12%;
  --surface: 40 25% 99%;
  --border: 35 15% 82%;
  --accent: 153 35% 28%;
}
```

Values are illustrative.

Do not adopt values without visual validation.

---

## Component Variants

Use a controlled variant pattern.

Potential tools:

* explicit prop mapping;
* class variance utilities when already adopted.

Do not build a complex component API for every combination.

Variants should represent meaningful semantic choices.

---

## Component Documentation

Document shared components with:

* purpose;
* variants;
* states;
* accessibility;
* usage guidance;
* prohibited use.

Storybook may be introduced later when the component library is large enough.

Do not add Storybook in Phase 0 unless it supports actual design-system work.

---

## Component Ownership

Place components according to scope.

### `components/ui`

Reusable primitives.

### `components/layout`

Global or repeated layouts.

### `components/content`

Editorial renderers.

### Feature components

Domain-specific presentation.

Do not move feature-specific components into shared UI prematurely.

---

## Design Review

Before completing a UI task, review:

### Hierarchy

* Is the primary content clear?
* Is one primary action visible?
* Are secondary actions subordinate?

### Consistency

* Are tokens used?
* Are component patterns reused?
* Are statuses consistent?

### Accessibility

* Can keyboard users complete the task?
* Are labels and focus visible?
* Is contrast adequate?

### Responsiveness

* Does it work from narrow mobile to wide desktop?
* Is there overflow?
* Are touch targets usable?

### Content

* Is copy clear?
* Are scientific terms presented correctly?
* Is risk content responsible?

### States

* Loading?
* Empty?
* Error?
* Success?
* Forbidden?
* Not found?

Do not review only the ideal success state.

---

## UX Testing

Use:

* component tests;
* accessibility tests;
* keyboard testing;
* responsive manual checks;
* E2E user journeys;
* visual regression when stable.

Do not treat screenshots as proof of usability.

---

## Responsive Validation

Validate at representative widths.

Potential minimum set:

```text
360px
768px
1024px
1440px
```

Also inspect fluid behavior between them.

Do not optimize only for exact widths.

---

## Browser Support

Define supported modern browsers.

Potential baseline:

* current Chrome;
* current Firefox;
* current Safari;
* current Edge.

Do not use unsupported platform features without fallback or documented browser target.

---

## Performance and UX

Visual design must support performance.

Use:

* optimized images;
* lazy loading below the fold;
* reserved image dimensions;
* route-based code splitting;
* restrained fonts;
* reduced third-party scripts.

Do not sacrifice readability for a lower bundle size without need.

Do not load many font weights.

---

## Layout Shift

Prevent unexpected layout shift through:

* image dimensions;
* skeletons;
* stable button sizes;
* reserved async-content space;
* careful font loading.

Do not insert banners above content after load without preserving space.

---

## Content Loading

Prioritize:

1. page identity;
2. primary content;
3. secondary recommendations;
4. decorative content.

Do not block the main article on related-content requests.

---

## Progressive Enhancement

Core reading should remain robust.

Avoid making simple navigation dependent on complex JavaScript behavior when standard links work.

Do not use client-only interactions where native behavior is better.

---

## Privacy-Aware UX

Do not use deceptive consent patterns.

Do not preselect optional tracking consent.

Do not hide privacy actions.

When analytics is introduced, explain its purpose clearly.

---

## Ethical Wildlife Presentation

The design should encourage:

* observation;
* understanding;
* preservation;
* responsible coexistence.

Avoid:

* trophy-like imagery;
* aggressive danger symbolism;
* imagery encouraging handling;
* pet-commerce presentation;
* fear-driven engagement.

Do not turn rare or dangerous animals into visual spectacle.

---

## Phase 0 UX Baseline

Phase 0 should establish:

* design-token foundation;
* global typography;
* public layout;
* temporary home page;
* responsive header;
* footer;
* accessible focus states;
* loading and error primitives;
* basic button and input;
* content-width conventions.

Do not attempt the complete final design during Phase 0.

The goal is a coherent foundation.

---

## Phase 1 UX Baseline

Phase 1 should add:

* public catalog;
* species cards;
* article cards;
* species detail layout;
* article reading layout;
* search and filters;
* pagination;
* public empty and error states.

---

## Phase 3 UX Baseline

Phase 3 should add:

* admin layout;
* tables;
* content forms;
* editorial status;
* editor toolbar;
* save state;
* preview;
* publication validation.

Do not implement admin UX before the administration phase.

---

## Documentation Requirements

When design-system or UX behavior changes, evaluate updates to:

```text
docs/design/
docs/product/
docs/architecture/
README.md
apps/web/src/app/styles/
```

Recommended documents:

```text
docs/design/foundations.md
docs/design/components.md
docs/design/accessibility.md
docs/design/editorial-layouts.md
docs/design/admin-patterns.md
```

Do not create all documents before their content exists.

---

## ADRs

Potential ADRs:

```text
Use semantic design tokens
Use Tailwind CSS for styling
Use an editorial public layout and denser admin layout
Use accessible primitives for dialogs and menus
Use mobile-first responsive design
```

Create ADRs only for meaningful architectural decisions.

Do not use ADRs for ordinary visual tweaks.

---

## Implementation Workflow

When using this skill:

1. identify the user and task;
2. identify the page or component;
3. inspect existing tokens and patterns;
4. identify all states;
5. define information hierarchy;
6. define semantic structure;
7. define responsive behavior;
8. define accessibility requirements;
9. select or create the smallest reusable components;
10. implement with semantic tokens;
11. test keyboard and responsive behavior;
12. add or update tests;
13. update design documentation;
14. report limitations.

Implement the smallest coherent visual slice.

---

## Expected Deliverables

Depending on the task, deliverables may include:

* design tokens;
* typography;
* global styles;
* layouts;
* navigation;
* pages;
* shared components;
* responsive behavior;
* form patterns;
* state components;
* accessibility improvements;
* tests;
* design documentation;
* ADRs.

Do not redesign unrelated parts of the application.

---

## Definition of Done

A UX or design-system task is complete only when:

* the user journey is clear;
* visual hierarchy is intentional;
* semantic tokens are used;
* responsive behavior is defined;
* keyboard access is verified;
* focus is visible;
* contrast is evaluated;
* all relevant states are handled;
* content remains readable;
* scientific terminology is presented correctly;
* public and admin patterns remain distinct;
* relevant tests pass;
* documentation is updated;
* no success is claimed without validation.

---

## Prohibited Practices

Do not:

* use arbitrary colors repeatedly;
* create a generic SaaS visual style;
* overuse green;
* make every section a card;
* use decorative motion without purpose;
* hide critical actions on mobile;
* rely only on color for status;
* remove focus outlines;
* use clickable `div` elements;
* use placeholders as labels;
* use hover as the only interaction;
* create inaccessible custom dialogs;
* use autoplay carousels;
* stretch article text across wide screens;
* make public pages look like dashboards;
* make admin pages overly decorative;
* use sensational danger visuals;
* introduce dark mode before full support exists;
* add Storybook without a real component-system need;
* declare UI complete after checking only one viewport.

---

## Completion Report

After completing a UX or design-system task, report:

```markdown
## UX scope

## User journey

## Visual hierarchy

## Design tokens and components

## Responsive behavior

## Accessibility

## Interaction states

## Editorial or admin considerations

## Tests and validation

## Documentation updates

## Limitations
```

Keep the report factual and based on actual implementation and validation.

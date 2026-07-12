---

name: content-editor
description: Defines standards for the editorial content system of the reptile knowledge platform. Use this skill for article editing, structured content blocks, TipTap integration, sanitization, revisions, previews, publishing workflows, media embedding, autosave, and editorial validation.
when_to_use: Use whenever a task creates, changes, reviews, debugs, or tests article editing, rich-text behavior, structured block schemas, content serialization, previews, drafts, revisions, scheduled publishing, editorial validation, or media insertion.
argument-hint: "[editorial-content-task]"
disable-model-invocation: false
user-invocable: true
model: inherit
effort: high
paths:

* "apps/api/internal/articles/**"
* "apps/api/internal/media/**"
* "apps/api/openapi/**"
* "apps/web/src/features/articles/**"
* "apps/web/src/features/admin/**"
* "apps/web/src/components/content/**"
* "apps/web/src/components/editor/**"
* "docs/product/article-content-model.md"
* "docs/product/editorial-guidelines.md"

---

# Content Editor

## Objective

Define and enforce the standards of the editorial content system for the reptile knowledge platform.

Use this skill to guide:

* article creation;
* structured content blocks;
* rich-text editing;
* TipTap integration;
* content validation;
* content serialization;
* safe rendering;
* draft workflows;
* revision history;
* preview;
* scheduled publication;
* media embedding;
* accessibility;
* editorial metadata;
* recovery from failed saves.

The current task is:

```text
$ARGUMENTS
```

If no arguments were provided, infer the task from the current conversation.

---

## Mandatory Context

Before changing the editor or article content model:

1. Read `${CLAUDE_PROJECT_DIR}/CLAUDE.md`.
2. Read the `product-domain`, `react-frontend`, `go-backend`, `database`, `security`, and `ux-design-system` skills when relevant.
3. Inspect the current article domain.
4. Inspect existing content block schemas.
5. Inspect frontend editor components.
6. Inspect backend validation and persistence.
7. Inspect media integration.
8. Inspect editorial workflow states.
9. Identify the current project phase.
10. Identify whether the task affects authoring, preview, publishing, or public rendering.

Do not change the content format without evaluating migration and compatibility impact.

Do not introduce editor features that the backend cannot validate or render safely.

---

## Core Principles

The editorial system must be:

* structured;
* safe;
* accessible;
* versionable;
* predictable;
* recoverable;
* extensible;
* independent from one editor implementation;
* compatible with future content migrations;
* suitable for scientific and educational articles.

The editor implementation is not the content model.

TipTap may be used as the authoring interface, but persisted content must follow an explicit application-owned schema.

Do not persist arbitrary editor state without validation.

---

## Article Content Model

Article content should be represented as a document containing ordered blocks.

Directional example:

```json
{
  "version": 1,
  "blocks": [
    {
      "id": "block-uuid",
      "type": "heading",
      "data": {
        "level": 2,
        "text": "Ecological importance"
      }
    },
    {
      "id": "block-uuid",
      "type": "paragraph",
      "data": {
        "text": "Reptiles play important roles in food webs."
      }
    }
  ]
}
```

The exact schema may evolve.

Every document should have:

* schema version;
* ordered blocks;
* stable block IDs;
* validated block types;
* validated block data.

Do not accept arbitrary keys without schema validation.

---

## Initial Supported Blocks

The first implementation may support:

```text
paragraph
heading
unordered_list
ordered_list
image
quote
curiosity
reference
```

Future blocks may include:

```text
gallery
alert
table
scientific_classification
species_card
comparison
map
embedded_video
conservation_status
timeline
```

Do not implement all planned blocks at once.

Add a new block type only when:

1. there is a clear editorial use case;
2. backend schema exists;
3. frontend editor support exists;
4. public renderer exists;
5. validation exists;
6. tests exist;
7. migration impact is understood.

---

## Block Contract

Each block must contain:

* `id`;
* `type`;
* `data`.

Optional metadata may include:

* version;
* created timestamp;
* updated timestamp;
* alignment;
* accessibility information.

Avoid placing general-purpose arbitrary metadata on every block.

### Stable Block IDs

Block IDs should remain stable during editing when possible.

They may support:

* revision comparison;
* comments in future;
* analytics;
* anchor links;
* content migration.

Do not regenerate every block ID on every save.

---

## Paragraph Block

Directional schema:

```json
{
  "id": "block-uuid",
  "type": "paragraph",
  "data": {
    "text": "Reptiles regulate their body temperature through behavior."
  }
}
```

Requirements:

* text must be sanitized;
* empty paragraphs should be removed or normalized;
* formatting support must be explicit;
* unsupported marks must not be silently persisted.

Do not allow arbitrary embedded HTML.

---

## Heading Block

Directional schema:

```json
{
  "id": "block-uuid",
  "type": "heading",
  "data": {
    "level": 2,
    "text": "Habitat"
  }
}
```

Rules:

* supported levels should usually be `2` and `3`;
* article title is the page-level `h1`;
* heading hierarchy must remain logical;
* heading text must not be empty;
* heading IDs may be derived safely for table-of-contents anchors.

Do not permit authors to create arbitrary `h1` blocks inside the article body.

---

## List Blocks

Directional ordered-list schema:

```json
{
  "id": "block-uuid",
  "type": "ordered_list",
  "data": {
    "items": [
      "Forest edges",
      "Wetlands",
      "River margins"
    ]
  }
}
```

Requirements:

* items must be non-empty;
* nesting depth must be controlled;
* lists must remain semantically valid;
* unsupported embedded structures must be rejected.

Do not represent lists only through line breaks in paragraph text.

---

## Image Block

Directional schema:

```json
{
  "id": "block-uuid",
  "type": "image",
  "data": {
    "mediaId": "media-uuid",
    "altText": "Green sea turtle swimming above seagrass",
    "caption": "A green sea turtle in a coastal habitat.",
    "credit": "Photographer name",
    "alignment": "wide"
  }
}
```

Required considerations:

* media asset must exist;
* user must be authorized to use it;
* alt text must be meaningful unless decorative;
* credit and license must be preserved;
* unsupported alignment values must be rejected.

Do not persist arbitrary external image URLs as the primary media model.

Do not use the filename as alternative text.

---

## Quote Block

Directional schema:

```json
{
  "id": "block-uuid",
  "type": "quote",
  "data": {
    "text": "Scientific knowledge improves coexistence with wildlife.",
    "attribution": "Institution or author",
    "sourceReferenceId": "reference-uuid"
  }
}
```

Do not allow quotes without attribution when attribution is known.

Do not use quote blocks only for decorative emphasis.

---

## Curiosity Block

Directional schema:

```json
{
  "id": "block-uuid",
  "type": "curiosity",
  "data": {
    "title": "Did you know?",
    "text": "Some reptiles can remain underwater for extended periods."
  }
}
```

Curiosity blocks should:

* provide educational value;
* avoid sensationalism;
* remain factually supported;
* not be overused.

Do not use curiosity blocks as replacements for regular article structure.

---

## Reference Block

Directional schema:

```json
{
  "id": "block-uuid",
  "type": "reference",
  "data": {
    "referenceId": "reference-uuid",
    "label": "IUCN assessment"
  }
}
```

A reference block may display a citation or reference card.

Do not duplicate complete reference metadata inside every block when a reusable reference entity exists.

---

## Content Versioning

The content document must have a schema version.

Example:

```json
{
  "version": 1,
  "blocks": []
}
```

When an incompatible schema change occurs:

1. increment the document version;
2. define a migration;
3. preserve old content;
4. test conversion;
5. update editor and renderer;
6. document the change.

Do not silently reinterpret old content.

Do not make the editor responsible for all historical migrations.

---

## TipTap Strategy

TipTap may be used as the editing engine.

Use it for:

* authoring experience;
* keyboard behavior;
* selection;
* marks;
* nodes;
* commands;
* undo and redo.

Do not treat TipTap JSON as a permanent domain contract without review.

Two valid approaches exist.

### Approach A — Persist TipTap JSON

Acceptable when:

* allowed nodes are tightly controlled;
* schema is application-owned;
* backend validates the document;
* migrations are planned;
* public rendering is safe.

### Approach B — Map TipTap state to application blocks

Preferred when:

* the platform wants explicit block ownership;
* content blocks require domain metadata;
* editor implementation may change;
* rendering must remain stable.

Choose one approach deliberately and document it through an ADR.

Do not mix both formats inconsistently.

---

## Editor Extensions

Only enable extensions required by the product.

Potential initial extensions:

* document;
* paragraph;
* text;
* heading;
* bold;
* italic;
* bullet list;
* ordered list;
* list item;
* blockquote;
* history;
* placeholder;
* link;
* image through application media integration.

Avoid enabling:

* arbitrary HTML;
* executable embeds;
* unrestricted iframe content;
* complex tables;
* code execution;
* unsupported custom nodes.

Every enabled extension expands the validation and rendering surface.

---

## Marks

Initial marks may include:

```text
bold
italic
link
```

Potential future marks:

```text
superscript
subscript
highlight
```

Do not enable arbitrary text color or font families in article content.

The design system should control typography.

Do not let authors create inconsistent visual styles inside content.

---

## Link Handling

Links must be validated.

Requirements:

* allow supported protocols;
* reject `javascript:`;
* reject unsafe data URLs;
* distinguish internal and external links;
* add safe external-link attributes where appropriate;
* support accessible link text.

Allowed protocols may include:

```text
https
http
mailto
```

Use `mailto` only when relevant.

Do not allow arbitrary custom protocols.

Do not make every link open in a new tab.

---

## Embedded Content

Do not enable arbitrary embeds in the initial version.

Future embeds may support allowlisted providers.

Requirements:

* explicit provider allowlist;
* validated URLs;
* safe iframe attributes;
* restrictive sandbox;
* privacy considerations;
* accessible title;
* responsive rendering.

Do not render arbitrary iframe HTML supplied by authors.

---

## Content Sanitization

Sanitization is mandatory.

Use defense in depth:

1. editor limits allowed structures;
2. frontend validates before sending;
3. backend validates against the content schema;
4. backend sanitizes permitted text or markup;
5. public renderer supports only known block types;
6. Content Security Policy limits damage.

Do not rely only on frontend sanitization.

Do not use `dangerouslySetInnerHTML` for untrusted content.

---

## Plain Text vs Rich Text

Prefer plain text fields for:

* title;
* subtitle;
* summary;
* image captions;
* alt text;
* attribution;
* SEO description.

Use structured rich content only for the article body.

Do not store titles or summaries as rich HTML without a concrete requirement.

---

## Editorial Workflow

Initial statuses:

```text
draft
in_review
scheduled
published
archived
```

The editor must reflect the current status clearly.

Possible actions:

```text
save draft
submit for review
return to draft
schedule publication
publish now
archive
restore as draft
```

Do not show actions the user lacks permission to perform.

Backend workflow rules remain authoritative.

---

## Draft Behavior

A draft may be incomplete.

Draft validation should distinguish:

* structural validity;
* publication readiness.

A draft must still be safely serializable and persistable.

Do not require every publication field to save a draft.

Do not permit malformed content documents even in drafts.

---

## Publication Readiness

Before publishing, validate:

* title;
* slug;
* summary;
* author;
* meaningful article body;
* required cover image when policy requires it;
* references for relevant scientific claims;
* accessible media metadata;
* valid status transition;
* valid publication date;
* sanitized content;
* supported block types.

Display publication errors clearly.

Do not return only a generic “cannot publish” message.

---

## Scheduled Publication

Scheduling requires:

* future timestamp;
* valid timezone semantics;
* publication-ready article;
* scheduler or worker;
* idempotent execution;
* clear cancellation or rescheduling behavior.

Store schedule timestamps in UTC.

Display them in the author’s relevant timezone.

Do not implement scheduling until the worker and operational behavior exist.

---

## Preview

Preview should render content using the same block renderer used by public pages whenever possible.

Preview must:

* support unpublished content;
* require authorization;
* avoid accidental search indexing;
* avoid public exposure;
* show responsive behavior;
* show missing-content warnings.

Do not implement a preview that uses a completely separate rendering path unless necessary.

Do not expose predictable unauthenticated preview URLs.

---

## Article Revisions

Revisions may preserve:

* title;
* subtitle;
* summary;
* content;
* cover image;
* SEO metadata;
* author of revision;
* revision timestamp;
* revision number;
* change reason when relevant.

Create revisions at meaningful moments.

Possible strategies:

* every explicit save;
* every publication;
* periodic checkpoints;
* status transitions.

Do not create a full revision for every keystroke.

Do not implement revision history before Phase 3 unless needed.

---

## Revision Comparison

Future revision comparison may use:

* block IDs;
* block order;
* text diff;
* metadata comparison.

Stable block IDs improve meaningful comparisons.

Do not implement a complex visual diff before revision history exists.

---

## Autosave

Autosave is optional and should not be introduced casually.

If implemented, it requires:

* dirty-state tracking;
* debounce;
* visible save status;
* retry;
* conflict handling;
* cancellation;
* offline or network-failure behavior;
* revision policy;
* final explicit-save semantics if applicable.

Possible statuses:

```text
saved
saving
unsaved
save_failed
offline
conflict
```

Do not silently fail autosave.

Do not discard edits when a save fails.

---

## Manual Save

Manual save should:

* prevent duplicate requests;
* preserve editor content during request;
* show progress;
* map backend validation errors;
* confirm success;
* update version or revision state;
* preserve unsaved state on failure.

Do not clear the editor after saving.

---

## Unsaved Changes

When content is dirty:

* warn before internal route navigation;
* warn before browser unload when appropriate;
* restore focus after cancellation;
* explain whether changes are saved.

Do not show unload warnings when no changes exist.

Do not create false confidence about saved content.

---

## Conflict Handling

Concurrent editing may cause conflicts.

Initial strategy may use:

* `updatedAt`;
* version number;
* revision ID;
* ETag.

On conflict:

* do not overwrite silently;
* preserve the local draft;
* explain the conflict;
* allow reload or copy;
* provide comparison later if available.

Do not implement last-write-wins silently for editorial content once concurrent editing is possible.

---

## Media Integration

The editor should use the platform media library.

Expected flow:

1. user opens media selection;
2. user uploads or selects an asset;
3. media validation occurs;
4. media metadata is captured;
5. editor inserts a media reference;
6. article content stores the media ID;
7. renderer resolves the asset.

Do not embed base64 images inside article JSON.

Do not treat upload completion as article save completion.

---

## Media Upload Metadata

Required or recommended fields:

* file;
* alt text;
* caption;
* credit;
* source;
* license.

The editor should make missing accessibility and licensing metadata visible.

Do not permit publication of required media without required metadata.

---

## Image Processing

Future image processing may include:

* dimensions;
* compression;
* thumbnails;
* responsive variants;
* format conversion;
* metadata extraction.

Do not block the initial editor on a complete image-processing pipeline.

The media module owns technical processing.

The editor owns selection and editorial metadata.

---

## Accessibility

The editor itself must be accessible.

Verify:

* keyboard navigation;
* visible focus;
* toolbar labels;
* active-state announcements;
* heading controls;
* list controls;
* dialog accessibility;
* media alt-text fields;
* error messages;
* save-status announcements;
* screen-reader compatibility.

Toolbars should use buttons with accessible names.

Do not rely only on icons.

---

## Editor Keyboard Behavior

Support expected keyboard interactions:

* text entry;
* selection;
* undo;
* redo;
* list navigation;
* heading shortcuts when appropriate;
* toolbar access;
* escape from dialogs.

Do not override browser shortcuts unnecessarily.

Do not trap keyboard focus inside the editor.

---

## Toolbar

The initial toolbar should remain focused.

Possible controls:

* paragraph;
* heading level 2;
* heading level 3;
* bold;
* italic;
* bullet list;
* ordered list;
* quote;
* link;
* image;
* curiosity block;
* undo;
* redo.

Do not add dozens of formatting options.

Do not expose controls for unsupported persisted structures.

---

## Slash Commands

Slash commands may be introduced later.

Potential commands:

```text
/heading
/image
/quote
/curiosity
/reference
```

If implemented:

* ensure keyboard accessibility;
* filter supported blocks;
* prevent command text from remaining in content;
* validate inserted blocks.

Do not prioritize slash commands over core editor reliability.

---

## Drag and Drop

Block reordering may be useful later.

If implemented:

* support keyboard alternatives;
* maintain block IDs;
* preserve selection;
* avoid accidental data loss;
* announce reorder results.

Do not make drag and drop the only reordering method.

---

## Table of Contents

The article table of contents may derive from heading blocks.

Requirements:

* stable anchor IDs;
* logical hierarchy;
* duplicate-heading handling;
* accessible navigation;
* current-section highlighting only when useful.

Do not persist the table of contents separately unless there is a real need.

Derive it from validated headings.

---

## Reading Time

Estimated reading time may be calculated from textual content.

Rules:

* ignore non-text metadata;
* include list and quote text;
* use a documented words-per-minute assumption;
* round consistently;
* recalculate on save or publication.

Do not let authors manually provide reading time unless there is a product need.

Document the calculation.

---

## SEO Metadata

Article SEO may include:

* meta title;
* meta description;
* canonical URL;
* Open Graph title;
* Open Graph description;
* social image.

Defaults may derive from article fields.

Do not allow SEO fields to contradict publication state.

Do not expose draft metadata publicly.

---

## Scientific References

The editor should make references easy to attach.

Possible interactions:

* search existing references;
* create a reference;
* attach references to article;
* insert a reference block;
* show unresolved references.

Do not require authors to duplicate the full citation manually in article text.

Do not auto-create references from arbitrary URLs without validation.

---

## Editorial Validation

Validation should distinguish:

### Structural validation

Examples:

* valid document version;
* known block types;
* required block fields;
* valid heading levels;
* valid IDs;
* valid media references.

### Editorial validation

Examples:

* title quality;
* summary length;
* missing references;
* missing image credits;
* repeated headings;
* poor alt text;
* empty sections.

### Publication validation

Examples:

* required metadata;
* allowed status transition;
* valid scheduling;
* content completeness.

Do not treat every editorial warning as a hard error.

Use warnings and blocking errors deliberately.

---

## Frontend Schema Validation

Use Zod for client-side content validation.

Directional example:

```ts
const headingBlockSchema = z.object({
  id: z.string().uuid(),
  type: z.literal("heading"),
  data: z.object({
    level: z.union([z.literal(2), z.literal(3)]),
    text: z.string().trim().min(1),
  }),
});
```

Create a discriminated union for supported blocks.

Do not use `z.record(z.unknown())` as the final block schema.

---

## Backend Validation

The backend must independently validate the content document.

Validation should include:

* document version;
* supported blocks;
* block-specific rules;
* block count limits;
* text length limits;
* media ownership or existence;
* link safety;
* publication readiness.

Do not trust TypeScript validation as backend enforcement.

---

## Payload Limits

Define limits for:

* total article document size;
* block count;
* paragraph length;
* heading length;
* list item count;
* list nesting;
* number of images;
* reference count.

Limits should protect reliability without blocking normal editorial use.

Do not allow unbounded article JSON.

---

## Public Rendering

Use an explicit renderer registry.

Directional example:

```ts
const renderers = {
  paragraph: ParagraphBlock,
  heading: HeadingBlock,
  unordered_list: UnorderedListBlock,
  ordered_list: OrderedListBlock,
  image: ImageBlock,
  quote: QuoteBlock,
  curiosity: CuriosityBlock,
  reference: ReferenceBlock,
} satisfies Record<ContentBlock["type"], React.ComponentType<any>>;
```

Prefer properly typed renderer props instead of `any`.

Unknown block types must fail safely.

Do not render arbitrary component names received from the API.

---

## Unknown Blocks

When old or unsupported blocks are encountered:

* log a safe diagnostic;
* preserve data;
* avoid crashing the entire article;
* show an editor warning;
* prevent publication when necessary.

Public rendering may skip an unsupported block with a controlled fallback.

Do not silently delete unknown blocks during editing.

---

## Content Migration

A content migration must:

* read old version;
* transform deterministically;
* preserve IDs when possible;
* preserve unknown data safely;
* validate the new version;
* be testable;
* produce an audit result.

Do not migrate content only in the browser and immediately overwrite the original without backup.

---

## Search Extraction

Search indexing may derive text from structured blocks.

Extract text from:

* headings;
* paragraphs;
* lists;
* quotes;
* curiosities;
* captions.

Do not index:

* internal block IDs;
* hidden editor metadata;
* raw media keys;
* unsupported internal attributes.

Search extraction must be deterministic.

---

## API Design

Potential administrative endpoints:

```text
POST /api/v1/admin/articles
PATCH /api/v1/admin/articles/{id}
POST /api/v1/admin/articles/{id}/submit-review
POST /api/v1/admin/articles/{id}/publish
POST /api/v1/admin/articles/{id}/schedule
POST /api/v1/admin/articles/{id}/archive
GET /api/v1/admin/articles/{id}/preview
GET /api/v1/admin/articles/{id}/revisions
```

Do not create every endpoint before the relevant phase.

Use explicit commands for meaningful workflow transitions.

Avoid a single generic status-update endpoint that bypasses rules.

---

## Create and Update DTOs

Create and update payloads should be explicit.

Do not bind directly to persistence models.

Potential update fields:

* title;
* subtitle;
* summary;
* slug;
* cover image;
* content;
* related species;
* references;
* SEO metadata.

Administrative fields such as author, published timestamp, or workflow status should be controlled separately when required.

Protect against mass assignment.

---

## Partial Updates

For `PATCH`, distinguish:

* field omitted;
* field set to empty;
* field set to null.

Use explicit optional wrappers when needed.

Do not rely on ambiguous zero values.

Content replacement may be atomic for the initial editor.

Do not implement granular block patch APIs unless collaboration or large-document needs justify them.

---

## Persistence

Article content may be stored as JSONB.

Requirements:

* explicit document schema;
* document version;
* application validation;
* size limits;
* migration strategy;
* tests;
* safe serialization.

Store searchable metadata relationally.

Do not store article title, status, author, slug, and publication timestamps only inside JSONB.

---

## Revisions and Transactions

Creating a revision and updating the current article may require a transaction.

Example flow:

1. validate submitted content;
2. check version;
3. create revision;
4. update article current state;
5. commit.

Do not keep a transaction open while uploading media.

Media must already exist before article save references it.

---

## Error Handling

Editor errors should distinguish:

* invalid content;
* unsupported block;
* missing media;
* forbidden action;
* version conflict;
* save failure;
* publication validation failure;
* dependency unavailable.

Frontend messages should be actionable.

Example:

```text
This article could not be published because two images are missing alternative text.
```

Do not expose raw JSON parsing or database errors to authors.

---

## Recovery

The editor should protect author work.

Possible recovery mechanisms:

* local draft buffer;
* failed-save retry;
* conflict copy;
* revision history;
* explicit export in future.

Do not introduce browser-local recovery without lifecycle and privacy considerations.

If local recovery is used, document:

* storage location;
* expiration;
* clearing behavior;
* security implications.

---

## Testing Strategy

### Schema Tests

Test:

* each valid block;
* invalid block types;
* missing required fields;
* invalid heading levels;
* invalid links;
* size limits;
* unsupported versions.

### Backend Tests

Test:

* draft save;
* publication readiness;
* invalid transitions;
* revision creation;
* version conflicts;
* media validation;
* authorization.

### Frontend Tests

Test:

* toolbar behavior;
* editor initialization;
* serialization;
* validation messages;
* save states;
* failed save;
* preview;
* unsaved changes;
* accessibility.

### End-to-End Tests

Critical future flows:

* create draft;
* add structured content;
* insert image;
* save;
* preview;
* submit for review;
* publish;
* reopen revision.

Do not test only the underlying editor library.

Test product behavior.

---

## TipTap Tests

Avoid coupling every test to TipTap internals.

Prefer testing:

* visible toolbar state;
* user commands;
* resulting application document;
* saved payload;
* rendered preview.

Use lower-level editor tests only for custom extensions.

---

## Security Review Checklist

Before completing editor work, verify:

* only supported block types are accepted;
* raw HTML is rejected or sanitized;
* unsafe links are rejected;
* external embeds are restricted;
* media IDs are authorized;
* payload limits exist;
* preview requires authorization;
* unpublished content is not public;
* editor errors do not leak internals;
* frontend does not use unsafe rendering.

---

## Accessibility Review Checklist

Verify:

* toolbar buttons have labels;
* keyboard navigation works;
* editor focus is visible;
* headings are semantically correct;
* image alt text is supported;
* errors are announced;
* save status is announced;
* dialogs restore focus;
* drag-and-drop has an alternative;
* preview preserves semantic structure.

---

## Documentation Requirements

When the content model or editor changes, evaluate updates to:

```text
docs/product/article-content-model.md
docs/product/editorial-guidelines.md
docs/product/reference-policy.md
docs/architecture/
docs/adr/
docs/api/
README.md
```

Recommended ADRs:

```text
Use structured article blocks
Use TipTap as the initial editor
Persist application-owned content schema
Store structured article documents in PostgreSQL JSONB
```

Document:

* supported blocks;
* schema version;
* migrations;
* validation;
* editor shortcuts;
* save behavior;
* workflow states;
* preview behavior;
* media requirements.

---

## Environment and Configuration

Potential editor-related frontend variables:

```text
VITE_MAX_ARTICLE_SIZE
VITE_MAX_MEDIA_UPLOAD_SIZE
```

Prefer backend-owned limits exposed through configuration or API where practical.

Do not trust frontend limits as enforcement.

Do not expose secrets through editor configuration.

---

## Implementation Workflow

When using this skill:

1. identify the editorial use case;
2. identify affected workflow state;
3. inspect the current content schema;
4. define or update the block contract;
5. define backend validation;
6. define frontend editor behavior;
7. define public rendering behavior;
8. define media and reference integration;
9. define persistence and migration impact;
10. define save and recovery states;
11. add tests;
12. validate accessibility and security;
13. update documentation.

Implement the smallest complete editorial slice.

---

## Expected Deliverables

Depending on the task, deliverables may include:

* article document schema;
* content block schemas;
* TipTap configuration;
* custom extensions;
* editor toolbar;
* serialization;
* backend validators;
* public renderers;
* preview;
* revisions;
* save behavior;
* media integration;
* publication validation;
* tests;
* documentation;
* ADRs.

Do not implement unrelated editorial features.

---

## Definition of Done

A content-editor task is complete only when:

* the content schema is explicit;
* supported blocks are validated;
* frontend and backend agree on the contract;
* unsafe content is rejected or sanitized;
* public rendering is safe;
* draft and publication rules are distinct;
* save failures preserve author work;
* accessibility is evaluated;
* media metadata is handled correctly;
* relevant tests pass;
* content migrations are addressed when required;
* documentation is updated;
* no unsupported editor behavior is persisted;
* no validation result is falsely claimed.

---

## Prohibited Practices

Do not:

* persist arbitrary raw HTML;
* trust TipTap JSON without validation;
* store base64 images in article content;
* use `dangerouslySetInnerHTML` for untrusted content;
* enable every editor extension by default;
* allow arbitrary iframe embeds;
* permit unsupported heading levels;
* use rich text for every metadata field;
* create revisions on every keystroke;
* introduce autosave without recovery behavior;
* silently overwrite concurrent changes;
* silently delete unknown blocks;
* regenerate all block IDs on every save;
* bypass backend publication validation;
* expose unauthenticated previews;
* treat image filename as alt text;
* declare the editor complete without testing save failures and rendering.

---

## Completion Report

After completing an editorial-content task, report:

```markdown
## Editorial scope

## Content schema

## Supported blocks

## Editor behavior

## Validation and sanitization

## Workflow and publishing

## Media and references

## Persistence and migrations

## Accessibility

## Security

## Tests

## Validation performed

## Documentation updates

## Limitations
```

Keep the report factual and based on actual work performed.

---

name: product-domain
description: Defines and protects the product domain of the reptile knowledge platform. Use this skill when modeling reptiles, species, taxonomy, conservation, ecological importance, habitats, diets, geographic distribution, scientific references, editorial categories, species pages, or educational articles.
when_to_use: Use whenever a task creates, changes, validates, organizes, displays, searches, imports, or publishes information about reptiles, species, taxonomy, conservation, ecology, scientific classification, or editorial content.
argument-hint: "[domain-task-or-content-model]"
disable-model-invocation: false
user-invocable: true
model: inherit
effort: high
------------

# Product Domain

## Objective

Protect the scientific, editorial, and semantic consistency of the reptile knowledge platform.

Use this skill when designing or changing:

* species models;
* taxonomy;
* editorial categories;
* reptile classifications;
* species pages;
* educational articles;
* conservation information;
* ecological importance sections;
* geographic distribution;
* habitats;
* diets;
* behavior;
* reproduction;
* risks to humans;
* references;
* search metadata;
* content validation rules.

The current task is:

```text
$ARGUMENTS
```

If no arguments were provided, infer the task from the current conversation.

---

## Mandatory Context

Before proposing or changing domain structures:

1. Read `${CLAUDE_PROJECT_DIR}/CLAUDE.md`.
2. Inspect existing domain documentation.
3. Inspect current entities, migrations, API contracts, and frontend types.
4. Identify whether the concept is scientific, editorial, operational, or user-generated.
5. Check whether the requested concept already exists under another name.
6. Preserve existing terminology unless a correction is necessary.
7. Identify whether the requested information is stable, source-dependent, or time-sensitive.
8. Determine whether a field belongs to the species entity, an article, taxonomy, media, references, or metadata.

Do not create new domain concepts before checking whether an existing concept already represents the same meaning.

---

## Core Domain Principles

The domain model must follow these principles:

* distinguish scientific classification from editorial grouping;
* distinguish factual data from editorial interpretation;
* distinguish species data from article content;
* keep scientific names separate from common names;
* allow uncertainty and incomplete information;
* preserve source attribution;
* avoid presenting estimates as exact facts;
* avoid oversimplified danger classifications;
* represent conservation status with source and date;
* support geographic and linguistic variation in common names;
* avoid culturally biased or region-specific assumptions;
* avoid treating every reptile as dangerous;
* prioritize ecological context;
* prevent misleading or sensationalized content.

The platform is educational and editorial, not a substitute for veterinary, medical, legal, wildlife-management, or emergency guidance.

---

## Domain Boundaries

The platform contains several distinct domain areas.

### Taxonomy

Represents scientific classification.

Examples:

* class;
* order;
* suborder;
* infraorder;
* superfamily;
* family;
* subfamily;
* genus;
* species;
* subspecies.

### Species

Represents a biological species or subspecies documented by the platform.

Examples:

* `Boa constrictor`;
* `Chelonia mydas`;
* `Caiman latirostris`.

### Editorial Group

Represents a human-friendly navigation or content grouping.

Examples:

* snakes;
* lizards;
* turtles and tortoises;
* crocodilians;
* tuataras.

Editorial groups are not taxonomic ranks.

### Article

Represents an editorial publication about one or more topics.

Examples:

* ecological importance of snakes;
* differences between venomous and non-venomous reptiles;
* reptile thermoregulation;
* conservation challenges.

### Reference

Represents the source supporting a claim or data point.

Examples:

* scientific article;
* book;
* conservation database;
* government publication;
* museum publication;
* institutional website.

### Media Asset

Represents an image, video, illustration, map, or diagram.

A media asset must not be treated as part of taxonomy.

### Conservation Assessment

Represents a status issued by a recognized institution or authority at a specific date.

Conservation status is not a timeless intrinsic property.

### Geographic Distribution

Represents occurrence or distribution across geographic areas.

Distribution may vary by:

* native range;
* introduced range;
* historical range;
* current range;
* uncertain occurrence.

---

## Scientific Taxonomy

### Supported Ranks

The initial domain should support at least:

```text
class
order
suborder
family
genus
species
subspecies
```

Additional ranks may be added when there is a real requirement.

Do not hardcode every possible taxonomic rank as a separate mandatory database column unless the model explicitly requires it.

Prefer a taxonomic structure that can evolve without creating an excessively wide schema.

### Scientific Name

A scientific name must:

* be stored separately from the common name;
* preserve its canonical spelling;
* support genus and species components;
* support subspecies when applicable;
* be displayed in italics in the user interface;
* not be automatically translated;
* not be converted to title case indiscriminately.

Examples:

```text
Boa constrictor
Chelonia mydas
Caiman latirostris
```

Display rules:

* genus begins with an uppercase letter;
* species and subspecies epithets use lowercase;
* the complete scientific name is italicized in rendered content;
* taxonomic author citation is not italicized when displayed.

Do not assume that a scientific name is permanently valid. Taxonomic revisions may occur.

### Taxonomic Status

When necessary, support:

* accepted;
* synonym;
* disputed;
* deprecated;
* unreviewed.

A taxonomic synonym must reference the accepted taxon when known.

Do not delete historical or synonymous names when they are needed for search and reference.

---

## Common Names

A species may have multiple common names.

Each common name may contain:

* name;
* language;
* country or region;
* preferred status;
* source;
* notes.

Example:

```json
{
  "name": "Green sea turtle",
  "language": "en",
  "region": "global",
  "preferred": true
}
```

Do not assume one common name is globally accepted.

Do not store multiple names as one comma-separated string.

Prefer a dedicated collection or relational structure.

A species should have one preferred display name per supported locale when possible.

---

## Editorial Groups

Initial editorial groups may include:

* snakes;
* lizards;
* turtles and tortoises;
* crocodilians;
* tuataras.

These groups exist for navigation and reader comprehension.

They must not be represented as taxonomic ranks.

A species may belong to one primary editorial group.

Future editorial groupings may include:

* aquatic reptiles;
* arboreal reptiles;
* desert reptiles;
* Brazilian reptiles;
* threatened reptiles.

These future groupings may be tags, collections, or curated categories rather than permanent species attributes.

Do not add an editorial group as a fixed database column if tags or collections better represent the requirement.

---

## Species Model

A species record represents reusable structured information about one biological taxon.

### Core Fields

The initial core may include:

* identifier;
* slug;
* preferred common name;
* scientific name;
* summary;
* editorial group;
* taxonomic classification;
* primary image;
* editorial status;
* author;
* created timestamp;
* updated timestamp;
* published timestamp.

### Extended Information

Extended species information may include:

* alternative common names;
* geographic distribution;
* habitat;
* diet;
* behavior;
* reproduction;
* physical characteristics;
* minimum size;
* maximum size;
* minimum weight;
* maximum weight;
* lifespan;
* ecological importance;
* ecosystem contribution;
* risk to humans;
* venom information;
* conservation assessments;
* threats;
* curiosities;
* references;
* gallery;
* related articles;
* tags.

Not all extended fields should be mandatory.

### Modeling Rule

Before adding a field, determine whether it is:

1. a single factual value;
2. a value with a range;
3. a value with a unit;
4. a value that varies by sex;
5. a value that varies by age;
6. a value that varies by region;
7. a source-specific assessment;
8. editorial prose;
9. structured repeatable data.

Do not use a single scalar field when the concept is naturally variable.

Example:

Do not model body length only as:

```text
length = 2.5
```

Prefer a structure that may represent:

```json
{
  "minimum": 1.8,
  "maximum": 2.5,
  "unit": "m",
  "measurementType": "total_length",
  "notes": "Typical adult range"
}
```

Only implement this level of structure when the feature requires it.

Avoid premature complexity.

---

## Species Page vs Article

A species page and an article are different products.

### Species Page

A species page should provide:

* structured reference information;
* stable navigation;
* scientific classification;
* concise educational sections;
* consistent presentation;
* reusable species data;
* links to references and related articles.

### Article

An article should provide:

* a narrative;
* an argument or educational objective;
* deeper context;
* comparisons;
* explanations;
* storytelling;
* multiple related species;
* authorial structure;
* publication metadata;
* revisions.

Do not store long editorial narratives directly inside the core species table when they are better represented by articles or structured content sections.

Do not duplicate the same content across species pages and articles without a clear reason.

---

## Article Domain

### Required Concepts

An article may contain:

* title;
* slug;
* subtitle;
* summary;
* cover image;
* structured content;
* author;
* editorial status;
* tags;
* related species;
* references;
* estimated reading time;
* SEO metadata;
* created timestamp;
* updated timestamp;
* publication timestamp;
* scheduled publication timestamp.

### Editorial Status

Supported statuses:

```text
draft
in_review
scheduled
published
archived
```

Allowed high-level transitions:

```text
draft -> in_review
draft -> archived

in_review -> draft
in_review -> scheduled
in_review -> published
in_review -> archived

scheduled -> draft
scheduled -> published
scheduled -> archived

published -> archived

archived -> draft
```

Do not implement all transitions automatically without explicit workflow requirements.

Publishing must validate required content.

### Publication Rules

Before an article can be published, validate at least:

* title exists;
* slug exists and is unique;
* summary exists;
* author exists;
* content contains meaningful text;
* cover image requirements are satisfied when mandatory;
* references are present for scientific claims when required;
* related media has attribution;
* scheduled publication date is valid when scheduled;
* content is sanitized;
* editorial status transition is allowed.

The precise validation policy may evolve.

---

## Structured Content

Article content should use structured blocks.

Initial supported blocks may include:

* paragraph;
* heading;
* unordered list;
* ordered list;
* image;
* quote;
* curiosity;
* reference.

Future blocks may include:

* gallery;
* alert;
* table;
* scientific classification;
* species card;
* map;
* embedded video;
* comparison;
* conservation status;
* timeline.

Each block should contain:

* block type;
* stable identifier;
* version when necessary;
* block-specific content;
* validation rules.

Do not store executable code in content blocks.

Do not trust raw HTML supplied by clients.

Do not render unsanitized markup.

### Example Paragraph Block

```json
{
  "id": "block-uuid",
  "type": "paragraph",
  "data": {
    "text": "Reptiles play important roles in food webs."
  }
}
```

### Example Heading Block

```json
{
  "id": "block-uuid",
  "type": "heading",
  "data": {
    "level": 2,
    "text": "Ecological importance"
  }
}
```

### Example Curiosity Block

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

Do not create a generic block capable of storing arbitrary unvalidated data.

Each block type must have an explicit schema.

---

## Geographic Distribution

Distribution data should distinguish:

* native;
* introduced;
* invasive;
* historical;
* current;
* uncertain.

A distribution record may contain:

* country;
* region;
* biome;
* locality;
* occurrence type;
* source;
* notes.

Do not claim exact distribution without a source.

Do not use only free text when geographic filtering is required.

Do not introduce complex geospatial infrastructure before a real map or geographic query requirement exists.

The first version may combine:

* structured region tags;
* editorial distribution text.

---

## Habitat

Habitats may be represented through controlled values and descriptive text.

Possible controlled values:

* tropical forest;
* temperate forest;
* savanna;
* grassland;
* desert;
* wetland;
* river;
* lake;
* coastal;
* marine;
* mangrove;
* rocky area;
* urban area;
* agricultural area.

A species may use multiple habitats.

Do not use a single mandatory habitat field if the species occupies several environments.

Do not confuse habitat with geographic distribution.

---

## Diet

Diet information should distinguish:

* dietary category;
* known prey or food items;
* life-stage variation;
* regional variation;
* opportunistic behavior.

Possible dietary categories:

* carnivore;
* herbivore;
* omnivore;
* insectivore;
* piscivore;
* molluscivore;
* scavenger;
* specialist;
* opportunistic feeder.

Do not force a species into only one category when its diet varies.

Avoid absolute claims such as “only eats” unless supported.

---

## Behavior

Behavior may include:

* activity period;
* social behavior;
* territorial behavior;
* defensive behavior;
* migration;
* thermoregulation;
* burrowing;
* climbing;
* swimming.

Possible activity periods:

* diurnal;
* nocturnal;
* crepuscular;
* cathemeral;
* variable.

Do not infer behavior from editorial group alone.

Do not generalize behavior from one population to the entire species without qualification.

---

## Reproduction

Reproductive information may include:

* reproductive mode;
* mating season;
* clutch or litter size;
* incubation or gestation;
* parental care;
* sexual maturity;
* nesting behavior.

Possible reproductive modes:

* oviparous;
* viviparous;
* ovoviviparous;
* parthenogenetic;
* variable.

Use careful terminology.

Do not state that all reptiles lay eggs.

---

## Physical Measurements

Measurements must include units.

Supported measurement concepts may include:

* total length;
* snout-to-vent length;
* carapace length;
* mass;
* lifespan;
* clutch size;
* incubation period.

Store normalized units when numerical filtering or comparison is required.

Display units may be localized.

Do not store values such as:

```text
"2 meters"
```

in a numeric field.

Do not mix minimum, maximum, and average values.

Each measurement should identify what it represents.

---

## Ecological Importance

The platform must explain why reptiles matter to ecosystems.

Possible ecological roles:

* predator;
* prey;
* seed disperser;
* scavenger;
* ecosystem engineer;
* population regulator;
* nutrient-cycle contributor;
* indicator species.

Do not automatically assign a role based only on taxonomy.

Ecological claims should be supported by references.

Avoid statements implying that a species exists primarily to benefit humans.

Prefer ecosystem-centered explanations.

---

## Contribution to Humans

When describing benefits to humans, separate them from ecological importance.

Possible areas:

* pest population control;
* scientific research;
* cultural relevance;
* medicine-related research;
* ecotourism;
* education;
* biodiversity value.

Avoid unsupported claims about medical or therapeutic benefits.

Do not promote direct interaction with wildlife.

Do not imply that wild reptiles should be kept as pets.

---

## Risk to Humans

Risk must be described carefully.

Do not classify reptiles only as:

* dangerous;
* harmless.

Risk may depend on:

* venom;
* body size;
* defensive behavior;
* habitat overlap;
* likelihood of encounter;
* regional context;
* human behavior;
* access to medical care.

Suggested editorial risk levels:

```text
minimal
low
moderate
high
context_dependent
unknown
```

These are editorial labels, not universal scientific standards.

Any risk level must be accompanied by explanatory text.

Do not use sensational language.

Do not provide instructions for handling, capturing, provoking, feeding, or relocating dangerous wildlife.

When relevant, advise users to contact local wildlife or emergency authorities.

---

## Venom and Poison Terminology

Use the terms correctly.

### Venomous

An animal that delivers toxin through a specialized mechanism such as a bite or sting.

### Poisonous

An organism that causes toxicity when touched, ingested, or otherwise consumed or absorbed.

Do not use “poisonous snake” when “venomous snake” is scientifically appropriate.

A venom-related record may include:

* venomous status;
* delivery mechanism;
* medically significant status;
* known effects;
* geographic context;
* source;
* review date.

Do not provide clinical treatment instructions.

Do not describe first aid beyond high-level safety guidance unless the platform later introduces medically reviewed content.

---

## Conservation

Conservation status must be source-aware and date-aware.

A conservation assessment may contain:

* authority;
* category;
* scope;
* publication year;
* assessment date;
* population trend;
* source URL or citation;
* notes.

Possible authorities:

* IUCN;
* national environmental authority;
* regional authority;
* recognized scientific organization.

Possible IUCN-style categories:

```text
NE
DD
LC
NT
VU
EN
CR
EW
EX
```

Do not present an assessment without identifying its authority.

Do not assume a global assessment applies to every local population.

Do not reduce conservation to a single permanent field when multiple assessments may coexist.

### Threats

Threats may include:

* habitat loss;
* illegal wildlife trade;
* road mortality;
* pollution;
* climate change;
* invasive species;
* hunting;
* persecution;
* disease;
* accidental capture;
* coastal development.

Threats should be linked to references when possible.

Avoid implying causation without evidence.

---

## References and Sources

Scientific and factual claims must support traceability.

A reference may contain:

* identifier;
* title;
* authors;
* publication;
* publication year;
* publisher;
* DOI;
* URL;
* access date;
* reference type;
* language;
* notes.

Reference types may include:

* peer-reviewed article;
* book;
* government publication;
* institutional database;
* museum publication;
* conservation assessment;
* thesis;
* technical report;
* trusted educational resource.

Prefer sources in this order when available:

1. peer-reviewed research;
2. recognized conservation authorities;
3. government environmental agencies;
4. museums, universities, and scientific institutions;
5. specialist books;
6. reputable educational organizations.

Do not treat:

* social media;
* unsourced blogs;
* commercial pet pages;
* AI-generated text;
* anonymous content

as authoritative scientific references.

### Claim Traceability

When feasible, allow references to be associated with:

* a species page;
* an article;
* a content section;
* a specific structured claim.

The initial version may associate references at the page or article level.

Do not create claim-level citation complexity unless required.

---

## Information Confidence

Some information may be uncertain or disputed.

When useful, support confidence values such as:

```text
confirmed
well_supported
probable
uncertain
disputed
unknown
```

Do not expose internal confidence labels to users unless the UX clearly explains them.

Prefer editorial language such as:

* “Studies suggest”;
* “Reported populations include”;
* “The species is believed to”;
* “Available evidence is limited”.

Do not convert uncertain information into definitive statements.

---

## Content Freshness

Some data may change over time.

Examples:

* conservation status;
* geographic distribution;
* legal protection;
* population trend;
* taxonomic acceptance.

For time-sensitive information, consider storing:

* source;
* assessed date;
* reviewed date;
* reviewer;
* next review date.

Do not assume that published content remains permanently current.

---

## Editorial Quality

Content must be:

* accurate;
* understandable;
* respectful;
* educational;
* well structured;
* free of sensationalism;
* accessible to non-specialists;
* transparent about uncertainty;
* supported by credible sources.

Avoid:

* excessive jargon;
* anthropomorphism;
* fear-based descriptions;
* pet-trade framing;
* unsupported superlatives;
* vague ecological claims;
* duplicated text;
* generic filler.

Scientific terms may be used when explained.

---

## Naming Conventions

Use consistent internal names.

Recommended English domain names:

```text
Species
Taxon
TaxonomicRank
CommonName
EditorialGroup
Article
ArticleRevision
ContentBlock
Reference
MediaAsset
ConservationAssessment
GeographicDistribution
Habitat
Diet
Behavior
Reproduction
Measurement
EcologicalRole
Threat
Tag
```

Avoid ambiguous names such as:

```text
Type
Info
Data
Detail
Item
Object
Category
```

unless the context makes their meaning explicit.

Use `species` as both singular and plural in English.

Do not use `specie` as the singular English noun.

---

## Slugs

Species and article slugs must be:

* lowercase;
* URL-safe;
* stable;
* unique within their resource type;
* generated from a preferred display title;
* editable only through controlled workflows.

Examples:

```text
green-sea-turtle
boa-constrictor
ecological-importance-of-snakes
```

Do not use scientific names or internal IDs as the only slug strategy without considering user readability.

When a title or preferred name changes, do not automatically break existing URLs.

A future redirect strategy may be required.

---

## Tags

Tags are flexible editorial metadata.

Examples:

* brazil;
* amazon;
* venomous;
* endangered;
* aquatic;
* nocturnal;
* conservation;
* ecology.

Tags must not replace:

* taxonomy;
* editorial groups;
* conservation assessments;
* structured habitat data;
* permissions.

Avoid creating near-duplicate tags.

Examples of problematic duplication:

```text
snake
snakes
serpent
serpents
```

Use a normalized slug and a display label.

---

## Validation Rules

Domain validation should be implemented close to the domain model when it represents an invariant.

Examples:

* scientific name cannot be blank for a publishable species;
* slug must follow the accepted format;
* publication date cannot be present for a draft unless explicitly supported;
* scheduled publication must have a future schedule date;
* a maximum measurement cannot be lower than a minimum;
* a reference must contain enough information to be identifiable;
* an accepted synonym cannot reference itself;
* an article cannot be published with empty content.

Transport validation should handle:

* malformed JSON;
* missing request properties;
* invalid primitive formats;
* payload size;
* unsupported media type.

Do not duplicate the same validation rule inconsistently across backend, frontend, and database.

Use the backend domain and application layers as the source of truth.

---

## Database Modeling Guidance

Before choosing a database representation, classify each concept.

### Use a regular column when:

* the value is central;
* it is frequently queried;
* it has a stable type;
* it has clear cardinality;
* it requires indexing or constraints.

### Use a related table when:

* the value repeats;
* it has metadata;
* it has independent lifecycle;
* it has many-to-many relationships;
* it requires filtering.

### Use JSONB when:

* the structure is flexible but still validated;
* the data is retrieved as a whole;
* the value is not heavily joined;
* schema evolution is expected;
* relational modeling would add unnecessary complexity.

Do not use JSONB to avoid domain modeling.

Do not create a table for every small value object without need.

---

## API Guidance

Public species responses should distinguish:

* identifiers;
* display information;
* taxonomy;
* descriptive content;
* media;
* references;
* publication metadata.

Avoid exposing database structure directly.

Do not expose internal editorial notes in public responses.

Do not expose unpublished content through public endpoints.

Administrative responses may contain:

* draft content;
* validation issues;
* workflow status;
* revision metadata;
* internal identifiers.

Public and administrative representations may differ.

---

## Search Guidance

Search should support:

* preferred common names;
* alternative common names;
* scientific names;
* taxonomic synonyms;
* article titles;
* article summaries;
* tags.

Search results should identify their resource type.

Examples:

```text
species
article
editorial_group
```

Do not merge species and articles into an indistinguishable response.

Filters should use structured domain values when possible.

Do not derive scientific filters from free-text article content.

---

## Localization Guidance

The initial internal implementation may use English identifiers.

User-facing content may support multiple languages in the future.

Do not mix translated content into a single string.

Potential localizable values include:

* common names;
* titles;
* subtitles;
* summaries;
* descriptions;
* article content;
* labels;
* SEO metadata.

Scientific names do not require translation.

Do not implement full localization before the corresponding requirement exists.

Design domain identifiers so localization can be added later.

---

## Safety and Ethical Content

Do not generate platform content that:

* encourages handling dangerous reptiles;
* teaches users to capture wild animals;
* promotes illegal wildlife trade;
* encourages keeping protected wildlife;
* provides instructions for harming reptiles;
* supports wildlife trafficking;
* provides unsafe bite-treatment instructions;
* minimizes emergency situations;
* encourages feeding or approaching wild reptiles.

Educational content may explain:

* ecological roles;
* safe observation;
* coexistence;
* conservation;
* general risk awareness;
* when to contact local authorities.

The platform should promote respect for wildlife and legal conservation practices.

---

## Content Review Checklist

Before publishing species information or an article, verify:

### Identification

* Is the scientific name correct?
* Is the preferred common name appropriate for the locale?
* Are alternative names represented separately?
* Is taxonomy distinguished from editorial grouping?

### Accuracy

* Are major claims supported?
* Are ranges and estimates presented correctly?
* Is uncertainty acknowledged?
* Are outdated classifications avoided?

### Ecology

* Is ecological importance explained?
* Are claims ecosystem-centered?
* Are threats and conservation concerns represented responsibly?

### Risk

* Is risk described without sensationalism?
* Are venomous and poisonous used correctly?
* Are unsafe interaction instructions absent?

### References

* Are sources credible?
* Are references identifiable?
* Are conservation assessments dated and attributed?
* Are images credited and licensed?

### Editorial quality

* Is the content readable?
* Is jargon explained?
* Is the structure clear?
* Is duplicated content avoided?

### Publication

* Is the content complete enough for the intended status?
* Are required fields present?
* Are media assets accessible?
* Is the slug valid?
* Is the content sanitized?

---

## Implementation Workflow

When using this skill:

1. identify the domain concept being changed;
2. classify it as scientific, editorial, operational, or technical;
3. inspect existing terminology and models;
4. identify invariants;
5. identify source and confidence requirements;
6. determine the correct ownership boundary;
7. propose the smallest viable model;
8. evaluate database and API impacts;
9. define validation rules;
10. define required tests;
11. update domain documentation;
12. verify editorial and scientific consistency.

---

## Expected Deliverables

Depending on the task, deliverables may include:

* domain terminology;
* entity definitions;
* value objects;
* validation rules;
* state transitions;
* database modeling guidance;
* API field definitions;
* frontend presentation rules;
* search metadata;
* editorial checklists;
* reference requirements;
* ADR recommendations;
* tests for domain invariants.

Do not create technical implementation unrelated to the requested domain task.

---

## Testing Guidance

Domain tests should verify behavior and invariants.

Examples:

* valid and invalid scientific names;
* publication rules;
* editorial status transitions;
* measurement ranges;
* common-name localization;
* synonym relationships;
* reference requirements;
* invalid slug formats;
* conservation assessment source requirements.

Avoid tests that only verify field assignment.

Prefer table-driven tests in Go for validation-heavy domain rules.

Test edge cases such as:

* missing values;
* disputed information;
* duplicate names;
* invalid ranges;
* self-referencing taxonomy;
* publication without references when references are mandatory.

---

## Documentation Requirements

When domain terminology or structure changes, evaluate updates to:

```text
docs/product/
docs/architecture/
docs/adr/
docs/api/
README.md
```

Recommended domain documents:

```text
docs/product/domain-glossary.md
docs/product/species-content-model.md
docs/product/article-content-model.md
docs/product/taxonomy.md
docs/product/editorial-guidelines.md
docs/product/reference-policy.md
```

Do not leave major domain decisions documented only in code.

---

## Definition of Done

A domain-related task is complete only when:

* the concept has a clear definition;
* taxonomy and editorial grouping are not confused;
* terminology is consistent;
* invariants are identified;
* uncertain information can be represented safely;
* source requirements are defined;
* API and database impacts are evaluated;
* tests cover important rules;
* documentation is updated;
* the model does not introduce unnecessary complexity;
* no unsafe wildlife guidance is introduced.

---

## Prohibited Practices

Do not:

* use `specie` as a singular English noun;
* mix scientific taxonomy with editorial groups;
* store all species information in one unstructured text field;
* store every detail in one excessively wide table;
* represent multiple common names as comma-separated text;
* treat conservation status as timeless;
* publish scientific claims without sources when sources are required;
* use sensational descriptions;
* label every reptile as dangerous;
* encourage wildlife handling;
* provide medical treatment instructions;
* treat commercial pet websites as scientific authorities;
* translate scientific names;
* use raw unsanitized HTML;
* create tags as replacements for structured taxonomy;
* create a complex generalized biology ontology without a concrete requirement;
* invent facts to fill incomplete species records.

---

## Completion Report

After completing a domain-related task, report:

```markdown
## Domain concept

## Definitions

## Invariants

## Modeling decisions

## Source and confidence requirements

## API and database impact

## Validation rules

## Tests

## Documentation updates

## Limitations
```

Keep the report based on actual changes and decisions.

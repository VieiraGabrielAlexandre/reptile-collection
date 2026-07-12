# Product Vision

## Target Audience

* visitors and members seeking trustworthy, accessible information about reptiles;
* editors and administrators who create and curate scientific and educational content;
* future contributors who need a stable domain model to extend the platform.

## Problem

Reliable, well-structured, and editorially consistent information about reptiles is scattered across pet-commerce sites, unsourced blogs, and inconsistent wildlife pages. There is no single trustworthy, educational, and ecologically grounded reference that clearly separates scientific taxonomy from editorial content, sources every claim, and presents risk information responsibly.

## Product Value

Reptile Collection provides:

* a structured knowledge base combining species reference pages and long-form editorial articles;
* clear separation between scientific taxonomy and editorial groupings;
* source-attributed conservation, ecological, and risk information;
* an elegant, responsive, accessible, and trustworthy reading experience;
* a foundation that can evolve toward user accounts, an editorial workflow, and gamified learning without premature complexity.

## Principles

* simplicity before abstraction;
* evolutionary architecture — a modular monolith, not microservices;
* scientific accuracy over sensationalism;
* uncertainty represented honestly rather than hidden;
* accessibility and security by default;
* documentation as part of the product;
* no dependency on paid external services in the local environment.

## Initial Scope

* only administrators and editors can create content;
* users may create accounts, but regular users may not publish articles;
* no comments, forums, or public social interaction;
* gamification is deferred to a later phase.

## Non-Goals (Initial Phases)

* community-generated content;
* social features (comments, forums, following);
* microservices architecture;
* production AWS deployment before the local foundation, catalog, authentication, and administration are complete;
* veterinary, medical, legal, or emergency wildlife-handling guidance — the platform is educational, not operational, guidance.

## Long-Term Direction

Reptile Collection is expected to grow through the phases defined in [the roadmap](roadmap.md): from a local-only foundation, through a public catalog, user accounts, an administrative editorial workflow, an advanced editorial experience, gamification, and finally a real AWS deployment. Each phase is implemented only when explicitly started; the project does not self-advance.

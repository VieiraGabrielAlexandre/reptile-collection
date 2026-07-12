# ADR-0005: Use S3-Compatible Storage for Media

## Status

Accepted

## Context

Species and article content require image (and later gallery/video) media with metadata such as alt text, caption, credit, source, and license. The local environment must not require a real AWS account, while the future AWS environment should use a durable, scalable, CDN-friendly object store.

## Decision

Use **S3-compatible object storage** for all media assets: **LocalStack-emulated S3** in the local environment, and **real S3** (fronted by CloudFront where appropriate) in the future AWS environment. Every media asset is modeled as a first-class entity with required metadata, not merely a URL.

## Consequences

Positive:

* the same application code path (an `ObjectStorage` port) works against both LocalStack and real S3 by changing only configuration/endpoints;
* the local environment requires no real AWS credentials;
* required metadata (alt text, credit, license) is enforced at the domain level rather than left implicit.

Negative:

* LocalStack does not perfectly reproduce every AWS S3 behavior (e.g. IAM enforcement), so some behavior can only be fully validated against real AWS in a later phase;
* image processing (thumbnails, responsive variants) is deferred and will require its own decision when a concrete requirement exists.

## Alternatives Considered

* **Storing images as database blobs** — rejected; unsuitable for media at scale and inconsistent with `CLAUDE.md`'s prohibition on treating an image as only a URL or storing base64 images in content.
* **A different local S3 emulator or a shared real bucket for local development** — rejected; LocalStack keeps the local environment fully self-contained and free of real cloud credentials.

## Related Decisions

None yet.

# ADR-0004: Use Keycloak Locally and Cognito on AWS

## Status

Accepted

## Context

The platform needs an identity provider that authenticates users, so the application itself never stores passwords. The local environment must not require real AWS credentials or a real Cognito user pool, since `CLAUDE.md` requires the local environment to work without paid external services or real cloud credentials. The future AWS environment, however, should use a managed, AWS-native identity provider rather than self-hosting one.

## Decision

Use **Keycloak** as the identity provider in the local environment, and **AWS Cognito** as the identity provider in the future AWS environment. The application maintains a provider-neutral internal identity abstraction (external identifier, email, name, roles, permissions, account status) so that domain and application code never depend directly on Keycloak- or Cognito-specific types or claim formats.

## Consequences

Positive:

* the local environment remains fully self-contained and requires no real AWS account;
* Cognito on AWS avoids operating a self-hosted identity provider in production;
* the provider-neutral identity abstraction limits the blast radius of switching providers to the authentication module's adapters.

Negative:

* Keycloak and Cognito represent roles, groups, and claims differently, requiring dedicated adapters/mappers for each;
* behavior must be verified against both providers rather than assumed identical; local testing cannot guarantee full production parity.

## Alternatives Considered

* **Cognito everywhere (including locally)** — rejected; it would require real AWS credentials for local development, violating the project's local-environment principles.
* **Keycloak everywhere (including production)** — rejected; it would require operating and securing a self-hosted identity provider in production instead of using a managed AWS service.
* **A fully custom authentication system** — rejected; `CLAUDE.md` explicitly disallows implementing custom password storage when an identity provider owns credentials.

## Related Decisions

None yet.

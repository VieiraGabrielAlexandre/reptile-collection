# ADR-0009: Keycloak realm as code, coarse roles only

## Status

Accepted

## Context

ADR-0004 chose Keycloak locally and Cognito on AWS. The local identity provider must be reproducible after `make reset` without manual console steps, and authorization must not become irreversibly coupled to one provider's claim format, since Cognito represents roles differently (groups) than Keycloak (`realm_access.roles`).

## Decision

* The local realm is versioned as `infrastructure/keycloak/import/reptile-collection-realm.json` and imported with `start-dev --import-realm`. Local test-user passwords come from `.env` via Keycloak's `${ENV}` placeholder substitution.
* Keycloak holds only **coarse realm roles** (`member`, `editor`, `administrator`); `member` is the default role for new accounts.
* **Application permissions are owned by the application database**, resolved by the backend from the authenticated identity (Phase 2). Keycloak role claims may seed or assist local development but are not the authorization source of truth.
* The browser uses a public client with Authorization Code + PKCE (S256 enforced); the password grant is disabled. Access tokens carry the audience `reptile-collection-api`, which the backend must validate.
* The issuer is pinned with `KC_HOSTNAME` so tokens have the same `iss` whether the backend reaches Keycloak through `localhost` or the Compose network.

## Consequences

Positive:

* `make reset` and `make keycloak-reimport` recreate the realm deterministically;
* switching to Cognito changes the token verifier and identity mapping, not the permission model;
* `make keycloak-check` gives a fast, real end-to-end check of the login contract.

Negative:

* realm changes made in the admin console are lost unless copied back into the JSON file;
* re-importing deletes locally created accounts;
* role assignments exist in two places (Keycloak coarse roles and, from Phase 2, the application database) and need a documented synchronization rule.

## Alternatives Considered

* **Manual console setup** — rejected; not reproducible.
* **Terraform Keycloak provider** — heavier than a realm import for a local-only provider that will be replaced by Cognito.
* **Fine-grained permissions as Keycloak client roles** — rejected; couples authorization to Keycloak's claim format and does not map to Cognito.

## Related Decisions

* [ADR-0004](0004-use-keycloak-locally-and-cognito-on-aws.md)

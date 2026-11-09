# Keycloak (local identity provider)

Local development only. On AWS the identity provider will be Cognito (ADR-0004).

## What is configured

`import/reptile-collection-realm.json` is the single source of truth for the local realm. It is imported automatically by `start-dev --import-realm` (see `compose.yaml`) **only when the realm does not exist yet**.

| Item | Value |
|---|---|
| Realm | `reptile-collection` (never use `master` for application users) |
| Issuer (`iss`) | `http://localhost:8081/realms/reptile-collection` — the same for browsers and containers (`KC_HOSTNAME`) |
| JWKS from containers | `http://keycloak:8080/realms/reptile-collection/protocol/openid-connect/certs` |
| Web client | `reptile-collection-web` — public, Authorization Code + PKCE (S256 required), no secret, password grant disabled |
| Redirect URIs / web origin | `http://localhost:3000/*` / `http://localhost:3000` |
| API audience | `reptile-collection-api` — added to the web client's access tokens by an audience mapper |
| Realm roles | `member` (default for every new account), `editor`, `administrator` |
| Registration | enabled, email as username, email verification required |
| Password policy | 12+ characters, not the username or email |
| Email | SMTP to Mailpit (`mailpit:1025`), visible at http://localhost:8025 |

`visitor` is not a Keycloak role: it means "not signed in".

### Roles vs permissions

Keycloak holds only coarse roles. Application permissions (`species:create`, `articles:publish`, ...) are **not** modeled in Keycloak: the backend will resolve them from the application database in Phase 2 ([ADR-0009](../../docs/adr/0009-keycloak-realm-as-code-and-role-ownership.md)). Do not add permissions or client roles here without revisiting that ADR.

## Local test users

All share the password `KEYCLOAK_TEST_USER_PASSWORD` from `.env` (substituted at import time).

| User | Realm roles |
|---|---|
| `member@example.test` | `member` |
| `editor@example.test` | `member`, `editor` |
| `admin@example.test` | `member`, `administrator` |

Keycloak admin console: http://localhost:8081/admin (realm `master`, `KEYCLOAK_ADMIN` / `KEYCLOAK_ADMIN_PASSWORD`). The admin account is infrastructure-only and never an application user.

## Commands

```bash
make keycloak-check      # real PKCE login for each test user + token claim and hardening checks
make keycloak-reimport   # delete the local realm and import it again from the JSON file
```

## Changing the realm

1. Edit `import/reptile-collection-realm.json` (or change it in the admin console and copy the relevant part back — never commit a full export with secrets or generated IDs).
2. `make keycloak-reimport` — this **deletes users created locally** (registrations, password changes).
3. `make keycloak-check`.

Changing `KEYCLOAK_TEST_USER_PASSWORD` also requires `make keycloak-reimport`. Changing `KEYCLOAK_DB_PASSWORD` requires `make reset CONFIRM=1` (the database role is created only once).

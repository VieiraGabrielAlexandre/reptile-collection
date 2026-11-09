# Runbook: Local Development

## Purpose

Help a developer diagnose and recover from common local-environment problems.

## Status

**Active.** Commands below are verified against the Phase 0 Docker Compose environment, including the Keycloak realm. LocalStack resources are created by Terraform (`make tf-apply-local`).

## Symptoms

* a service fails to start;
* a port is already in use;
* the backend cannot reach PostgreSQL;
* the frontend cannot reach the backend;
* Keycloak's realm was not imported;
* a LocalStack bucket is missing;
* Mailpit does not receive email.

## Impact

Local development is blocked until the affected service is healthy.

## Detection

```bash
make ps             # docker compose ps
```

identifies unhealthy or stopped services. `make up` itself fails when a service does not become healthy.

## Immediate Checks

1. Confirm Docker and Docker Compose are installed and running.
2. Confirm `.env` exists (`cp .env.example .env` if missing).
3. Confirm no other process is using the required host ports (3000, 8080, 8081, 8025, 1025, 4566, 5433): `ss -ltnp | grep -E ':(3000|8080|8081|8025|1025|4566|5433) '`. Change the port in `.env` or pass it once, e.g. `make up API_PORT=18080`.

## Diagnostic Commands

```bash
make ps
make logs SERVICE=api
make logs SERVICE=postgres
make logs SERVICE=keycloak
docker compose config -q
make migrate-status
curl --fail http://localhost:8080/health
curl --fail http://localhost:8080/ready
curl --fail http://localhost:4566/_localstack/health
```

## Likely Causes

* missing or stale `.env`;
* a port conflict with another local process;
* a dependency (PostgreSQL, Keycloak) not yet healthy when a dependent service started;
* a stale Docker volume from a previous incompatible version;
* `/ready` returns `503`: PostgreSQL is down or `DATABASE_URL` is wrong — the `api` log line `readiness check failed` shows the cause;
* Keycloak fails to authenticate to its database after `KEYCLOAK_DB_PASSWORD` changed — the `keycloak` role is created only on the first PostgreSQL start; reset the environment;
* Keycloak unhealthy right after a realm change — `make logs SERVICE=keycloak` shows the import error (e.g. a role referenced but not declared); fix the JSON and `make up` again;
* realm missing or outdated — the import runs only when the realm does not exist; run `make keycloak-reimport`, then `make keycloak-check`;
* media bucket missing (`NoSuchBucket`) — LocalStack restarted and lost its state; run `make tf-apply-local`;
* migration left `dirty` — fix the database manually, then `docker compose run --rm migrate force <version>`;
* inside a container, `localhost` may resolve to IPv6 `::1` while a server listens on IPv4 only — health checks use `127.0.0.1`.

## Mitigation

Restart the affected service:

```bash
docker compose restart <service>
```

## Recovery

If local data is safe to discard: `make reset CONFIRM=1`, then `make up && make migrate && make seed`. Without `CONFIRM=1` it only prints a warning. Never run a global `docker system prune` as part of project reset; it affects unrelated projects.

## Verification

Re-run the diagnostic commands above and confirm all services report healthy.

## Escalation

If the problem persists after a clean reset, it is likely a defect — use `/fix-bug` with the specific reproduction command.

## Follow-Up

Add Keycloak realm and LocalStack resource checks when those increments land.

# Runbook: Local Development

## Purpose

Help a developer diagnose and recover from common local-environment problems.

## Status

**Planned.** No local environment (Docker Compose, Makefile, backend, frontend) exists yet — this runbook currently documents intended diagnostics only. It must be revised with real, verified commands once Phase 0 local-development work is implemented.

## Symptoms (Anticipated, Once Implemented)

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

Once implemented, detection will use:

```bash
docker compose ps
```

to identify unhealthy or stopped services.

## Immediate Checks (Once Implemented)

1. Confirm Docker and Docker Compose are installed and running.
2. Confirm `.env` exists (`cp .env.example .env` if missing).
3. Confirm no other process is using the required ports (3000, 8080, 8081, 8025, 4566, 5432, 6379).

## Diagnostic Commands (Once Implemented)

```bash
docker compose ps
docker compose logs api
docker compose logs postgres
docker compose logs keycloak
docker compose config
curl --fail http://localhost:8080/health
curl --fail http://localhost:8080/ready
curl --fail http://localhost:4566/_localstack/health
```

## Likely Causes

* missing or stale `.env`;
* a port conflict with another local process;
* a dependency (PostgreSQL, Keycloak) not yet healthy when a dependent service started;
* a stale Docker volume from a previous incompatible version.

## Mitigation

Restart the affected service:

```bash
docker compose restart <service>
```

## Recovery

If local data is safe to discard, a full reset is available via `make reset` **once implemented** — this command must warn before removing local containers and volumes, since local data will be lost. Never run a global `docker system prune` as part of project reset; it affects unrelated projects.

## Verification

Re-run the diagnostic commands above and confirm all services report healthy.

## Escalation

If the problem persists after a clean reset, it is likely a defect — use `/fix-bug` with the specific reproduction command once the project has a working local environment.

## Follow-Up

Update this runbook with real symptoms and verified commands as soon as the Phase 0 local-development foundation exists.

# ADR-0007: Use Isolated Terraform Environment Directories

## Status

Accepted

## Context

The project will eventually manage infrastructure across `local`, `development`, `staging`, and `production` environments. These environments must never share Terraform state, since a mistake in one environment's plan or apply must not be able to affect another — especially production. The local environment must also be clearly separated from any real AWS target, since local Terraform runs point at LocalStack with dummy credentials.

## Decision

Structure Terraform as reusable **modules** (`networking`, `database`, `compute`, `storage`, `authentication`, `messaging`, `observability`, `security`) under `infrastructure/terraform/modules/`, composed by separate **root modules** per environment under `infrastructure/terraform/environments/{local,development,staging,production}/`, each with its own state and provider configuration. The `local` environment configures the AWS provider with explicit LocalStack endpoints and dummy credentials; it never targets real AWS. Real AWS environments never use LocalStack endpoints. `terraform apply` and `terraform destroy` are never run against a real AWS account without explicit, unambiguous authorization.

## Consequences

Positive:

* state isolation prevents a local or lower-environment mistake from affecting staging or production;
* modules stay reusable and composable across environments instead of duplicating full infrastructure definitions;
* the local/real-AWS boundary is explicit and configuration-driven, reducing the risk of an accidental real-AWS mutation.

Negative:

* environment composition requires discipline to avoid drift between environment root modules;
* module inputs must be designed carefully to avoid environment-specific hardcoding while still supporting real differences (e.g. Multi-AZ in production only).

## Alternatives Considered

* **Terraform workspaces instead of separate directories** — rejected for production-critical environments; `CLAUDE.md` and the `terraform-aws` skill favor separate root directories, separate backend keys, and potentially separate AWS accounts over workspace-only separation.
* **One shared state for all environments** — rejected; it would make an accidental production impact far more likely.

## Related Decisions

* [ADR-0004](0004-use-keycloak-locally-and-cognito-on-aws.md) — the `local` Terraform environment does not provision Cognito, PostgreSQL, or Redis; those remain Docker Compose or Keycloak-managed locally.

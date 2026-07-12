# Roadmap

This roadmap reflects the official project phases defined in `CLAUDE.md`. The project does not advance to a new phase without explicit instruction, and a phase is not marked complete without validation evidence.

Status labels used below: `Not started`, `In progress`, `Complete`.

---

## Phase 0 — Foundation

**Status:** In progress (governance and documentation foundation established; application implementation not started)

**Objective:** Establish a reproducible local foundation: repository structure, Claude Code governance, minimal backend and frontend, database, local infrastructure services, initial Terraform structure, CI, tests, lint, and health checks.

**Scope:** monorepo layout; `CLAUDE.md` and skills; Docker Compose; minimal Go backend with health/readiness; minimal React frontend; PostgreSQL with migrations; Redis; LocalStack; Keycloak; Mailpit; initial Terraform local-environment structure; CI; baseline tests and lint.

**Exclusions:** the public catalog, authentication flows, administration, gamification, and any real AWS deployment.

**Dependencies:** none — this is the first phase.

**Acceptance criteria:** see [docs/product/phases/phase-0.md](phases/phase-0.md).

---

## Phase 1 — Public Catalog

**Status:** Not started

**Objective:** Let visitors browse published species and articles.

**Scope:** species listing and detail pages; article listing and detail pages; taxonomy; public search and filters; seed data; responsive public layout.

**Exclusions:** authentication, administration, gamification.

**Dependencies:** Phase 0 complete (backend, frontend, database, and local environment running).

---

## Phase 2 — Users and Authentication

**Status:** Not started

**Objective:** Let users register, sign in, and manage a profile.

**Scope:** registration, login, logout, email confirmation, account recovery (via Keycloak); local user synchronization; roles; permissions; protected routes.

**Exclusions:** the administration dashboard.

**Dependencies:** Phase 0 complete; Keycloak reproducibly initialized.

---

## Phase 3 — Administration

**Status:** Not started

**Objective:** Let editors and administrators manage content.

**Scope:** admin dashboard; species and article CRUD; media upload; editorial workflow (draft → review → scheduled → published → archived); preview; publishing; audit events.

**Exclusions:** advanced editorial blocks beyond the initial supported set; gamification.

**Dependencies:** Phase 2 authentication and authorization complete; media storage available.

---

## Phase 4 — Advanced Editorial Experience

**Status:** Not started

**Objective:** Extend the editorial system with richer content and discovery.

**Scope:** advanced content blocks (gallery, table, map, embedded video, etc.); article revisions; advanced SEO; social sharing metadata; related content.

**Dependencies:** Phase 3 administration complete; content schema versioned.

---

## Phase 5 — Gamification

**Status:** Not started

**Objective:** Introduce backend-owned progress and engagement mechanics.

**Scope:** activity events; reading progress; achievements; collections; quizzes; levels; anti-abuse and idempotency controls.

**Dependencies:** authentication complete; public content stable; privacy and security review complete.

---

## Phase 6 — AWS Deployment

**Status:** Not started

**Objective:** Deploy the platform to real AWS infrastructure.

**Scope:** Terraform-managed VPC, ECS Fargate, ECR, ALB, RDS PostgreSQL, ElastiCache (if required), S3, CloudFront, Cognito, SES, SQS (if required), CloudWatch, WAF, Route 53, ACM, Secrets Manager; CI/CD; backups; deployment and rollback runbooks.

**Dependencies:** application behavior stable locally; security review complete; Terraform modules validated; deployment explicitly authorized. `terraform apply` and `terraform destroy` are never run against a real AWS account without explicit authorization.

---

name: terraform-aws
description: Defines Terraform and AWS infrastructure standards for the reptile knowledge platform. Use this skill for Terraform modules, environments, providers, LocalStack integration, AWS architecture, state management, security, networking, storage, compute, authentication, observability, validation, and infrastructure documentation.
when_to_use: Use whenever a task creates, changes, reviews, plans, validates, or documents Terraform, LocalStack-backed infrastructure, AWS architecture, cloud environments, provider configuration, remote state, IAM, networking, compute, storage, databases, messaging, or deployment foundations.
argument-hint: "[terraform-or-aws-task]"
disable-model-invocation: false
user-invocable: true
model: inherit
effort: high
paths:

* "infrastructure/terraform/**"
* "infrastructure/localstack/**"
* "**/*.tf"
* "**/*.tfvars"
* "**/*.tfvars.json"
* ".terraform.lock.hcl"
* "docs/architecture/deployment.md"
* "docs/runbooks/**"
* ".github/workflows/**"

---

# Terraform and AWS

## Objective

Define and enforce Terraform and AWS infrastructure standards for the reptile knowledge platform.

Use this skill to guide:

* Terraform structure;
* reusable modules;
* environment composition;
* provider configuration;
* LocalStack integration;
* AWS architecture;
* networking;
* compute;
* storage;
* databases;
* caching;
* authentication;
* messaging;
* observability;
* IAM;
* state management;
* validation;
* security;
* cost awareness;
* infrastructure documentation.

The current task is:

```text
$ARGUMENTS
```

If no arguments were provided, infer the task from the current conversation.

---

## Mandatory Context

Before changing infrastructure:

1. Read `${CLAUDE_PROJECT_DIR}/CLAUDE.md`.
2. Read the `local-development`, `security`, `observability`, `authentication`, `database`, and `documentation` skills when relevant.
3. Inspect existing Terraform modules and environment compositions.
4. Inspect `.terraform.lock.hcl`.
5. Inspect provider versions.
6. Inspect LocalStack configuration.
7. Inspect current Docker Compose responsibilities.
8. Identify the current project phase.
9. Identify whether the target is local emulation or real AWS.
10. Identify whether the operation is read-only, planning, or mutating.
11. Confirm that no real AWS deployment is performed without explicit authorization.
12. Preserve existing state and naming conventions.

Do not assume a local Terraform environment behaves exactly like AWS.

Do not run `terraform apply` against a real AWS account without explicit user authorization.

---

## Core Principles

Infrastructure must be:

* declarative;
* reproducible;
* reviewable;
* modular;
* secure by default;
* environment-aware;
* cost-conscious;
* observable;
* documented;
* easy to validate;
* safe to plan;
* resistant to accidental production changes.

Prefer the smallest infrastructure that supports the current phase.

Do not create production resources during local foundation work.

Do not model hypothetical future infrastructure in excessive detail.

---

## Infrastructure Scope by Phase

### Phase 0 — Foundation

Terraform may include:

* base directory structure;
* provider configuration;
* local environment;
* LocalStack endpoints;
* local S3 bucket;
* optional local SQS resources only when needed;
* validation commands;
* documentation.

Do not create real AWS resources.

### Phase 1 — Public Catalog

Terraform may prepare:

* media storage;
* public-content delivery design;
* application environment variables;
* future deployment diagrams.

Do not deploy before explicit instruction.

### Phase 2 — Authentication

Terraform may introduce future Cognito module design.

Do not create Cognito locally through speculative emulation if Keycloak already covers local authentication.

### Phase 3 — Administration

Terraform may prepare:

* private media workflows;
* administrative access paths;
* audit and logging requirements.

### Phase 4 — Advanced Editorial Experience

Terraform may add:

* image-processing components;
* CDN behavior;
* metadata and cache rules;
* event-driven media processing.

Only when required.

### Phase 5 — Gamification

Terraform may add:

* event queues;
* workers;
* scheduled jobs;
* operational metrics.

Only when actual workloads exist.

### Phase 6 — AWS Deployment

Terraform may implement:

* networking;
* compute;
* database;
* cache;
* storage;
* CDN;
* authentication;
* messaging;
* observability;
* security;
* DNS;
* certificates;
* backup;
* deployment foundation.

Do not advance to Phase 6 automatically.

---

## Recommended Terraform Structure

Use:

```text
infrastructure/terraform/
├── modules/
│   ├── networking/
│   ├── compute/
│   ├── database/
│   ├── cache/
│   ├── storage/
│   ├── authentication/
│   ├── messaging/
│   ├── observability/
│   └── security/
└── environments/
    ├── local/
    ├── development/
    ├── staging/
    └── production/
```

Each environment composes modules.

Do not duplicate full infrastructure definitions across environments.

Do not create empty modules only to match the directory plan.

Create a module only when there is a real reusable or encapsulated responsibility.

---

## Module Design

A module should:

* own a coherent infrastructure responsibility;
* expose minimal inputs;
* expose useful outputs;
* avoid hidden assumptions;
* avoid environment-specific hardcoding;
* document required providers;
* document resource behavior;
* remain understandable without reading every implementation detail.

Good examples:

```text
modules/storage
modules/networking
modules/database
```

Avoid vague modules such as:

```text
modules/common
modules/shared
modules/platform
modules/misc
```

unless their responsibility is explicit.

---

## Root Module vs Child Modules

Environment directories are root modules.

Example:

```text
infrastructure/terraform/environments/development
```

They may own:

* provider configuration;
* backend configuration;
* environment-specific variables;
* module composition;
* environment outputs.

Child modules should not configure providers unless a provider alias or special case requires it.

Prefer passing provider configurations from the root.

---

## File Organization

A Terraform root or module may use:

```text
main.tf
variables.tf
outputs.tf
versions.tf
locals.tf
data.tf
```

Additional files may be grouped by concern:

```text
iam.tf
network.tf
logging.tf
alarms.tf
```

Do not split every resource into a separate file.

Do not place all infrastructure in one massive `main.tf`.

Choose structure based on readability.

---

## Terraform Version

Pin a minimum supported Terraform version.

Example:

```hcl
terraform {
  required_version = ">= 1.8, < 2.0"
}
```

Use the version actually supported by the project and CI.

Do not use an unbounded version constraint.

Do not pin to one patch release without a compatibility reason.

---

## Provider Versions

Pin provider versions.

Example:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

Use a version compatible with the current implementation and validation environment.

Do not use provider versions from examples without checking actual compatibility.

Commit:

```text
.terraform.lock.hcl
```

for root modules according to repository policy.

Do not manually edit the lock file.

---

## Provider Configuration

Real AWS environment example:

```hcl
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}
```

Do not hardcode credentials.

Use supported AWS credential resolution.

Do not configure access keys directly in Terraform files.

---

## LocalStack Provider Configuration

A local provider may use explicit LocalStack endpoints.

Directional example:

```hcl
provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3  = var.localstack_endpoint
    sqs = var.localstack_endpoint
    ses = var.localstack_endpoint
  }
}
```

Exact arguments depend on the AWS provider version.

Validate current provider syntax before implementation.

Do not copy legacy endpoint syntax without checking compatibility.

---

## LocalStack Safety

Local Terraform must:

* use explicit LocalStack endpoints;
* use dummy credentials;
* avoid the developer's default real AWS profile;
* avoid unsupported resources;
* document emulation differences;
* create only resources needed locally.

Do not let missing endpoint configuration silently target AWS.

A safe local wrapper or environment file may be used.

Example:

```bash
AWS_ACCESS_KEY_ID=test
AWS_SECRET_ACCESS_KEY=test
AWS_REGION=us-east-1
```

Still configure explicit endpoints.

---

## Backend State

### Local Environment

Local Terraform state may use:

```hcl
backend "local" {}
```

or default local state behavior.

State files must not be committed.

Add to `.gitignore`:

```text
*.tfstate
*.tfstate.*
.terraform/
```

### Real AWS Environments

Future remote state may use:

* S3 backend;
* state encryption;
* state locking mechanism supported by the chosen Terraform and AWS architecture;
* versioning;
* restricted IAM;
* separate state per environment.

Do not implement real remote-state infrastructure before the AWS phase unless explicitly requested.

---

## State Isolation

Each environment must have isolated state.

Do not share one state file across:

```text
development
staging
production
```

Avoid workspace-only separation for critical production environments unless the strategy is documented and accepted.

Preferred direction:

* separate root directories;
* separate backend keys;
* separate variable sets;
* potentially separate AWS accounts.

---

## State Security

Terraform state may contain sensitive data.

Requirements:

* do not commit state;
* encrypt remote state;
* restrict read access;
* enable versioning;
* avoid sensitive outputs when unnecessary;
* mark sensitive values;
* avoid storing secrets directly in resource arguments when alternatives exist.

Do not print state content in logs.

Do not share state files casually.

---

## Environment Strategy

Use environments:

```text
local
development
staging
production
```

### Local

* uses LocalStack;
* no real AWS resources;
* supports developer workflows;
* may implement only supported services.

### Development

* lowest real AWS environment;
* supports integration testing;
* may use reduced capacity;
* still follows security standards.

### Staging

* production-like;
* validates release behavior;
* uses isolated data and identity.

### Production

* highest protection;
* explicit approvals;
* backups;
* monitoring;
* restrictive IAM;
* controlled changes.

Do not assume development and production differ only by instance size.

---

## Account Strategy

Future real AWS environments should ideally use separate AWS accounts or clearly isolated organizational units.

At minimum:

* production must be isolated;
* state must be isolated;
* IAM must be isolated;
* DNS and certificates must be controlled;
* destructive access must be restricted.

Do not design around one unrestricted personal AWS account as the final production model.

---

## Naming Convention

Use deterministic resource names.

A naming pattern may include:

```text
project
environment
resource purpose
```

Example:

```text
reptile-archive-dev-media
reptile-archive-prod-api
```

Be aware of AWS service naming constraints and global uniqueness.

Use locals:

```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"
}
```

Do not create excessively long names that exceed service limits.

Do not include mutable values in stable resource names.

---

## Tags

Apply common tags.

Recommended tags:

```text
Project
Environment
ManagedBy
Owner
CostCenter
DataClassification
```

Not every tag is required in local emulation.

Example:

```hcl
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

Do not store secrets or personal data in tags.

---

## Variables

Variables must have:

* clear name;
* explicit type;
* description;
* validation when useful;
* sensible default only when universally safe;
* `sensitive = true` when appropriate.

Example:

```hcl
variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition = contains(
      ["local", "development", "staging", "production"],
      var.environment
    )

    error_message = "Environment must be local, development, staging, or production."
  }
}
```

Do not use `type = any` without a strong reason.

---

## Defaults

Safe defaults may include:

* local region;
* log retention for local;
* non-production capacity;
* common tags.

Avoid defaults for:

* production domain;
* database password;
* account ID;
* destructive behavior;
* public exposure;
* administrative CIDRs.

A missing critical input should fail clearly.

---

## Locals

Use locals for:

* derived names;
* common tags;
* repeated expressions;
* normalized configuration.

Do not use locals to hide large business rules or deeply nested configuration.

Keep them readable.

---

## Outputs

Outputs should expose information needed by:

* other modules;
* deployment workflows;
* application configuration;
* operators.

Examples:

```text
bucket_name
api_endpoint
database_endpoint
user_pool_id
cloudfront_domain
```

Mark sensitive outputs:

```hcl
sensitive = true
```

Do not output secret values merely for convenience.

---

## Data Sources

Use data sources for existing platform information.

Examples:

* availability zones;
* caller identity;
* current region;
* hosted zone;
* certificate;
* existing secrets.

Do not use data sources to create hidden dependencies on manually created resources without documentation.

If a resource must preexist, document ownership and discovery.

---

## Networking

Future AWS networking may include:

* VPC;
* public subnets;
* private application subnets;
* private database subnets;
* route tables;
* internet gateway;
* NAT strategy;
* VPC endpoints;
* security groups;
* flow logs.

Do not implement the full network during local-only phases.

---

## VPC Design

A future production design should evaluate:

* at least two availability zones;
* subnet separation;
* IP range planning;
* future growth;
* database isolation;
* endpoint access;
* outbound connectivity;
* cost.

Do not choose CIDR blocks without documenting them.

Do not create overlapping networks across connected environments.

---

## Public and Private Subnets

Typical direction:

### Public subnets

May contain:

* Application Load Balancer;
* NAT gateways when used.

### Private application subnets

May contain:

* ECS tasks;
* workers.

### Private database subnets

May contain:

* RDS;
* ElastiCache.

Do not place databases in public subnets.

Do not assign public IPs to application tasks without a documented reason.

---

## NAT Strategy

NAT gateways add cost.

Evaluate alternatives:

* one NAT per environment for lower environments;
* one per AZ for production resilience;
* VPC endpoints for AWS services;
* no NAT when architecture permits.

Do not blindly create one NAT gateway per AZ in every environment.

Document cost and availability trade-offs.

---

## VPC Endpoints

Future endpoints may reduce NAT dependency.

Potential services:

* S3;
* ECR API;
* ECR Docker;
* CloudWatch Logs;
* Secrets Manager;
* SQS;
* STS.

Add only when justified by traffic, security, or cost.

Do not create every available endpoint.

---

## Security Groups

Security groups must be least-privilege.

Examples:

* ALB accepts HTTPS from the internet;
* ECS accepts application traffic only from ALB security group;
* RDS accepts PostgreSQL only from application security group;
* Redis accepts traffic only from application or worker security groups.

Prefer security-group references over broad CIDRs.

Do not use:

```text
0.0.0.0/0
```

for database, cache, or internal service ingress.

---

## Compute

The planned initial AWS compute direction is ECS Fargate.

Potential components:

* ECS cluster;
* API service;
* worker service when needed;
* task definitions;
* ECR repositories;
* ALB;
* target groups;
* autoscaling;
* log groups.

Do not create worker infrastructure before a real asynchronous workload exists.

---

## ECS Task Definitions

Task definitions should define:

* image;
* CPU;
* memory;
* port mappings;
* environment variables;
* secrets;
* log configuration;
* health behavior;
* execution role;
* task role;
* non-root user where image supports it.

Do not place secrets in plain environment variables inside Terraform state when avoidable.

Use Secrets Manager or Parameter Store in real AWS.

---

## ECS Roles

Separate:

### Execution role

Used by ECS to:

* pull images;
* write logs;
* retrieve referenced secrets.

### Task role

Used by the application for AWS API calls.

Do not give the task role broad administrative permissions.

Do not reuse one unrestricted role for all services.

---

## ECR

ECR repositories may be created per deployable image.

Examples:

```text
api
web
worker
```

If frontend is static and hosted through S3/CloudFront, it may not require an ECS image.

Configure:

* image scanning;
* lifecycle policy;
* encryption;
* immutable tags when appropriate.

Do not keep unlimited historical images.

---

## Application Load Balancer

The ALB may provide:

* HTTPS termination;
* routing;
* health checks;
* access logs;
* integration with WAF.

Use HTTP to HTTPS redirects.

Do not expose application tasks directly if ALB is the intended public entry point.

Health-check paths must match application endpoints.

---

## Frontend Hosting

Evaluate two strategies.

### Static frontend

* build React assets;
* upload to S3;
* serve through CloudFront.

Likely preferred for Vite SPA.

### Container frontend

* serve through ECS or another runtime.

Use only when server-side runtime behavior requires it.

Do not deploy a static SPA to ECS by default without justification.

---

## SPA Routing

For S3 and CloudFront hosting, support client-side routes safely.

Requirements:

* fallback to `index.html` for application routes;
* preserve real `404` behavior for missing assets;
* define cache policies;
* avoid caching HTML indefinitely;
* version static assets.

Do not redirect every missing asset to `index.html`.

---

## S3

Potential buckets:

* media assets;
* static frontend;
* logs;
* Terraform state in the future.

Each bucket has a separate responsibility.

Do not use one bucket for unrelated security boundaries.

---

## Media Bucket

The media bucket should be private by default.

Access may occur through:

* CloudFront origin access control;
* presigned URLs;
* backend proxy only when justified.

Configure:

* encryption;
* public-access blocking;
* versioning when needed;
* lifecycle rules;
* CORS only when required;
* object ownership;
* logging or events when needed.

Do not enable public-read ACLs.

---

## Frontend Bucket

A static frontend bucket should remain private behind CloudFront.

Use origin access control.

Do not use direct public S3 website hosting when a secure CloudFront distribution is intended.

---

## S3 Encryption

Use server-side encryption.

Potential choices:

* SSE-S3;
* SSE-KMS when stronger control is required.

Do not use customer-managed KMS keys everywhere without evaluating cost and operational burden.

Production data classification should drive the decision.

---

## CloudFront

CloudFront may serve:

* frontend assets;
* public media;
* optimized images later.

Configure:

* HTTPS;
* ACM certificate;
* origin access;
* cache policies;
* compression;
* security headers;
* custom error responses for SPA routing;
* logging when required.

Do not cache private administrative responses.

Do not expose unpublished media through public cache behavior.

---

## Cache Strategy

Define cache policies by content type.

Examples:

### HTML

* short TTL;
* invalidated or version-aware;
* must receive updates quickly.

### Hashed assets

* long immutable caching.

### Public media

* longer caching when object keys are immutable.

Do not use one cache policy for every path.

---

## Database

The planned AWS database is RDS PostgreSQL.

Requirements may include:

* private subnets;
* encryption;
* backups;
* maintenance window;
* deletion protection in production;
* parameter groups;
* monitoring;
* security-group restrictions;
* credentials from Secrets Manager;
* Multi-AZ in production when justified.

Do not provision RDS locally.

Use Docker PostgreSQL locally.

---

## RDS Credentials

Prefer managed credentials or Secrets Manager.

Do not hardcode passwords in:

* Terraform files;
* tfvars committed to Git;
* outputs;
* application images.

Be aware that generated passwords may still appear in Terraform state.

Protect state accordingly.

---

## RDS Backups

Production should evaluate:

* automated backup retention;
* point-in-time recovery;
* final snapshots;
* deletion protection;
* cross-region strategy when required.

Lower environments may use reduced retention.

Do not disable all backups solely to reduce cost without documenting risk.

---

## Database Migrations in AWS

Terraform does not own application schema migrations.

Possible deployment step:

* dedicated migration task;
* CI job with controlled credentials;
* one-off ECS task.

Do not run application migrations through Terraform provisioners.

Do not use `local-exec` as the primary migration strategy.

---

## Cache

The planned cache service is ElastiCache for Redis or Valkey-compatible service according to the chosen AWS strategy.

Use only when the application has a concrete cache or coordination requirement.

Requirements:

* private subnet;
* encryption;
* authentication when supported;
* security-group restriction;
* appropriate node sizing;
* failover strategy for production.

Do not provision cache because Redis exists locally.

Local Redis may support future needs without requiring immediate AWS cache.

---

## Authentication

The planned AWS identity provider is Cognito.

A future module may manage:

* user pool;
* application client;
* hosted UI domain;
* callback URLs;
* logout URLs;
* groups;
* password policy;
* email configuration;
* MFA configuration;
* token validity;
* frontend and backend outputs.

Do not attempt to force Keycloak and Cognito into identical configuration models.

Abstract application needs, not provider implementation details.

---

## Cognito Client

A browser client must not rely on a client secret.

Use:

* authorization code flow;
* PKCE;
* constrained callback URLs;
* constrained logout URLs;
* supported OAuth scopes.

Do not expose confidential client secrets to the frontend.

---

## Messaging

Potential AWS messaging services:

* SQS;
* EventBridge;
* SNS.

Use them only for concrete workflows.

Possible future workloads:

* scheduled article publication;
* media processing;
* activity events;
* email jobs.

Do not introduce event-driven infrastructure before the workflow exists.

---

## SQS

When used, define:

* queue;
* dead-letter queue;
* redrive policy;
* visibility timeout;
* message retention;
* encryption;
* access policy;
* alarms;
* idempotency strategy.

Do not create a queue without a consumer and failure strategy.

---

## EventBridge

Use EventBridge when:

* scheduled rules are required;
* multiple consumers need domain events;
* integration patterns justify it.

Do not use EventBridge as a generic substitute for clear application workflows.

Scheduled publication may use:

* EventBridge Scheduler;
* recurring worker polling;
* queue-based scheduling.

Choose based on actual requirements.

---

## SES

SES may support:

* account emails;
* notifications;
* editorial emails.

During local development, use Mailpit.

Future AWS configuration must consider:

* domain verification;
* DKIM;
* sandbox restrictions;
* sending identity;
* bounce and complaint handling;
* suppression lists.

Do not send production email from unverified identities.

---

## Secrets Manager

Use Secrets Manager for suitable real AWS secrets.

Examples:

* database credentials;
* third-party API keys;
* sensitive application configuration.

Do not store non-secret configuration there merely because it exists.

Do not output secret values.

Define rotation only when supported and operationally understood.

---

## Systems Manager Parameter Store

May be used for non-secret or lower-sensitivity configuration.

Choose between Parameter Store and Secrets Manager deliberately.

Do not duplicate the same value across both without a clear ownership policy.

---

## IAM

IAM must follow least privilege.

Use:

* service-specific roles;
* explicit actions;
* narrow resources;
* conditions when useful;
* no wildcard administration.

Avoid:

```hcl
actions   = ["*"]
resources = ["*"]
```

unless an unavoidable service bootstrap case is documented and temporary.

---

## IAM Policy Ownership

Keep IAM near the resource or module that requires it.

Examples:

* storage module defines access policy outputs;
* compute module composes task role permissions;
* observability module owns log-delivery permissions.

Do not create one giant project-wide policy.

---

## IAM Boundaries

Future production may use:

* permission boundaries;
* service control policies;
* separate deployment role;
* read-only operational role.

Do not add organization-level controls inside this project without the necessary organizational context.

---

## WAF

AWS WAF may protect public CloudFront or ALB endpoints.

Potential rules:

* AWS managed rule groups;
* rate-based rules;
* request-size limits;
* IP reputation;
* bot controls when justified.

Do not add expensive or restrictive managed rules without testing and cost evaluation.

LocalStack is not a reliable WAF validation environment.

---

## ACM

Use ACM certificates for AWS-managed HTTPS.

Requirements:

* certificate in the correct region;
* DNS validation;
* Route 53 integration when applicable;
* separate handling for CloudFront certificate region requirements.

Do not assume an ALB certificate and CloudFront certificate always use the same region.

---

## Route 53

Route 53 may manage:

* application domain;
* API subdomain;
* authentication subdomain;
* validation records.

Do not transfer or modify a real domain without explicit instruction.

Do not create production DNS records during planning.

---

## Observability

Infrastructure should prepare:

* CloudWatch log groups;
* log retention;
* alarms;
* dashboards when useful;
* metrics;
* traces;
* load balancer logs;
* audit logs.

Do not retain logs forever by default.

Set explicit retention based on environment.

---

## CloudWatch Logs

Create log groups explicitly when lifecycle and retention matter.

Example:

```text
/aws/ecs/reptile-archive-dev-api
```

Configure:

* encryption when required;
* retention;
* stable names;
* task permissions.

Do not rely only on implicit log-group creation in production.

---

## Metrics and Alarms

Potential alarms:

* unhealthy ECS tasks;
* ALB 5xx;
* high latency;
* RDS CPU;
* RDS storage;
* database connections;
* queue depth;
* dead-letter messages;
* authentication failures;
* CloudFront error rate.

Do not create alarms without owners and response expectations.

Each production alarm should correspond to a documented action or runbook.

---

## Tracing

Prepare for OpenTelemetry.

Possible export destinations may include CloudWatch-compatible or third-party tooling in the future.

Do not force application instrumentation details into Terraform beyond endpoints and permissions.

Do not add tracing infrastructure before application support exists.

---

## Audit and Security Logging

Production should evaluate:

* CloudTrail;
* AWS Config;
* VPC Flow Logs;
* WAF logs;
* S3 access logs;
* ALB access logs.

These may be organization-owned rather than project-owned.

Do not duplicate centralized organizational controls inside the project without context.

---

## Backup and Recovery

Future AWS design must evaluate:

* RDS backups;
* S3 versioning;
* Terraform state recovery;
* secrets recovery;
* deployment rollback;
* cross-region needs;
* recovery time objective;
* recovery point objective.

Do not claim disaster recovery exists merely because backups are enabled.

Document recovery procedures separately.

---

## Cost Awareness

Every real AWS resource has cost.

High-cost areas may include:

* NAT gateways;
* RDS;
* ElastiCache;
* WAF;
* CloudFront traffic;
* CloudWatch logs;
* multi-AZ;
* VPC endpoints;
* data transfer.

Before adding a real resource:

1. explain why it is needed;
2. identify cost drivers;
3. consider lower-environment sizing;
4. consider teardown behavior;
5. document production trade-offs.

Do not optimize only for lowest cost at the expense of basic security.

---

## Lower Environment Sizing

Development may use:

* smaller RDS classes;
* single-AZ;
* shorter log retention;
* fewer ECS tasks;
* reduced backup retention;
* no NAT redundancy.

Production may require:

* multi-AZ;
* higher availability;
* longer retention;
* stronger deletion protection;
* autoscaling.

Do not copy production capacity into development automatically.

---

## Autoscaling

ECS autoscaling may use:

* CPU;
* memory;
* request count;
* queue depth for workers.

Define:

* minimum;
* maximum;
* target;
* cooldowns.

Do not enable autoscaling without load behavior and monitoring.

Do not set production minimum tasks to zero for continuously available APIs.

---

## Resource Lifecycle

Use lifecycle settings carefully.

Potential examples:

```hcl
lifecycle {
  prevent_destroy = true
}
```

Useful for critical production resources such as:

* database;
* state bucket;
* important data buckets.

Do not add `prevent_destroy` everywhere.

It can block legitimate lower-environment cleanup.

---

## `ignore_changes`

Use `ignore_changes` only when another trusted system owns the field.

Do not use it to silence unwanted plans without understanding the drift.

Every ignored attribute should be documented.

---

## Drift

Terraform should remain the source of truth for managed resources.

Avoid manual changes.

When drift occurs:

1. inspect it;
2. decide whether Terraform or manual state is correct;
3. update code or restore resource;
4. document exceptional ownership.

Do not run apply blindly to resolve unknown drift.

---

## Imports

When adopting existing resources, use Terraform import or import blocks according to the chosen Terraform version.

Document:

* resource ownership;
* import identifier;
* expected configuration;
* validation plan.

Do not recreate valuable existing resources merely to bring them under Terraform.

---

## Moved Blocks

Use `moved` blocks for safe address changes when supported.

Example:

```hcl
moved {
  from = aws_s3_bucket.media
  to   = module.storage.aws_s3_bucket.media
}
```

Do not rely on manual state moves without documentation when code-based moves are possible.

---

## Destructive Changes

Before any destructive infrastructure change:

* inspect the plan;
* identify data impact;
* identify downtime;
* identify replacement behavior;
* identify rollback;
* require explicit authorization for real environments.

Do not execute plans with unexpected destroy operations.

Do not hide destructive replacement behind refactoring.

---

## `terraform plan`

Planning is mandatory before apply.

For real environments, use a saved plan where practical.

Example:

```bash
terraform plan -out=tfplan
terraform show tfplan
```

Do not apply a plan that was generated from stale or changed configuration.

Do not commit plan files.

---

## `terraform apply`

LocalStack apply may be allowed as part of the local environment workflow.

Real AWS apply requires explicit authorization.

Never infer authorization from a general request such as “prepare the infrastructure.”

Preparation is not deployment.

---

## `terraform destroy`

Never destroy a real environment without explicit and unambiguous authorization.

For local environment:

* destroy may be part of reset;
* scope must be explicit;
* state must point to LocalStack;
* no real AWS profile may be used.

Do not provide a generic automated destroy command that can accidentally target production.

---

## Terraform Workflows

Expected commands:

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
```

Local environment may also use:

```bash
terraform apply
terraform destroy
```

only against LocalStack and with explicit endpoint configuration.

Prefer Makefile wrappers:

```text
make terraform-init
make terraform-validate
make terraform-plan ENV=local
make terraform-apply-local
```

Do not provide a generic `make terraform-apply ENV=production` without safety controls.

---

## Makefile Safety

Separate local and real AWS commands.

Prefer:

```text
terraform-apply-local
```

Avoid:

```text
terraform-apply
```

when target ambiguity could be dangerous.

For real environments, require:

* explicit environment;
* explicit approval;
* configured backend;
* validated AWS identity;
* reviewed plan.

---

## AWS Identity Validation

Before any real AWS operation, identify:

* account ID;
* current principal;
* region;
* profile or assumed role;
* target environment.

A safe script may run:

```bash
aws sts get-caller-identity
```

Do not assume the current shell points to the intended account.

Do not print secret credentials.

---

## Local Terraform Environment

The local environment should only manage AWS-like resources supported by LocalStack.

Potential initial resources:

* S3 media bucket;
* optional SQS queue when a worker exists;
* optional SES identity only for AWS-specific tests.

Do not use Terraform to create:

* PostgreSQL container;
* Redis container;
* Keycloak container;
* Mailpit container.

Docker Compose owns those services.

---

## Example Local Storage Module

A local storage module may expose:

```text
bucket_name
bucket_arn
```

The same module may later support real AWS when behavior is compatible.

Do not force one module to contain extensive LocalStack-specific conditionals if separate composition is clearer.

---

## Conditional Resources

Use conditional resources carefully.

Example:

```hcl
count = var.enabled ? 1 : 0
```

Or `for_each`.

Do not create deeply conditional modules that are difficult to reason about.

Prefer explicit environment composition over many flags.

---

## Feature Flags in Terraform

Avoid module variables such as:

```text
enable_everything
create_all_resources
production_mode
```

Prefer focused inputs:

```text
enable_versioning
enable_access_logs
backup_retention_days
```

Even focused flags should reflect real variations.

---

## Validation Blocks

Use variable validation.

Example:

```hcl
variable "log_retention_days" {
  description = "CloudWatch log retention in days."
  type        = number

  validation {
    condition     = var.log_retention_days >= 1
    error_message = "Log retention must be at least one day."
  }
}
```

Do not duplicate validations that providers already handle unless the custom message or policy adds value.

---

## Preconditions and Postconditions

Use Terraform conditions for critical assumptions when supported.

Examples:

* production cannot disable encryption;
* production backup retention must meet a minimum;
* public bucket configuration must remain disabled.

Do not create excessive conditions that make modules hard to reuse.

---

## Sensitive Variables

Mark secrets:

```hcl
variable "database_password" {
  type      = string
  sensitive = true
}
```

This reduces display but does not remove the value from state.

Do not claim `sensitive = true` encrypts state.

State protection remains mandatory.

---

## Terraform Tests

Use static validation first.

Required:

```bash
terraform fmt -check -recursive
terraform validate
```

Also use:

```bash
tflint
```

Security scanning may use:

```bash
checkov
trivy config
```

Add tools only when configured and maintained.

Do not report scans that were not run.

---

## Native Terraform Tests

Terraform test files may be introduced where they provide value.

Potential tests:

* naming;
* conditional resources;
* outputs;
* validation failures;
* module behavior.

Do not build a large test suite for simple declarative modules without meaningful assertions.

---

## LocalStack Integration Tests

For LocalStack-managed resources, validate:

* bucket exists;
* expected encryption or configuration exists where emulated;
* queues exist when required;
* application can access resources;
* endpoint variables are correct.

Do not assume LocalStack validates all AWS policy behavior.

---

## Security Scanning

Infrastructure security review should include:

* public exposure;
* encryption;
* IAM wildcards;
* logging;
* backup;
* secrets;
* network paths;
* resource policies;
* deletion protection;
* insecure defaults.

Static scanners assist but do not replace architecture review.

---

## Policy as Code

Future production workflows may add:

* OPA/Conftest;
* Sentinel;
* organization-specific policy systems.

Do not add policy infrastructure before there are concrete rules and owners.

Start with Terraform validation, lint, and security scanning.

---

## CI

Infrastructure CI should run on relevant changes.

Recommended steps:

```text
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
tflint
security scan
```

Plans may run for real environments using read-only or constrained credentials.

Do not grant CI broad production write access for pull-request validation.

---

## CI Credentials

Prefer short-lived credentials through OIDC federation.

Do not store long-lived AWS access keys in repository secrets when avoidable.

Separate:

* plan role;
* deployment role;
* production deployment approval.

Do not let untrusted pull requests assume privileged roles.

---

## Deployment Strategy

Future application deployment may use CI/CD to:

1. build;
2. test;
3. scan;
4. publish images or frontend assets;
5. plan infrastructure;
6. apply approved infrastructure;
7. run migrations;
8. deploy application;
9. validate health;
10. support rollback.

Terraform owns infrastructure, not every deployment action.

Do not use Terraform to upload changing application releases on every deploy unless intentionally designed.

---

## Blue/Green and Rolling Deployments

ECS may use rolling deployment initially.

Future options:

* CodeDeploy blue/green;
* weighted target groups;
* canary.

Do not add complex deployment strategies before operational need exists.

Production health and rollback requirements should drive the choice.

---

## Application Configuration Outputs

Terraform may output non-secret configuration needed by deployment.

Examples:

* API hostname;
* media bucket name;
* region;
* Cognito issuer;
* Cognito client ID;
* queue URL;
* log group name.

Do not output database passwords or private keys.

Deployment tooling may map outputs to application configuration.

---

## Environment Variable Ownership

Terraform may configure runtime environment variables in ECS.

Separate:

### Non-secret

Examples:

* environment;
* region;
* bucket name;
* queue URL.

### Secret

Examples:

* database credentials;
* third-party API keys.

Secrets should be referenced from managed secret stores.

Do not place sensitive values directly in task-definition environment blocks when avoidable.

---

## Resource Policies

Use resource policies for:

* S3 access;
* SQS access;
* KMS;
* Secrets Manager;
* CloudFront origin access.

Policies must be narrow.

Do not grant access to every principal in the account without a reason.

---

## KMS

Use AWS-managed keys by default when sufficient.

Use customer-managed keys when requirements include:

* granular key policies;
* cross-account access;
* explicit rotation;
* audit control;
* regulatory needs.

Do not create many customer-managed KMS keys without considering cost and operational ownership.

---

## Public Exposure Review

For every public resource, document:

* why it is public;
* entry point;
* TLS;
* WAF;
* authentication;
* rate limiting;
* logging;
* allowed methods;
* origin security.

Likely public entry points:

* CloudFront;
* ALB;
* Cognito hosted UI.

Databases, caches, buckets, and tasks should remain private.

---

## Data Classification

Future environments should classify:

* public reptile content;
* unpublished editorial content;
* user identity data;
* activity data;
* logs;
* credentials.

Security, retention, and access controls should follow classification.

Do not treat all data as equally public because most content is educational.

---

## Environment Teardown

Development environments may support teardown.

Production should not be easily destroyable.

Use:

* deletion protection;
* backup;
* explicit approvals;
* separate roles;
* lifecycle protections.

Do not make cost-cleanup automation capable of destroying production.

---

## Documentation

Infrastructure changes must evaluate updates to:

```text
README.md
docs/architecture/deployment.md
docs/architecture/containers.md
docs/adr/
docs/development/
docs/runbooks/
infrastructure/terraform/README.md
```

Document:

* architecture;
* environment strategy;
* modules;
* variables;
* outputs;
* provider versions;
* state strategy;
* LocalStack differences;
* validation commands;
* deployment safety;
* cost decisions;
* recovery assumptions.

Do not leave critical infrastructure behavior only in Terraform comments.

---

## ADRs

Potential ADRs:

```text
Use Terraform for infrastructure as code
Use LocalStack only for supported local AWS services
Use ECS Fargate for backend compute
Host React static assets with S3 and CloudFront
Use RDS PostgreSQL
Use Cognito in AWS and Keycloak locally
Use isolated Terraform state per environment
```

Create ADRs only for actual decisions.

Do not pre-write final ADRs for choices that remain open.

---

## Implementation Workflow

When using this skill:

1. identify the current project phase;
2. identify local or real AWS target;
3. inspect existing state and modules;
4. identify the infrastructure requirement;
5. determine resource ownership;
6. define module boundaries;
7. define variables and outputs;
8. define security controls;
9. define cost implications;
10. implement the smallest infrastructure change;
11. run format and validation;
12. run plan;
13. inspect destructive actions;
14. test LocalStack resources when applicable;
15. update documentation;
16. report limitations.

Do not apply to real AWS unless explicitly authorized.

---

## Expected Deliverables

Depending on the task, deliverables may include:

* Terraform modules;
* environment root modules;
* provider configuration;
* LocalStack endpoint configuration;
* variables;
* outputs;
* IAM policies;
* security groups;
* storage;
* messaging;
* compute;
* database;
* authentication;
* observability;
* validation scripts;
* CI workflows;
* documentation;
* ADRs.

Do not create unrelated future infrastructure.

---

## Validation Commands

From the Terraform directory or relevant environment:

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
tflint
```

Security checks when configured:

```bash
checkov -d .
trivy config .
```

For the local environment:

```bash
terraform init
terraform plan
terraform apply
```

Only against LocalStack with explicit safe configuration.

Inspect state target and provider endpoints before apply.

For repository-level validation:

```bash
make validate
```

Only report commands that were actually executed.

---

## Definition of Done

A Terraform or AWS task is complete only when:

* scope matches the current phase;
* target environment is explicit;
* modules have clear ownership;
* provider versions are pinned;
* variables are typed;
* outputs are minimal;
* state strategy is safe;
* no credentials are hardcoded;
* LocalStack endpoints are explicit when local;
* real AWS is not mutated without authorization;
* security controls are evaluated;
* cost impact is considered;
* formatting passes;
* validation passes;
* lint passes when configured;
* plan is reviewed;
* destructive changes are identified;
* documentation is updated;
* no success is falsely claimed.

---

## Prohibited Practices

Do not:

* run real AWS apply without explicit authorization;
* run real AWS destroy without explicit and unambiguous authorization;
* hardcode AWS credentials;
* commit state files;
* commit secret tfvars;
* use unbounded provider versions;
* use one state for all environments;
* use LocalStack endpoints in production configuration;
* let local commands fall back to real AWS;
* provision PostgreSQL or Redis containers with Terraform;
* use Terraform provisioners for application migrations;
* create public databases or caches;
* grant wildcard IAM administration;
* create unused modules;
* create every future AWS resource during Phase 0;
* use `ignore_changes` to hide unexplained drift;
* apply a plan with unexpected destruction;
* expose secrets in outputs;
* assume LocalStack exactly reproduces AWS;
* declare infrastructure complete without validation and plan review.

---

## Completion Report

After completing a Terraform or AWS task, report:

```markdown
## Infrastructure scope

## Target environment

## Modules and resources

## Provider and state strategy

## Networking and access

## IAM and security

## Cost considerations

## LocalStack compatibility

## Validation performed

## Plan summary

## Documentation updates

## Limitations and deployment risks
```

Keep the report factual and based on actual work performed.

# Terraform

Infrastructure as code. Structure follows [ADR-0007](../../docs/adr/0007-use-terraform-environment-directories.md): each directory under `environments/` is an isolated root module with its own state; reusable pieces live in `modules/`.

```text
infrastructure/terraform/
├── .tflint.hcl
├── modules/
│   └── storage/          # private media bucket
└── environments/
    └── local/            # LocalStack only
```

Only what is used exists. `networking`, `database`, `compute`, … modules and the `development` / `staging` / `production` environments are created in Phase 6 — never before, and never applied without explicit authorization.

## Local environment (LocalStack)

Creates `reptile-collection-local-media`: private S3 bucket with all public access blocked, ACLs disabled (`BucketOwnerEnforced`), SSE (AES256), versioning, and cleanup of incomplete multipart uploads after 7 days.

Safety — this environment cannot touch real AWS:

* every used service has an explicit endpoint (`s3`, `sts`) pointing at LocalStack;
* credentials are LocalStack's fixed dummy values (`test`/`test`), which take precedence over any `~/.aws` profile or `AWS_*` variable on your machine;
* `localstack_endpoint` only accepts `localhost`, `127.0.0.1`, or `localstack`.

State is local (`terraform.tfstate`, git-ignored). `.terraform.lock.hcl` is committed (hashes for Linux and macOS, amd64/arm64).

## Commands

```bash
make tf-apply-local   # init + apply against LocalStack (requires `make up`)
make tf-plan          # preview changes
make tf-fmt           # terraform fmt -check -recursive
make tf-validate      # init -backend=false + validate for every environment
make tf-lint          # tflint (pinned image, via Docker)
```

`make lint` and `make validate` include the Terraform checks.

**LocalStack does not persist data** (community edition). After LocalStack restarts (`make restart`, `make reset`, machine reboot) the bucket is gone; run `make tf-apply-local` again — Terraform detects the missing resources and recreates them.

Inspect with the AWS CLI using dummy credentials:

```bash
AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=us-east-1 \
  aws --endpoint-url http://localhost:4566 s3 ls
```

## Not configured yet

`trivy` and `checkov` (CLAUDE.md §15.3 "when configured") — candidates for the CI increment.

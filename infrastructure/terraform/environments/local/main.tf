# Local environment: LocalStack only. No real AWS resource can be created here:
# every service endpoint is explicit, credentials are LocalStack's fixed dummy
# values, and the endpoint variable only accepts local addresses.

locals {
  environment = "local"
  name_prefix = "${var.project_name}-${local.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}

provider "aws" {
  region = var.aws_region

  # LocalStack's documented dummy credentials — not secrets.
  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3  = var.localstack_endpoint
    sts = var.localstack_endpoint
  }

  default_tags {
    tags = local.common_tags
  }
}

module "media_storage" {
  source = "../../modules/storage"

  bucket_name   = "${local.name_prefix}-media"
  force_destroy = true # disposable local data
}

terraform {
  required_version = ">= 1.8, < 2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Local state only; *.tfstate is git-ignored. Remote state arrives with Phase 6.
  backend "local" {}
}

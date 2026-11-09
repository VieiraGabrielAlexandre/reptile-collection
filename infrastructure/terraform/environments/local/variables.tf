variable "project_name" {
  description = "Project identifier used in resource names and tags."
  type        = string
  default     = "reptile-collection"
}

variable "aws_region" {
  description = "Region reported to LocalStack."
  type        = string
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  description = "LocalStack edge endpoint. Must be a local address so this environment can never reach real AWS."
  type        = string
  default     = "http://localhost:4566"

  validation {
    condition     = can(regex("^http://(localhost|127\\.0\\.0\\.1|localstack)(:[0-9]+)?/?$", var.localstack_endpoint))
    error_message = "localstack_endpoint must point to LocalStack (localhost, 127.0.0.1, or localstack)."
  }
}

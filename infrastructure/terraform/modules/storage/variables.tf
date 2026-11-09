variable "bucket_name" {
  description = "Globally unique name of the media bucket."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be 3-63 characters of lowercase letters, digits, dots, or hyphens."
  }
}

variable "versioning_enabled" {
  description = "Keep previous versions of overwritten or deleted media objects."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow destroying the bucket while it still contains objects. Only for disposable environments."
  type        = bool
  default     = false
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Days after which incomplete multipart uploads are removed."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_multipart_upload_days >= 1
    error_message = "abort_incomplete_multipart_upload_days must be at least 1."
  }
}

variable "tags" {
  description = "Tags applied to the bucket."
  type        = map(string)
  default     = {}
}

output "media_bucket_name" {
  description = "Media bucket name, for the backend's future S3 configuration."
  value       = module.media_storage.bucket_name
}

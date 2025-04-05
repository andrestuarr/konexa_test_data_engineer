output "bucket_name" {
  value = google_storage_bucket.gcs_bucket.name
}

output "bucket_schema_name" {
  value = google_storage_bucket.gcs_bucket_schema.name
}

output "cloud_function_bucket_name" {
  value = google_storage_bucket.cloud_function_bucket.name
}

output "zip_name" {
  value = google_storage_bucket_object.zip.name
}
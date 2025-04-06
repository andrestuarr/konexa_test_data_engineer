resource "google_storage_bucket" "cloud_function_bucket" {
  name     = var.cloud_function_bucket_name
  location = var.region

  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket" "gcs_bucket" {
  name     = var.bucket_name
  location = var.region

  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket" "gcs_bucket_schema" {
  name     = var.bucket_schema_name
  location = var.region

  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket_object" "dag_file" {
  name   = var.dag_file_name
  bucket = var.dags_bucket
  source = var.dag_file

  depends_on = [
    google_storage_bucket.gcs_bucket
  ]
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "../cloud_functions"
  output_path = "${path.module}/function.zip"
}

resource "google_storage_bucket_object" "zip" {
  name         = "src-${data.archive_file.source.output_md5}.zip"
  bucket       = google_storage_bucket.cloud_function_bucket.name
  source       = data.archive_file.source.output_path
  content_type = "application/zip"

  depends_on = [
    google_storage_bucket.cloud_function_bucket,
    data.archive_file.source
  ]
}

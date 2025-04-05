output "service_account_email" {
  value = module.iam.service_account_email
}

output "composer_airflow_uri" {
  value = module.composer.composer_airflow_uri
}

output "cloud_function_uri" {
  value = module.cloud_functions.cloud_function_uri
}

output "gcs_bucket_name" {
  value = module.cloud_storage.bucket_name
}

output "composer_dags_bucket" {
  value = module.composer.composer_dags_bucket
}
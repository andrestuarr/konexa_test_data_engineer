output "composer_airflow_uri" {
  value = google_composer_environment.composer_env.config[0].airflow_uri
}

output "composer_dags_bucket" {
  value = google_composer_environment.composer_env.config[0].dag_gcs_prefix
}

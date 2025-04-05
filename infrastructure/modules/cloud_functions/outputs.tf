output "cloud_function_uri" {
  value = google_cloudfunctions2_function.cf_activate_dag.service_config[0].uri
}

resource "google_composer_environment" "composer_env" {
  name    = var.composer_env_name
  project = var.project_id
  region  = var.region

  config {
    software_config {
      image_version = "composer-3-airflow-2.10.2"
      
      env_variables = {
        AIRFLOW_VAR_GCP_PROJECT = var.project_id
      }
    }

    node_config {
      service_account = var.service_account
    }
  }
}

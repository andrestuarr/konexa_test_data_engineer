resource "google_cloudfunctions2_function" "cf_activate_dag" {
  name     = var.function_name
  location = var.region
  project  = var.project_id

  build_config {
    runtime     = "python311"
    entry_point = "gcs_trigger"
    source {
      storage_source {
        bucket = var.bucket_functions
        object = var.object_function
      }
    }
  }

  service_config {
    max_instance_count    = 5
    available_memory      = "512Mi"
    timeout_seconds       = 60
    environment_variables = {
      COMPOSER_ENV_NAME = var.composer_env_name
      COMPOSER_REGION = var.region
      GCP_PROJECT = var.project_id
    }

    ingress_settings = "ALLOW_INTERNAL_ONLY"

    service_account_email = var.service_account
  }

  event_trigger {
    event_type = "google.cloud.storage.object.v1.finalized"
    event_filters {
      attribute = "bucket"
      value     = var.trigger_bucket
    }
  }
}

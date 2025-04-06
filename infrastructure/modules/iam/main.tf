resource "google_service_account" "sa_konexa" {
  project      = var.project_id
  account_id   = var.sa_name
  display_name = "Service Account for Cloud Functions"
}

resource "google_project_iam_member" "cloud_function_admin" {
  project = var.project_id
  role    = "roles/cloudfunctions.admin"
  member  = "serviceAccount:${google_service_account.sa_konexa.email}"

  depends_on = [google_service_account.sa_konexa]
}

resource "google_project_iam_member" "pubsub_admin" {
  project = var.project_id
  role    = "roles/pubsub.admin"
  member  = "serviceAccount:${google_service_account.sa_konexa.email}"

  depends_on = [google_service_account.sa_konexa]
}

resource "google_project_iam_member" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.sa_konexa.email}"

  depends_on = [google_service_account.sa_konexa]
}

resource "google_project_iam_member" "bigquery_admin" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.sa_konexa.email}"

  depends_on = [google_service_account.sa_konexa]
}

resource "google_project_iam_member" "composer_admin" {
  project = var.project_id
  role    = "roles/composer.admin"
  member  = "serviceAccount:${google_service_account.sa_konexa.email}"

  depends_on = [google_service_account.sa_konexa]
}


# Opcional: Rol de administrador para el proyecto completo
#resource "google_project_iam_member" "project_admin" {
#  project = var.project_id
#  role    = "roles/owner"
#  member  = "serviceAccount:${google_service_account.sa_konexa.email}"
#}

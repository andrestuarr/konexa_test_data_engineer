terraform {
  backend "gcs" {
    bucket = "terraform-bucket-konexa-amta"
    prefix = "solutions/test" 
  }
}

module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id
  sa_name    = var.sa_name
}

module "composer" {
  source                = "./modules/composer"
  project_id            = var.project_id
  region                = var.region
  composer_env_name     = var.composer_env_name
  service_account       = module.iam.service_account_email
}

module "cloud_storage" {
  source                     = "./modules/cloud_storage"
  bucket_name                = var.bucket_name
  bucket_schema_name         = var.bucket_schema_name
  cloud_function_bucket_name = var.cloud_function_bucket_name
  region                     = var.region
  dag_file_name              = var.dag_file_name
  dag_file                   = var.dag_file
  dags_bucket                = module.composer.composer_dags_bucket
}

module "cloud_functions" {
  source            = "./modules/cloud_functions"
  project_id        = var.project_id
  region            = var.region
  function_name     = var.function_name
  composer_env_name = module.composer.composer_airflow_uri
  trigger_bucket    = module.cloud_storage.bucket_name
  service_account   = module.iam.service_account_email
  bucket_functions  = module.cloud_storage.cloud_function_bucket_name
  object_function   = module.cloud_storage.zip_name
}
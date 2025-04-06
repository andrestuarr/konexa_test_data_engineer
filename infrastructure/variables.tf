variable "project_id" {
    description = "The ID of the project in which the resource belongs."
    type        = string
    default     = "konexa-amta-test"
}

variable "region" {
    description = "The region in which the resource should be created."
    type        = string
    default     = "us-central1"
}

variable "sa_name" {
    description = "The name of the service account."
    type        = string
    default     = "konexa-account-at"
}

variable "cloud_function_bucket_name" {
    description = "The name of the Cloud Storage bucket."
    type        = string
    default     = "konexa-cf-bucket-at"
}

variable "bucket_name" {
    description = "The name of the Cloud Storage bucket."
    type        = string
    default     = "konexa-source-bucket-at"
}

variable "bucket_schema_name" {
    description = "The name of the Cloud Storage bucket for schema."
    type        = string
    default     = "konexa-schema-bucket-at"
}

variable "function_name" {
    description = "The name of the Cloud Function."
    type        = string
    default     = "activate-dag-function-at"
}

variable "composer_env_name" {
    description = "The name of the Composer environment."
    type        = string
    default     = "konexa-env"
}

variable "dag_file_name" {
    description = "The name of the DAG file to be uploaded."
    type        = string
    default     = "dags/dag_process.py"
}

variable "dag_file" {
    description = "The path to the DAG file to be uploaded."
    type        = string
    default     = "../composer/dag_process.py"
}


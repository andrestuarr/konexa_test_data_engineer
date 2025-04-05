variable "cloud_function_bucket_name" {
  description = "The name of the Cloud Storage bucket."
  type        = string
}

variable "bucket_name" {
  description = "The name of the Cloud Storage bucket."
  type        = string
}

variable "bucket_schema_name" {
  description = "The name of the Cloud Storage bucket for schema."
  type        = string
}

variable "region" {
  description = "The region in which the resource should be created."
  type        = string
}

variable "dag_file_name" {
  description = "The name of the DAG file to be uploaded."
  type        = string
}

variable "dags_bucket" {
  description = "The name of the Cloud Storage bucket for DAGs."
  type        = string
}

variable "dag_file" {
  description = "The path to the DAG file to be uploaded."
  type        = string
}
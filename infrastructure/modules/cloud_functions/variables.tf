variable "function_name" {
    description = "The name of the Cloud Function."
    type        = string
}

variable "region" {
    description = "The region in which the resource should be created."
    type        = string
}

variable "project_id" {
    description = "The ID of the project in which the resource belongs."
    type        = string
}

variable "bucket_functions" {
    description = "The name of the Cloud Storage bucket for function code."
    type        = string
}

variable "object_function" {
    description = "The name of the object in the Cloud Storage bucket."
    type        = string
}

variable "composer_env_name" {
    description = "The name of the Composer environment."
    type        = string
}

variable "service_account" {
    description = "The service account that runs the function."
    type        = string
}

variable "trigger_bucket" {
    description = "The name of the Cloud Storage bucket that triggers the function."
    type        = string
}

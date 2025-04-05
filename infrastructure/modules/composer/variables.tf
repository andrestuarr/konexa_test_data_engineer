variable "region" {
  description = "The region in which the resource should be created."
  type        = string
}

variable "composer_env_name" {
  description = "The name of the Composer environment."
  type        = string
}

variable "service_account" {
  description = "The email of the service account to be used by the Composer environment."
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.28.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}